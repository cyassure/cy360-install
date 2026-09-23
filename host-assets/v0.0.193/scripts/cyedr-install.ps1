#Requires -Version 5.1
<#
.SYNOPSIS
    CyAssure 360 — CyEDR Agent Installer for Windows

.DESCRIPTION
    Installs CyEDR on Windows endpoints:
     • Sysmon64 with cyassure_sysmon_config.xml
     • YARA for on-demand file scanning
     • PowerShell Script Block Logging
     • CyEDR Python bridge daemon (Windows service via NSSM or sc.exe)

.PARAMETER Token
    Deployment token (required)

.PARAMETER Platform
    CyAssure 360 platform URL, e.g. https://cy360.example.com (required)

.PARAMETER AssetType
    Asset classification: workstation|server|database|domain_controller|api_gateway|jump_server
    Default: workstation

.PARAMETER Silent
    Non-interactive mode

.PARAMETER WithTray
    Switch: install the CyEDR system-tray app even on non-workstation asset types

.PARAMETER NoTray
    Switch: skip installing the system-tray app

.EXAMPLE
    iex ((New-Object Net.WebClient).DownloadString('https://cy360.example.com/api/edr/installer/win'))

.EXAMPLE
    .\cyedr-install.ps1 -Token "eyJ..." -Platform "https://cy360.example.com"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Token,

    [Parameter(Mandatory=$true)]
    [string]$Platform,

    [ValidateSet("workstation","server","database","domain_controller","api_gateway","jump_server")]
    [string]$AssetType = "workstation",

    [switch]$WithTray,
    [switch]$NoTray,
    [switch]$Silent,

    # Go-rewrite cutover — defaults to "go" as of 2026-09-07: Python EDR is
    # being fully discarded in favor of agent-go, and the platform no longer
    # builds/serves fresh Python binaries at all (see deploy.yml's
    # build-edr-macos if:false comment). "python" is still accepted but will
    # 404 against any release cut after this change. "go" requests agent-go's
    # binary from the same /api/edr/installer/agent-bundle route via its
    # impl=go query param — also the only way this has ever worked on
    # Windows ARM64 (no GitHub-hosted Windows ARM64 runner ever built a
    # PyInstaller target for it).
    [ValidateSet("python", "go")]
    [string]$Impl = "go"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

# ── Paths ─────────────────────────────────────────────────────────────────────
$EdrHome   = "C:\Program Files\CyAssure\edr"
$SysmonDir = "C:\Program Files\CyAssure\sysmon"
$LogFile   = "$EdrHome\logs\cyedr_agent.log"
$Platform  = $Platform.TrimEnd("/")
# Separate from $EdrHome on purpose: Set-AntiTamper below strips ALL access for
# BUILTIN\Users on $EdrHome (it holds config.json's enrollment token), which
# would make the tray binary unreadable/unrunnable for a standard user. This
# sibling directory inherits Program Files' default ACL (Users: Read & Execute)
# instead. The agent's IPC token/pipe live in yet another sibling, edr-ipc —
# see Config.ipc_dir's default in cyedr_agent.py — created by the agent
# itself at startup, not by this installer.
$TrayHome  = "C:\Program Files\CyAssure\edr-tray"

# ── Architecture detection ─────────────────────────────────────────────────────
$EdrArch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "x64" }

# ── Helpers ───────────────────────────────────────────────────────────────────
function Write-CyInfo  { param($m) Write-Host "[CyEDR] $m"  -ForegroundColor Cyan }
function Write-CyOk    { param($m) Write-Host "[CyEDR] $m"  -ForegroundColor Green }
function Write-CyWarn  { param($m) Write-Host "[CyEDR] WARN: $m" -ForegroundColor Yellow }
function Write-CyError { param($m) Write-Host "[CyEDR] ERROR: $m" -ForegroundColor Red; exit 1 }

function Download-File {
    param([string]$Url, [string]$Dest, [hashtable]$Headers = @{})
    $headers = @{ "Authorization" = "Bearer $Token" } + $Headers
    Invoke-WebRequest -Uri $Url -OutFile $Dest -Headers $headers -UseBasicParsing -TimeoutSec 120
}

function Invoke-ApiJson {
    param([string]$Method = "GET", [string]$Uri, [string]$Body = "")
    $headers = @{ "Authorization" = "Bearer $Token"; "Content-Type" = "application/json" }
    if ($Body) {
        return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body $Body -UseBasicParsing
    } else {
        return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -UseBasicParsing
    }
}

# ── Admin check ────────────────────────────────────────────────────────────────
function Assert-Admin {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object System.Security.Principal.WindowsPrincipal($id)
    if (-not $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-CyError "This script must run as Administrator. Right-click PowerShell → 'Run as Administrator'."
    }
    Write-CyInfo "Running as Administrator — OK"
}

# ── Create directories ─────────────────────────────────────────────────────────
function Initialize-Directories {
    Write-CyInfo "Creating CyEDR directories..."
    foreach ($d in @($EdrHome, "$EdrHome\logs", "$EdrHome\quarantine", "$EdrHome\ioc_cache",
                     "$EdrHome\yara_rules", $SysmonDir)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
    # Restrict access to SYSTEM and Administrators only
    $acl = Get-Acl $EdrHome
    $acl.SetAccessRuleProtection($true, $false)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "BUILTIN\Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule2)
    Set-Acl -Path $EdrHome -AclObject $acl
    Write-CyOk "Directories created"
}

# ── Download standalone CyEDR binary (PyInstaller, no Python needed) ───────────
function Install-EdrBinary {
    param([string]$Arch)
    Write-CyInfo "Downloading CyEDR agent binary ($Arch)..."
    $binDest = "$EdrHome\cyedr-agent.exe"

    # Try platform MSI first (enterprise/MDM path)
    $msiPath = "$env:TEMP\cyedr-agent-$Arch.msi"
    try {
        Download-File -Url "$Platform/edr-packages/cyedr-agent-latest-$Arch.msi" -Dest $msiPath
        Write-CyInfo "Installing CyEDR MSI package..."
        $r = Start-Process "msiexec.exe" `
            -ArgumentList "/i `"$msiPath`" /qn /l*v `"$EdrHome\logs\msi-install.log`"" `
            -Wait -PassThru -NoNewWindow
        Remove-Item $msiPath -Force -ErrorAction SilentlyContinue
        if ($r.ExitCode -eq 0) { Write-CyOk "CyEDR MSI installed"; return }
        Write-CyWarn "MSI exit code $($r.ExitCode) — falling back to binary download"
    } catch {
        Write-CyWarn "MSI download unavailable ($($_.Exception.Message)) — using binary bundle..."
    }

    # Fallback: download PyInstaller (or, with -Impl go, agent-go) one-file exe directly
    Download-File -Url "$Platform/api/edr/installer/agent-bundle?os=WINDOWS&arch=$Arch&impl=$Impl" `
        -Dest $binDest
    Write-CyOk "CyEDR agent binary downloaded → $binDest"
}

# ── Download CyEDR system-tray binary ───────────────────────────────────────────
function Install-TrayBinary {
    param([string]$Arch)
    if ($NoTray) {
        Write-CyInfo "System-tray install skipped (-NoTray)."
        return $null
    }
    if (-not $WithTray -and $AssetType -ne "workstation") {
        Write-CyInfo "System-tray install skipped (asset type '$AssetType' is not workstation; pass -WithTray to force)."
        return $null
    }
    Write-CyInfo "Downloading CyEDR system-tray binary ($Arch)..."
    New-Item -ItemType Directory -Path $TrayHome -Force | Out-Null
    $trayExe = "$TrayHome\cyedr-tray.exe"
    try {
        Download-File -Url "$Platform/api/edr/installer/tray-bundle?os=WINDOWS&arch=$Arch" -Dest $trayExe
        Write-CyOk "System-tray binary downloaded -> $trayExe"
        return $trayExe
    } catch {
        Write-CyWarn "Tray binary not available for WINDOWS/$Arch ($($_.Exception.Message)) — skipping tray install"
        return $null
    }
}

# ── Register tray auto-start for every user, at logon ───────────────────────────
function Install-TrayScheduledTask {
    param([string]$TrayExe)
    Write-CyInfo "Registering CyEDR tray auto-start (any user, at logon)..."
    try {
        Unregister-ScheduledTask -TaskName "CyEDR Tray" -Confirm:$false -ErrorAction SilentlyContinue
        $action    = New-ScheduledTaskAction -Execute $TrayExe
        # No -User on the trigger + a GroupId principal: this fires for ANY
        # user's logon and the task runs in that user's own session/token —
        # not as a fixed service account. Well-known pattern for per-user
        # startup tasks registered once machine-wide.
        $trigger   = New-ScheduledTaskTrigger -AtLogOn
        $principal = New-ScheduledTaskPrincipal -GroupId "S-1-5-32-545" -RunLevel Limited
        $settings  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
        Register-ScheduledTask -TaskName "CyEDR Tray" -Action $action -Trigger $trigger `
            -Principal $principal -Settings $settings -Force | Out-Null
        Write-CyOk "Tray scheduled task registered (starts for any user at logon)"
    } catch {
        Write-CyWarn "Could not register tray scheduled task: $_"
    }
}

# ── Install Sysmon ─────────────────────────────────────────────────────────────
function Install-Sysmon {
    Write-CyInfo "Installing Sysmon64..."

    # Download Sysmon from platform (pre-bundled in CyAssure)
    $sysmonExe    = "$SysmonDir\Sysmon64.exe"
    $sysmonConfig = "$SysmonDir\cyassure_sysmon_config.xml"

    try {
        Download-File -Url "$Platform/api/edr/installer/sysmon-exe" -Dest $sysmonExe
    } catch {
        # Fallback: Download from Sysinternals
        Write-CyWarn "Platform Sysmon bundle unavailable — downloading from Sysinternals..."
        Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" `
            -OutFile "$SysmonDir\Sysmon.zip" -UseBasicParsing -TimeoutSec 120
        Expand-Archive -Path "$SysmonDir\Sysmon.zip" -DestinationPath $SysmonDir -Force
        Remove-Item "$SysmonDir\Sysmon.zip" -Force
    }

    # Download CyAssure Sysmon config
    try {
        Download-File -Url "$Platform/api/edr/installer/sysmon-config" -Dest $sysmonConfig
    } catch {
        Write-CyWarn "Could not download sysmon config from platform — using embedded config"
        # Minimal embedded config (full config comes from platform)
        @'
<Sysmon schemaversion="4.90">
  <HashAlgorithms>SHA256</HashAlgorithms>
  <CheckRevocation/>
  <EventFiltering>
    <RuleGroup name="" groupRelation="or">
      <ProcessCreate onmatch="exclude">
        <Image condition="is">C:\Windows\System32\svchost.exe</Image>
      </ProcessCreate>
    </RuleGroup>
  </EventFiltering>
</Sysmon>
'@ | Out-File -FilePath $sysmonConfig -Encoding UTF8
    }

    # Install or update Sysmon
    # Sysmon is a best-effort log-collection enhancement, not a hard install
    # requirement — wrapped in try/catch (matching Install-Nmap's pattern
    # below) so a native Sysmon64.exe failure (bad/incompatible config,
    # crash, missing driver signing, etc.) degrades to a warning instead of
    # aborting the entire CyEDR install under this script's global
    # $ErrorActionPreference = "Stop". Real, previously-undisclosed gap:
    # confirmed on genuine Windows 11 x64 hardware (2026-09-06) that
    # Sysmon64.exe can exit with STATUS_STACK_BUFFER_OVERRUN
    # (-1073740791) parsing this platform's own bundled config — root
    # cause not yet isolated (schema 4.90 config vs. this Sysmon build's
    # native 4.91 schema is one candidate), tracked separately; this fix
    # only ensures that failure can never take down the whole install.
    try {
        $svc = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
        if ($svc) {
            Write-CyInfo "Updating existing Sysmon config..."
            & $sysmonExe -c $sysmonConfig 2>&1 | Out-Null
        } else {
            Write-CyInfo "Installing Sysmon64..."
            & $sysmonExe -accepteula -i $sysmonConfig 2>&1 | Out-Null
        }
    } catch {
        Write-CyWarn "Sysmon64 install/update failed: $_"
    }

    Start-Sleep -Seconds 2
    $svc = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq "Running") {
        Write-CyOk "Sysmon64 is running — event channel: Microsoft-Windows-Sysmon/Operational"
    } else {
        Write-CyWarn "Sysmon64 may not be running — check Event Viewer"
    }
}

# ── Install YARA ───────────────────────────────────────────────────────────────
function Install-Yara {
    Write-CyInfo "Installing YARA..."
    $yaraExe = "$EdrHome\yara64.exe"
    try {
        Download-File -Url "$Platform/api/edr/installer/yara-exe" -Dest $yaraExe
        Write-CyOk "YARA installed from platform"
    } catch {
        Write-CyWarn "YARA download failed — on-demand scanning will be unavailable"
    }
    # Download YARA rules
    try {
        Download-File -Url "$Platform/api/edr/installer/yara-rules" `
            -Dest "$EdrHome\yara_rules\cyassure.yar"
        Write-CyOk "YARA rules downloaded"
    } catch {
        Write-CyWarn "YARA rules download failed"
    }
}

# ── Optional nmap for Network Probe agents ────────────────────────────────────
function Install-Nmap {
    # nmap is only needed when this agent is designated as a Network Probe.
    # Install silently via winget or chocolatey if available; skip otherwise.
    $nmapExe = "C:\Program Files (x86)\Nmap\nmap.exe"
    if (Test-Path $nmapExe) {
        Write-CyOk "nmap already installed — Network Probe subnet scan ready"
        return
    }
    Write-CyInfo "Installing nmap (required for Network Probe subnet scan)..."
    $installed = $false
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            winget install --id Insecure.Nmap --silent --accept-package-agreements `
                --accept-source-agreements 2>&1 | Out-Null
            $installed = $true
            Write-CyOk "nmap installed via winget"
        } catch { }
    }
    if (-not $installed -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        try {
            choco install nmap -y --no-progress 2>&1 | Out-Null
            $installed = $true
            Write-CyOk "nmap installed via chocolatey"
        } catch { }
    }
    if (-not $installed) {
        Write-CyWarn "nmap not installed — Network Probe subnet scan unavailable. Install manually: https://nmap.org/download.html"
    }
}

# ── PowerShell Script Block Logging ───────────────────────────────────────────
function Enable-PSLogging {
    Write-CyInfo "Enabling PowerShell Script Block Logging..."
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "EnableScriptBlockLogging" -Value 1 -Type DWord
    Set-ItemProperty -Path $regPath -Name "EnableScriptBlockInvocationLogging" -Value 1 -Type DWord
    Write-CyOk "PowerShell Script Block Logging enabled (EventID 4104 → channel Microsoft-Windows-PowerShell/Operational)"
}

# ── Write CyEDR config.json ────────────────────────────────────────────────────
function Deploy-Agent {
    Write-CyInfo "Writing CyEDR agent config..."

    # Write config
    $hostname  = $env:COMPUTERNAME
    $agentIp   = (Get-NetIPAddress -AddressFamily IPv4 |
                  Where-Object { $_.InterfaceAlias -notmatch "Loopback" } |
                  Select-Object -First 1).IPAddress
    $cfgObj = @{
        platform_url       = $Platform
        deploy_token       = $Token
        asset_type         = $AssetType
        hostname           = $hostname
        os_type            = "WINDOWS"
        edr_home           = $EdrHome
        poll_interval      = 60
        heartbeat_interval = 60
        telemetry_batch    = 20
        yara_binary        = "$EdrHome\yara64.exe"
        yara_rules         = "$EdrHome\yara_rules\cyassure.yar"
        quarantine_dir     = "$EdrHome\quarantine"
        ioc_cache          = "$EdrHome\ioc_cache\ioc.json"
        log_file           = $LogFile
        sysmon_channel     = "Microsoft-Windows-Sysmon/Operational"
    }
    # Out-File -Encoding UTF8 always prepends a UTF-8 BOM on Windows PowerShell
    # 5.1 (fixed only in PowerShell 7+'s "utf8NoBOM") — Go's encoding/json
    # does not skip a BOM, so cyedr-agent.exe crashed on every launch with
    # "config load failed: invalid character '﻿' looking for beginning
    # of value" (confirmed on genuine Windows 11 x64 hardware, 2026-09-06).
    # [IO.File]::WriteAllText with an explicit BOM-less UTF8Encoding avoids it.
    $cfgJson = $cfgObj | ConvertTo-Json -Depth 5
    [IO.File]::WriteAllText("$EdrHome\config.json", $cfgJson, (New-Object Text.UTF8Encoding $false))

    Write-CyOk "Agent deployed to $EdrHome"
}

# ── Enroll with platform ───────────────────────────────────────────────────────
function Invoke-Enrollment {
    Write-CyInfo "Enrolling with CyAssure 360 platform..."
    $hostname = $env:COMPUTERNAME
    $agentIp  = (Get-NetIPAddress -AddressFamily IPv4 |
                 Where-Object { $_.InterfaceAlias -notmatch "Loopback" } |
                 Select-Object -First 1).IPAddress

    # Detect default gateway MAC at install time (trusted corporate environment).
    # Seeds network zone auto-learning so the server can auto-suggest approval.
    $gwIp  = ""
    $gwMac = ""
    try {
        $gwIp = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object RouteMetric |
                 Select-Object -First 1).NextHop
        if ($gwIp) {
            $neighbor = Get-NetNeighbor -IPAddress $gwIp -ErrorAction SilentlyContinue |
                        Select-Object -First 1
            if ($neighbor) {
                $gwMac = $neighbor.LinkLayerAddress.ToUpper().Replace("-", ":")
            }
        }
    } catch {
        Write-CyWarn "Could not detect gateway MAC — zone auto-learning will rely on heartbeat"
    }

    # Matches cyedr-install.sh's HW_UUID (ioreg/machine-id/product_uuid) —
    # the server dedupes/updates an existing agent row by hardware_uuid (then
    # hostname) on re-enrollment; without it, every Windows reinstall was
    # silently creating a duplicate agent row instead of updating the old one.
    $hwUuid = ""
    try {
        $hwUuid = (Get-CimInstance -ClassName Win32_ComputerSystemProduct -ErrorAction Stop).UUID
    } catch {
        Write-CyWarn "Could not detect hardware UUID — hostname will be used for deduplication"
    }

    $body = @{
        deployment_token = $Token
        hostname    = $hostname
        os_type     = "WINDOWS"
        asset_type  = $AssetType
        agent_ip    = "$agentIp"
        version     = "1.0.0"
        gateway_ip  = "$gwIp"
        gateway_mac = "$gwMac"
        hardware_uuid = "$hwUuid"
        build_source = $Impl
    } | ConvertTo-Json

    try {
        $resp = Invoke-ApiJson -Method POST -Uri "$Platform/api/edr/agents/self-enroll" -Body $body
        $agentId = $resp.agent_id
        $enrollToken = $resp.enrollment_token
        if (-not $agentId) { Write-CyError "Enrollment response missing agent_id: $resp" }
        if (-not $enrollToken) { Write-CyError "Enrollment response missing enrollment_token: $resp" }

        # Update config with agent_id AND the per-agent enrollment_token — without the
        # latter, the agent falls back to the shared deploy_token for heartbeat/telemetry
        # auth, which never matches the server's per-agent token and 401s permanently.
        $cfg = Get-Content "$EdrHome\config.json" | ConvertFrom-Json
        $cfg | Add-Member -NotePropertyName "agent_id" -NotePropertyValue $agentId -Force
        $cfg | Add-Member -NotePropertyName "enrollment_token" -NotePropertyValue $enrollToken -Force
        # BOM-less write — see Deploy-Agent's identical fix for why.
        $cfgJson = $cfg | ConvertTo-Json -Depth 5
        [IO.File]::WriteAllText("$EdrHome\config.json", $cfgJson, (New-Object Text.UTF8Encoding $false))

        Write-CyOk "Enrolled — Agent ID: $agentId"
    } catch {
        Write-CyError "Enrollment failed: $_"
    }
}

# ── Install Windows Service ────────────────────────────────────────────────────
function Install-WindowsService {
    Write-CyInfo "Installing CyEDR Windows service..."

    $agentExe    = "$EdrHome\cyedr-agent.exe"
    $svcName     = "CyEDRAgent"
    $displayName = "CyAssure 360 EDR Agent"
    $description = "CyAssure 360 endpoint detection and response agent"

    # Remove existing service if present
    $existing = Get-Service -Name $svcName -ErrorAction SilentlyContinue
    if ($existing) {
        Stop-Service -Name $svcName -Force -ErrorAction SilentlyContinue
        sc.exe delete $svcName | Out-Null
        Start-Sleep -Seconds 2
    }

    # Skip service creation if the MSI already installed it
    $afterMsi = Get-Service -Name $svcName -ErrorAction SilentlyContinue
    if ($afterMsi) {
        Write-CyOk "Service '$svcName' already present (installed by MSI)"
        return
    }

    # Try NSSM first (proper service wrapper), fallback to sc.exe/New-Service.
    #
    # NSSM is not optional cosmetics here — cyedr-agent.exe (both the Python
    # and Go builds) implements no native Windows Service Control Manager
    # protocol at all (no StartServiceCtrlDispatcher). Confirmed on genuine
    # Windows 11 x64 hardware (2026-09-06): registering the bare exe directly
    # via sc.exe/New-Service creates a service that times out 30s after every
    # start attempt (System log Event ID 7009, "timeout waiting for the
    # service to connect") because the process never checks in with the SCM
    # — it just runs as an ordinary console program and is killed. NSSM
    # bridges an arbitrary console exe to the SCM's expected protocol; without
    # it, the "service" this installer creates can never actually run.
    $nssmCmd = Get-Command "nssm" -ErrorAction SilentlyContinue
    $nssmExe = if ($nssmCmd) { $nssmCmd.Source } else { $null }
    if (-not $nssmExe) {
        Write-CyInfo "nssm not found locally — downloading (required for cyedr-agent.exe to run as a real Windows service)..."
        try {
            $nssmZip = "$env:TEMP\nssm.zip"
            $nssmDir = "$EdrHome\..\nssm"
            Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile $nssmZip -UseBasicParsing -TimeoutSec 120
            Expand-Archive -Path $nssmZip -DestinationPath $nssmDir -Force
            Remove-Item $nssmZip -Force -ErrorAction SilentlyContinue
            $wantArch = if ([Environment]::Is64BitOperatingSystem) { "win64" } else { "win32" }
            $nssmExe = Get-ChildItem -Path $nssmDir -Filter "nssm.exe" -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.DirectoryName -match $wantArch } |
                Select-Object -First 1 -ExpandProperty FullName
            if ($nssmExe) {
                Write-CyOk "nssm downloaded: $nssmExe"
            } else {
                Write-CyWarn "nssm.zip did not contain a $wantArch\nssm.exe — falling back to a bare service registration cyedr-agent.exe cannot actually respond to"
            }
        } catch {
            Write-CyWarn "Could not download nssm ($($_.Exception.Message)) — falling back to a bare service registration cyedr-agent.exe cannot actually respond to"
        }
    }

    if ($nssmExe) {
        Write-CyInfo "Using NSSM to create service..."
        # Pass a bare relative filename, not the quoted absolute path.
        # Confirmed on genuine Windows 11 x64 hardware (2026-09-06):
        # PowerShell's argument marshalling to nssm.exe (a native process
        # invoked via `&`) silently drops embedded literal double-quotes
        # around "--config `"$EdrHome\config.json`"" before nssm ever sees
        # them — `nssm get <svc> AppParameters` came back as the unquoted
        # `--config C:\Program Files\CyAssure\edr\config.json`, so the agent
        # received "C:\Program" as its whole --config value (space-truncated)
        # and exited immediately (`config load failed: open C:\Program`),
        # which NSSM then endlessly restart-looped. AppDirectory is already
        # set to $EdrHome below, so a bare relative filename needs no
        # quoting at all and sidesteps this whole class of bug.
        & $nssmExe install $svcName $agentExe "--config config.json"
        & $nssmExe set $svcName DisplayName  $displayName
        & $nssmExe set $svcName Description  $description
        & $nssmExe set $svcName AppDirectory $EdrHome
        & $nssmExe set $svcName AppStdout    $LogFile
        & $nssmExe set $svcName AppStderr    $LogFile
        & $nssmExe set $svcName Start        SERVICE_AUTO_START
        & $nssmExe set $svcName AppRestartDelay 10000
    } else {
        # sc.exe's own hand-rolled command-line parser cannot reliably take a
        # binPath value with embedded spaces from PowerShell's argument
        # passing — confirmed on genuine Windows 11 x64 hardware (2026-09-06):
        # `sc.exe create ... binPath= "<path with spaces>" ...` returned exit
        # code 1639 (ERROR_INVALID_COMMAND_LINE) and printed sc.exe's own
        # USAGE text, meaning it never parsed ANY of the key=value pairs —
        # so no service was ever actually registered via this fallback path,
        # for either agent, on any real Windows box before this fix.
        # New-Service (built into Windows PowerShell 5.1) takes
        # -BinaryPathName as a real parameter and handles the quoting itself.
        $binPath = "`"$agentExe`" --config `"$EdrHome\config.json`""
        try {
            New-Service -Name $svcName -BinaryPathName $binPath -DisplayName $displayName `
                -Description $description -StartupType Automatic -ErrorAction Stop | Out-Null
        } catch {
            Write-CyError "Failed to create Windows service: $_"
        }
        sc.exe failure $svcName reset= 86400 actions= restart/10000/restart/30000/restart/60000 | Out-Null
    }

    sc.exe config $svcName start= delayed-auto | Out-Null
    Write-CyOk "Windows service '$svcName' created"
}

# ── Anti-tamper: protect CyEDR files ──────────────────────────────────────────
function Set-AntiTamper {
    Write-CyInfo "Applying anti-tamper protections..."

    # Prevent non-admin processes from writing to EDR home
    $acl = Get-Acl $EdrHome
    $deny = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "BUILTIN\Users", "Write,Delete,Modify",
        "ContainerInherit,ObjectInherit", "None", "Deny")
    $acl.AddAccessRule($deny)
    Set-Acl -Path $EdrHome -AclObject $acl

    # Windows Event Log: log CyEDR service tamper attempts
    # Rule ID 101031 reserved for service-stop tamper detection (historical —
    # cy_cust_rules.xml that would have fired on it was removed 2026-07-27,
    # see CLAUDE.md; no rule currently consumes this event)
    Write-CyOk "Anti-tamper ACLs applied"
}

# ── Start service ──────────────────────────────────────────────────────────────
function Start-CyEDRService {
    Write-CyInfo "Starting CyEDR agent service..."
    Start-Service -Name "CyEDRAgent" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    $svc = Get-Service -Name "CyEDRAgent" -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq "Running") {
        Write-CyOk "CyEDRAgent service is running"
    } else {
        Write-CyWarn "Service may not be running — check: Get-EventLog Application -Source CyEDRAgent"
    }
}

# ── Summary ────────────────────────────────────────────────────────────────────
function Show-Summary {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host " CyEDR Agent Installation Complete                    " -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Platform:   $Platform"
    Write-Host "  Agent home: $EdrHome"
    Write-Host "  Logs:       $LogFile"
    Write-Host ""
    Write-Host "  Status: Get-Service CyEDRAgent" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Sysmon is active: Microsoft-Windows-Sysmon/Operational" -ForegroundColor Cyan
    if (Test-Path "$TrayHome\cyedr-tray.exe") {
        Write-Host ""
        Write-Host "  Tray:       $TrayHome\cyedr-tray.exe (starts automatically at next logon, any user)" -ForegroundColor Cyan
        # Printed here permanently, not only inside the tray's dialogs — by the
        # time someone needs this, the tray may be showing the unreachable/red
        # state and this may be the only place it's written down.
        Write-Host "  Restart if stopped: use `"Start CyEDR...`" in the tray menu" -ForegroundColor Cyan
        Write-Host "              (asks for the CyEDR admin password, then a Windows UAC prompt)" -ForegroundColor Cyan
        Write-Host "              or from an elevated/Administrator PowerShell:" -ForegroundColor Cyan
        Write-Host "              sc start CyEDRAgent" -ForegroundColor Cyan
    }
    Write-Host "  Next: View endpoint in CyAssure 360 > Endpoint Fleet" -ForegroundColor Yellow
    Write-Host ""
}

# ── Main ───────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ██████╗██╗   ██╗     ███████╗██████╗ ██████╗ " -ForegroundColor Blue
Write-Host " ██╔════╝╚██╗ ██╔╝     ██╔════╝██╔══██╗██╔══██╗" -ForegroundColor Blue
Write-Host " ██║      ╚████╔╝      █████╗  ██║  ██║██████╔╝" -ForegroundColor Blue
Write-Host " ╚██████╗   ██║███████╗███████╗██████╔╝██║  ██║" -ForegroundColor Blue
Write-Host "  ╚═════╝   ╚╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝" -ForegroundColor Blue
Write-Host ""
Write-Host "  CyAssure 360 — CyEDR Endpoint Defense  |  FROM SIGNALS TO STRENGTH" -ForegroundColor Cyan
Write-Host "  Arch: $EdrArch" -ForegroundColor DarkGray
Write-Host ""

Assert-Admin
Initialize-Directories
Install-EdrBinary -Arch $EdrArch
Install-Sysmon
Install-Yara
Install-Nmap
Enable-PSLogging
Deploy-Agent
# Invoke-Enrollment must run before Set-AntiTamper: enrollment writes
# agent_id/enrollment_token back into config.json, but Set-AntiTamper denies
# Write/Delete/Modify on $EdrHome for BUILTIN\Users — a group the installing
# account belongs to even when it's also a local Administrator (NTFS DENY
# ACEs apply regardless of admin membership). Reversed, every real install
# failed enrollment with "Access to the path ... config.json is denied"
# (confirmed on genuine Windows 11 x64 hardware, 2026-09-06 — the first time
# this installer had ever actually run against real Windows).
Invoke-Enrollment
Set-AntiTamper
Install-WindowsService
$TrayExePath = Install-TrayBinary -Arch $EdrArch
if ($TrayExePath) { Install-TrayScheduledTask -TrayExe $TrayExePath }
Start-CyEDRService
Show-Summary
