#Requires -Version 5.1
<#
.SYNOPSIS
    CyAssure 360 — CyEDR Agent FORCE Uninstaller for Windows

.DESCRIPTION
    Removes CyEDR completely from this Windows endpoint: stops and deletes
    the CyEDRAgent service, Sysmon64, the tray scheduled task, the
    PowerShell Script Block Logging policy, and every file/directory
    cyedr-install.ps1 ever created — so a subsequent install starts clean.

    This is destructive and irreversible on this host. Local logs,
    quarantined files, and IOC/policy state are deleted. The agent's
    platform-side history (past detections, alerts, cases) is NOT touched —
    only local endpoint state. Every step is best-effort: a missing
    service/file is not a failure, and later steps still run even if an
    earlier one errors.

.PARAMETER Force
    Required switch — confirms you intend to force-remove CyEDR.

.EXAMPLE
    $u="https://cy360.example.com/api/edr/installer/uninstall-win"
    $f="$env:TEMP\cyedr-uninstall.ps1"
    Invoke-WebRequest -Uri $u -OutFile $f -UseBasicParsing
    & $f -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"   # force uninstall: keep going even if one step fails
$ProgressPreference    = "SilentlyContinue"

$EdrHome   = "C:\Program Files\CyAssure\edr"
$TrayHome  = "C:\Program Files\CyAssure\edr-tray"
$SysmonDir = "C:\Program Files\CyAssure\sysmon"
$IpcDir    = "C:\Program Files\CyAssure\edr-ipc"
# The installer unpacks nssm here (not on PATH) to run the agent as a service.
$NssmDir   = "C:\Program Files\CyAssure\nssm"

function Write-CyInfo  { param($m) Write-Host "[CyEDR] $m"  -ForegroundColor Cyan }
function Write-CyOk    { param($m) Write-Host "[CyEDR] $m"  -ForegroundColor Green }
function Write-CyWarn  { param($m) Write-Host "[CyEDR] WARN: $m" -ForegroundColor Yellow }
function Write-CyError { param($m) Write-Host "[CyEDR] ERROR: $m" -ForegroundColor Red; exit 1 }

function Assert-Admin {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object System.Security.Principal.WindowsPrincipal($id)
    if (-not $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-CyError "This script must run as Administrator. Right-click PowerShell -> 'Run as Administrator'."
    }
}

if (-not $Force) {
    Write-CyError "Refusing to run without -Force (this permanently removes CyEDR and all local agent state)"
}

Assert-Admin

# ── Tamper protection gate (2026-09-15) ──────────────────────────────────────
# tamper_protection.protect_uninstall was declared in POLICY_DEFAULTS
# (defaulting true) and exposed as its own live portal toggle, but this
# script never checked it — a -Force uninstall always proceeded regardless
# of policy, confirmed by grep before this fix (same gap cyedr-uninstall.sh
# had). Checked here, before anything is stopped or removed, by shelling
# out to the agent binary's own --verify-tamper-password-uninstall mode —
# a one-shot local password check reusing the exact bcrypt/lockout logic
# the tray's Stop/Exit action already gates on
# (internal/response/tamper.go's VerifyTamperPasswordForUninstall). If the
# agent binary or config.json is missing, the gate is skipped — nothing to
# verify against.
$AgentBin = "$EdrHome\cyedr-agent.exe"
if ((Test-Path $AgentBin) -and (Test-Path "$EdrHome\config.json")) {
    if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
        $securePwd = Read-Host -Prompt "This host has tamper protection configured. If it requires a password to uninstall, enter it now (leave blank if none)" -AsSecureString
        $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
        $tamperPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    } else {
        # Non-interactive invocation: no console to prompt on. Pass an empty
        # password through the same gate rather than skipping it silently —
        # a host with protect_uninstall=true and a real password set
        # correctly rejects an empty guess below, so this can't bypass the
        # gate, only fail it the same way a wrong guess would.
        $tamperPassword = ""
    }
    $tamperDetail = $tamperPassword | & $AgentBin --config "$EdrHome\config.json" --verify-tamper-password-uninstall 2>&1
    $tamperStatus = $LASTEXITCODE
    Remove-Variable tamperPassword -ErrorAction SilentlyContinue
    if ($tamperStatus -ne 0) {
        Write-CyError "Tamper protection blocked this uninstall: $tamperDetail"
    }
    if ($tamperDetail -ne "no admin password configured") {
        Write-CyOk "Tamper protection: $tamperDetail"
    }
}

Write-Host ""
Write-Host "[CyEDR] Force-uninstalling CyEDR from this Windows host..." -ForegroundColor Cyan

# ── Kill any running CyEDR/tray processes first ──────────────────────────────
Get-Process -Name "cyedr-agent","cyedr-tray" -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue
Write-CyOk "Any running CyEDR processes killed"

# ── Stop + remove the CyEDRAgent service ─────────────────────────────────────
$svc = Get-Service -Name "CyEDRAgent" -ErrorAction SilentlyContinue
if ($svc) {
    Stop-Service -Name "CyEDRAgent" -Force -ErrorAction SilentlyContinue
    $nssm = Get-Command "nssm" -ErrorAction SilentlyContinue
    $nssmPath = if ($nssm) { $nssm.Source } else {
        Get-ChildItem -LiteralPath $NssmDir -Filter "nssm.exe" -Recurse -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName
    }
    if ($nssmPath) { & $nssmPath remove CyEDRAgent confirm 2>&1 | Out-Null }
    sc.exe delete CyEDRAgent | Out-Null
    Write-CyOk "CyEDRAgent service removed"
} else {
    Write-CyInfo "CyEDRAgent service not present"
}
# Only CyEDR's own copy of nssm: another product's nssm services are left alone.
# A copy still running blocks deleting its folder and the next install.
Get-CimInstance Win32_Process -Filter "Name='nssm.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.ExecutablePath -and $_.ExecutablePath.StartsWith($NssmDir, [StringComparison]::OrdinalIgnoreCase) } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }

# ── Stop + remove Sysmon64 (installed by CyEDR on this platform) ─────────────
$sysmonExe = "$SysmonDir\Sysmon64.exe"
$sysmonSvc = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
if ($sysmonSvc) {
    if (Test-Path $sysmonExe) {
        & $sysmonExe -u force 2>&1 | Out-Null
    } else {
        Stop-Service -Name "Sysmon64" -Force -ErrorAction SilentlyContinue
        sc.exe delete Sysmon64 | Out-Null
    }
    Write-CyOk "Sysmon64 removed"
} else {
    Write-CyInfo "Sysmon64 service not present"
}

# ── Remove tray scheduled task ────────────────────────────────────────────────
Unregister-ScheduledTask -TaskName "CyEDR Tray" -Confirm:$false -ErrorAction SilentlyContinue
foreach ($task in @("CyEDR-AutoUpdate", "CyEDR-DeepScan", "CyEDR-RansomwareSnapshot")) {
    Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
}
# Decoy files the ransomware detector planted in each user's folders.
Get-ChildItem "$env:SystemDrive\Users\*\*\.~cyassure-decoy-*" -Force -File -ErrorAction SilentlyContinue |
    Remove-Item -Force -ErrorAction SilentlyContinue
# The agent's folder is gone, so its attack surface exemption goes too.
Remove-MpPreference -AttackSurfaceReductionOnlyExclusions $EdrHome -ErrorAction SilentlyContinue
# What policies applied to this endpoint: a removed agent must not leave USB
# disks read-only, firewall rules blocking traffic or domains sinkholed.
$rsd = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices"
Remove-ItemProperty -Path $rsd -Name "Deny_All" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "$rsd\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" -Name "Deny_Write" -ErrorAction SilentlyContinue
# The rest of device control, put back the way the agent's own "allow" does
# (found left blocked after uninstall on the Windows test VM, 2026-11-07).
Remove-ItemProperty -Path "$rsd\{53f56308-b6bf-11d0-94f2-00a0c91efb8b}" -Name "Deny_Read", "Deny_Write" -ErrorAction SilentlyContinue  # CD/DVD
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Camera" -Name "AllowCamera" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessMicrophone" -ErrorAction SilentlyContinue
Get-PnpDevice -Class Bluetooth -PresentOnly -ErrorAction SilentlyContinue |
    Where-Object { $_.InstanceId -notmatch '^BTH' -and $_.ConfigManagerErrorCode -eq 22 } |
    Enable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue
Get-NetAdapter -Physical -ErrorAction SilentlyContinue |
    Where-Object { $_.NdisPhysicalMedium -eq 9 -and $_.Status -eq "Disabled" } |
    Enable-NetAdapter -Confirm:$false -ErrorAction SilentlyContinue
if (Get-Command netsh -ErrorAction SilentlyContinue) {
    $prevPref = $ErrorActionPreference; $ErrorActionPreference = "Continue"
    netsh wlan delete filter permission=denyall networktype=infrastructure *> $null
    $ErrorActionPreference = $prevPref
}
Get-CimInstance Win32_Printer -ErrorAction SilentlyContinue | Where-Object { $_.PrinterState -band 1 } |
    ForEach-Object { Invoke-CimMethod -InputObject $_ -MethodName Resume -ErrorAction SilentlyContinue | Out-Null }
$prevPref = $ErrorActionPreference; $ErrorActionPreference = "Continue"
# Reset the firewall default only if CyEDR's rules were in force: otherwise it
# is the customer's own setting.
if (Get-NetFirewallRule -DisplayName "CyEDR-Policy", "CyEDR-Isolation" -ErrorAction SilentlyContinue) {
    netsh advfirewall firewall delete rule name=CyEDR-Policy *> $null
    netsh advfirewall firewall delete rule name=CyEDR-Isolation *> $null
    netsh advfirewall set allprofiles firewallpolicy "blockinbound,allowoutbound" *> $null
}
$ErrorActionPreference = $prevPref
$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
if (Select-String -Path $hostsFile -Pattern "BEGIN CyEDR-SINKHOLE" -Quiet -ErrorAction SilentlyContinue) {
    $hostsText = [IO.File]::ReadAllText($hostsFile)
    $hostsText = [regex]::Replace($hostsText, "(?s)\r?\n?# BEGIN CyEDR-SINKHOLE.*?# END CyEDR-SINKHOLE\r?\n?", "`r`n")
    [IO.File]::WriteAllText($hostsFile, $hostsText)
    $prevPref = $ErrorActionPreference; $ErrorActionPreference = "Continue"
    ipconfig /flushdns *> $null
    $ErrorActionPreference = $prevPref
}
Write-CyOk "Tray scheduled task removed"

# ── Revert PowerShell Script Block Logging policy (set by CyEDR installer) ───
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
if (Test-Path $regPath) {
    Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-CyOk "PowerShell Script Block Logging policy removed"
}

# ── Forced proxy ─────────────────────────────────────────────────────────────
# The agent records the machine-wide proxy it set and what was there before
# (proxy_windows.json). Put that back, only while CyEDR's proxy is still the
# one in force, so a proxy set by someone else since is left alone (2026-11-08).
$proxyState = Join-Path $EdrHome "proxy_windows.json"
if (Test-Path $proxyState) {
    try {
        $st = Get-Content $proxyState -Raw | ConvertFrom-Json
        $connKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"
        $polKey  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings"
        $b = (Get-ItemProperty -Path $connKey -Name DefaultConnectionSettings -ErrorAction SilentlyContinue).DefaultConnectionSettings
        $current = ""
        if ($b -and $b.Length -ge 16 -and ([BitConverter]::ToInt32($b, 8) -band 2)) {
            $current = [Text.Encoding]::ASCII.GetString($b, 16, [BitConverter]::ToInt32($b, 12))
        }
        if ($current -and $current -ieq $st.server) {
            if ($st.prev_blob) {
                New-ItemProperty -Path $connKey -Name DefaultConnectionSettings -PropertyType Binary -Value ([Convert]::FromBase64String($st.prev_blob)) -Force | Out-Null
            } else {
                Remove-ItemProperty -Path $connKey -Name DefaultConnectionSettings -ErrorAction SilentlyContinue
            }
            if ($st.prev_policy) {
                New-ItemProperty -Path $polKey -Name ProxySettingsPerUser -PropertyType DWord -Value ([int]$st.prev_policy) -Force | Out-Null
            } else {
                Remove-ItemProperty -Path $polKey -Name ProxySettingsPerUser -ErrorAction SilentlyContinue
            }
            Write-CyOk "Proxy CyEDR set removed"
        }
    } catch {
        Write-CyWarn "Could not restore the proxy setting: $_"
    }
}

# ── Remove all CyEDR files and directories ───────────────────────────────────
# A program that has just exited can stay locked for a while, or until restart,
# while Windows still holds its process (seen with nssm.exe on Windows Server
# 2025: "access denied" for an Administrator with no process running it). A
# locked file can still be moved, so it goes to Windows\Temp and Windows deletes
# it at the next restart; the CyEDR folders themselves are removed now.
$deleteAtRestart = $null
try {
    $deleteAtRestart = Add-Type -PassThru -Name CyEdrMoveFile -Namespace CyEdr -MemberDefinition @'
[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
public static extern bool MoveFileEx(string existing, string newName, int flags);
'@
} catch { }
$pendingRestart = 0
$dirs = @($EdrHome, $TrayHome, $SysmonDir, $IpcDir, $NssmDir)
foreach ($dir in $dirs) {
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    # Anti-tamper ACLs from the installer deny BUILTIN\Users write/delete
    # but not Administrators/SYSTEM — Remove-Item as Administrator succeeds.
    for ($i = 0; $i -lt 5 -and (Test-Path -LiteralPath $dir); $i++) {
        if ($i -gt 0) { Start-Sleep -Seconds 2 }
        Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    foreach ($file in @(Get-ChildItem -LiteralPath $dir -Recurse -File -Force -ErrorAction SilentlyContinue)) {
        $dest = Join-Path $env:SystemRoot ("Temp\CyEDR-leftover-" + [guid]::NewGuid().ToString("N") + $file.Extension)
        try {
            Move-Item -LiteralPath $file.FullName -Destination $dest -Force -ErrorAction Stop
            # MOVEFILE_DELAY_UNTIL_REBOOT; [NullString]::Value, because $null reaches
            # a string parameter as "" and Windows then answers "path not found".
            if ($deleteAtRestart -and $deleteAtRestart::MoveFileEx($dest, [NullString]::Value, 4)) { $pendingRestart++ }
        } catch { }
    }
    Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue
}
$left = @($dirs | Where-Object { Test-Path -LiteralPath $_ })
$parent = "C:\Program Files\CyAssure"
if ((Test-Path -LiteralPath $parent) -and -not (Get-ChildItem -LiteralPath $parent -Force -ErrorAction SilentlyContinue)) {
    Remove-Item -LiteralPath $parent -Force -ErrorAction SilentlyContinue
}
if ($left.Count -eq 0) {
    Write-CyOk "Removed $EdrHome, $TrayHome, $SysmonDir, $IpcDir, $NssmDir"
} else {
    Write-CyWarn "Could not remove $($left -join ', '): delete them after a restart"
}
if ($pendingRestart -gt 0) {
    Write-CyInfo "$pendingRestart file(s) Windows still had locked were moved to $env:SystemRoot\Temp and are deleted at the next restart"
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host " CyEDR Agent Uninstalled                             " -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "  This endpoint is clean of all CyEDR agent/tray/Sysmon state."
Write-Host "  It will still show as 'disconnected' in Endpoint Fleet until either"
Write-Host "  removed there manually, or superseded by a fresh enrollment below."
Write-Host ""
Write-Host "  To reinstall: run the CyEDR install command from Agent Installer > Install."
Write-Host ""
