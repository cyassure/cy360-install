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
    if ($nssm) { & nssm remove CyEDRAgent confirm 2>&1 | Out-Null }
    sc.exe delete CyEDRAgent | Out-Null
    Write-CyOk "CyEDRAgent service removed"
} else {
    Write-CyInfo "CyEDRAgent service not present"
}

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
Write-CyOk "Tray scheduled task removed"

# ── Revert PowerShell Script Block Logging policy (set by CyEDR installer) ───
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
if (Test-Path $regPath) {
    Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-CyOk "PowerShell Script Block Logging policy removed"
}

# ── Remove all CyEDR files and directories ───────────────────────────────────
foreach ($dir in @($EdrHome, $TrayHome, $SysmonDir, $IpcDir)) {
    if (Test-Path $dir) {
        # Anti-tamper ACLs from the installer deny BUILTIN\Users write/delete
        # but not Administrators/SYSTEM — Remove-Item as Administrator succeeds.
        Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Write-CyOk "Removed $EdrHome, $TrayHome, $SysmonDir, $IpcDir"

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
