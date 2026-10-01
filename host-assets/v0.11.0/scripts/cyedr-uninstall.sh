#!/usr/bin/env bash
# CyAssure 360 — CyEDR Agent FORCE Uninstaller (Linux / macOS)
#
# Removes CyEDR completely from this endpoint: stops and deletes the agent
# service, tray, watchdog, auditd rules, and every file/directory
# cyedr-install.sh ever created — so a subsequent install starts clean.
#
# This is destructive and irreversible on this host. Local logs, quarantined
# files, and IOC/policy state are deleted. The agent's platform-side history
# (past detections, alerts, cases) is NOT touched — only local endpoint state.
# Every step is best-effort (no `set -e`): a missing service/file is not a
# failure, and later steps still run even if an earlier one errors.
#
# Usage:
#   curl -fsSL https://<platform>/api/edr/installer/uninstall-unix | sudo bash -s -- --force
#
#   Options:
#     --force     Required — confirms you intend to force-remove CyEDR
#     --help      Show this help

set -uo pipefail

RED='\033[0;31m'; YEL='\033[1;33m'; GRN='\033[0;32m'; BLU='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLU}[CyEDR]${NC} $*"; }
ok()    { echo -e "${GRN}[CyEDR]${NC} $*"; }
warn()  { echo -e "${YEL}[CyEDR]${NC} $*"; }
die()   { echo -e "${RED}[CyEDR ERROR]${NC} $*" >&2; exit 1; }

FORCE=false
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --help|-h)
            grep '^#' "$0" | grep -v '#!/' | sed 's/^# //' | sed 's/^#//'
            exit 0 ;;
    esac
done
[[ "$FORCE" != "true" ]] && die "Refusing to run without --force (this permanently removes CyEDR and all local agent state)"
[[ "$EUID" -ne 0 ]] && die "Must run as root (sudo bash $0 --force)"

EDR_HOME="/opt/cyassure/edr"
TRAY_HOME="/opt/cyassure/edr-tray"
IPC_DIR="/opt/cyassure/edr-ipc"
EDR_USER="cyedr"

OS_TYPE="$(uname -s)"
case "$OS_TYPE" in
    Linux)  OS_KEY="LINUX" ;;
    Darwin) OS_KEY="MACOS" ;;
    *) die "Unsupported OS: $OS_TYPE. Use cyedr-uninstall.ps1 for Windows." ;;
esac

# ── Tamper protection gate (2026-09-15) ─────────────────────────────────────
# tamper_protection.protect_uninstall was declared in POLICY_DEFAULTS
# (defaulting true, since 2026-08 or earlier) and exposed as its own live
# portal toggle, but this script never checked it — a --force uninstall
# always proceeded regardless of policy, confirmed by grep before this fix.
# Checked here, before any service is stopped or file removed, by shelling
# out to the agent binary's own --verify-tamper-password-uninstall mode
# (cmd/cyedr-agent/main.go) — a one-shot local password check that reuses
# the exact bcrypt/lockout logic the tray's Stop/Exit action already gates
# on (internal/response/tamper.go's VerifyTamperPasswordForUninstall), so
# "tamper protection" means the same thing everywhere it's enforced. If the
# agent binary or config.json is missing (partial/already-broken install,
# or this host never had a tamper_protection policy pushed at all), the
# gate is skipped — nothing to verify against, and blocking a genuinely
# broken install's cleanup would be worse than the gap this closes.
AGENT_BIN="$EDR_HOME/cyedr-agent"
if [[ "$OS_KEY" == "MACOS" ]]; then
    AGENT_BIN="$EDR_HOME/CyEDR.app/Contents/MacOS/cyedr-agent"
fi
if [[ -x "$AGENT_BIN" && -f "$EDR_HOME/config.json" ]]; then
    if [[ -t 0 ]]; then
        echo -n "This host has tamper protection configured. If it requires a password to uninstall, enter it now (leave blank if none): "
        read -r -s TAMPER_PASSWORD
        echo
    else
        # Non-interactive (curl | bash): no terminal to prompt on. Pass an
        # empty password through the same gate rather than skipping it
        # silently — a host with protect_uninstall=true and a real password
        # set correctly rejects an empty guess below, so this can't be used
        # to bypass the gate from a script; it can only fail exactly like a
        # wrong guess would.
        TAMPER_PASSWORD=""
    fi
    TAMPER_DETAIL="$(printf '%s' "$TAMPER_PASSWORD" | "$AGENT_BIN" --config "$EDR_HOME/config.json" --verify-tamper-password-uninstall 2>&1)"
    TAMPER_STATUS=$?
    unset TAMPER_PASSWORD
    if [[ $TAMPER_STATUS -ne 0 ]]; then
        die "Tamper protection blocked this uninstall: $TAMPER_DETAIL"
    fi
    [[ "$TAMPER_DETAIL" != "no admin password configured" ]] && ok "Tamper protection: $TAMPER_DETAIL"
fi

info "Force-uninstalling CyEDR from this $OS_KEY host..."

# ── Stop + disable services ─────────────────────────────────────────────────
if [[ "$OS_KEY" == "LINUX" ]]; then
    systemctl stop cyedr-watchdog.timer cyedr-agent 2>/dev/null || true
    systemctl disable cyedr-watchdog.timer cyedr-agent 2>/dev/null || true
else
    launchctl bootout system /Library/LaunchDaemons/com.cyassure.edr.plist 2>/dev/null \
        || launchctl unload /Library/LaunchDaemons/com.cyassure.edr.plist 2>/dev/null || true
    # Tray LaunchAgent runs per-user (gui/<uid>). Best-effort unload for the
    # current console session only — the plist is removed below regardless,
    # so any other already-logged-in user's copy clears at their next
    # logout/login even if this unload doesn't reach their session.
    console_user="$(stat -f%Su /dev/console 2>/dev/null || true)"
    if [[ -n "$console_user" && "$console_user" != "root" ]]; then
        console_uid="$(id -u "$console_user" 2>/dev/null || true)"
        if [[ -n "$console_uid" ]]; then
            launchctl asuser "$console_uid" launchctl bootout "gui/$console_uid/com.cyassure.edrtray" 2>/dev/null || true
        fi
    fi
fi
ok "Services stopped and disabled"

# ── Force-kill any still-running CyEDR processes ────────────────────────────
# Covers processes started manually/outside the service manager, or a service
# stop that didn't take (e.g. hung IPC listener thread).
if [[ "$OS_KEY" == "MACOS" ]]; then
    # macOS's cyedr-install.sh wraps the binary in "CyEDR.app" for a
    # branded Full Disk Access identity (2026-09-07) — the flat
    # $EDR_HOME/cyedr-agent path below it no longer matches the real running
    # process's command line at all.
    pkill -9 -f "$EDR_HOME/CyEDR.app/Contents/MacOS/cyedr-agent" 2>/dev/null || true
else
    pkill -9 -f "$EDR_HOME/cyedr-agent" 2>/dev/null || true
fi
pkill -9 -f "$EDR_HOME/cyedr_agent.py" 2>/dev/null || true
pkill -9 -f "$TRAY_HOME/cyedr-tray"    2>/dev/null || true
ok "Any running CyEDR processes killed"

# ── Remove service/unit definitions ──────────────────────────────────────────
if [[ "$OS_KEY" == "LINUX" ]]; then
    rm -f /etc/systemd/system/cyedr-agent.service \
          /etc/systemd/system/cyedr-watchdog.service \
          /etc/systemd/system/cyedr-watchdog.timer
    systemctl daemon-reload 2>/dev/null || true
    rm -f /etc/xdg/autostart/cyedr-tray.desktop
    ok "systemd units and tray autostart removed"

    # auditd: remove only CyEDR's own rules file, then reload whatever
    # non-CyEDR rules remain (e.g. Wazuh's) — never a blanket auditctl -D.
    rm -f /etc/audit/rules.d/60-cyedr.rules /etc/audisp/plugins.d/cyedr.conf
    augenrules --load 2>/dev/null || true
    systemctl restart auditd 2>/dev/null || true
    ok "auditd CyEDR rules removed"

    if id "$EDR_USER" &>/dev/null; then
        userdel "$EDR_USER" 2>/dev/null || true
        ok "System user '$EDR_USER' removed"
    fi
else
    rm -f /Library/LaunchDaemons/com.cyassure.edr.plist \
          /Library/LaunchAgents/com.cyassure.edrtray.plist
    ok "LaunchDaemon/LaunchAgent plists removed"
fi

# ── Remove all CyEDR files and directories ──────────────────────────────────
rm -rf "$EDR_HOME" "$TRAY_HOME" "$IPC_DIR"
ok "Removed $EDR_HOME, $TRAY_HOME, $IPC_DIR"

echo ""
echo -e "${GRN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GRN} CyEDR Agent Uninstalled                             ${NC}"
echo -e "${GRN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  This endpoint is clean of all CyEDR agent/tray/watchdog state."
echo "  It will still show as 'disconnected' in Endpoint Fleet until either"
echo "  removed there manually, or superseded by a fresh enrollment below."
echo ""
echo "  To reinstall: run the CyEDR install command from Agent Installer > Install."
echo ""
