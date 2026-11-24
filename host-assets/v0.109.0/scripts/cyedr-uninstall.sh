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
    launchctl bootout system /Library/LaunchDaemons/com.cyassure.edr.snapshot.plist 2>/dev/null \
        || launchctl unload /Library/LaunchDaemons/com.cyassure.edr.snapshot.plist 2>/dev/null || true
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
# Legacy: a retired Python-agent install run from source (dev hosts) — keep
# cleaning it up on endpoints that still have one.
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
    # non-CyEDR rules remain (other tools' rules) — never a blanket auditctl -D.
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
          /Library/LaunchDaemons/com.cyassure.edr.snapshot.plist \
          /Library/LaunchAgents/com.cyassure.edrtray.plist
    ok "LaunchDaemon/LaunchAgent plists removed"
fi

# ── Remove all CyEDR files and directories ──────────────────────────────────
# What policies applied here: a removed agent must not leave USB disks blocked,
# firewall rules in force or a forced proxy.
if [[ "$OS_KEY" == "LINUX" ]]; then
    if command -v iptables-save >/dev/null 2>&1 && iptables-save 2>/dev/null | grep -q 'CyEDR-Policy'; then
        iptables-save | grep -v 'CyEDR-Policy' | iptables-restore 2>/dev/null || warn "Could not remove CyEDR firewall rules"
    fi
    rm -f /etc/udev/rules.d/99-cyedr-usb.rules /etc/udev/rules.d/99-cyedr-peripherals.rules /etc/profile.d/cyedr_proxy.sh
    command -v udevadm >/dev/null 2>&1 && udevadm control --reload-rules 2>/dev/null || true
    # Ransomware rollback's btrfs snapshots: with the agent gone nothing would
    # ever delete them. Only the names the agent generates are touched.
    rm -f /etc/cron.d/cyedr-ransomware-snapshot
    if command -v btrfs >/dev/null 2>&1 && command -v findmnt >/dev/null 2>&1; then
        while IFS= read -r mnt; do
            mnt="${mnt//\\x20/ }"
            for snap in "$mnt"/.snapshots/cyedr/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]; do
                [[ -d "$snap" ]] || continue
                btrfs -q subvolume delete "$snap" >/dev/null 2>&1 || warn "Could not delete snapshot $snap"
            done
            rmdir "$mnt/.snapshots/cyedr" 2>/dev/null || true
            rmdir "$mnt/.snapshots" 2>/dev/null || true
        done < <(findmnt -rn -t btrfs -o TARGET 2>/dev/null)
    fi
else
    if [[ -f /etc/pf.anchors/cyedr_policy ]]; then
        : > /etc/pf.anchors/cyedr_policy
        pfctl -a cyedr_policy -F rules 2>/dev/null || true
    fi
    # A proxy the agent forced (proxy_darwin.json: the proxy and the services
    # it set it on). Switched off only where it still points there, so a
    # proxy the user or the company set since is left alone (2026-11-08).
    pstate="$EDR_HOME/proxy_darwin.json"
    if [[ -f "$pstate" ]]; then
        phost="$(plutil -extract host raw -o - "$pstate" 2>/dev/null)"
        pport="$(plutil -extract port raw -o - "$pstate" 2>/dev/null)"
        i=0
        while svc="$(plutil -extract "services.$i" raw -o - "$pstate" 2>/dev/null)"; do
            cur="$(networksetup -getsecurewebproxy "$svc" 2>/dev/null)"
            if [[ -n "$phost" ]] && grep -qFx "Server: $phost" <<<"$cur" && grep -qFx "Port: $pport" <<<"$cur"; then
                networksetup -setwebproxystate "$svc" off 2>/dev/null || true
                networksetup -setsecurewebproxystate "$svc" off 2>/dev/null || true
            fi
            i=$((i+1))
        done
    fi
fi
# Decoy files the ransomware detector planted, and the agent's DNS sinkhole block.
find /root /home /Users -maxdepth 3 -type f -name '.~cyassure-decoy-*' -delete 2>/dev/null || true
if grep -q '# BEGIN CyEDR-SINKHOLE' /etc/hosts 2>/dev/null; then
    hosts_tmp="$(mktemp)"
    sed '/# BEGIN CyEDR-SINKHOLE/,/# END CyEDR-SINKHOLE/d' /etc/hosts > "$hosts_tmp" && cat "$hosts_tmp" > /etc/hosts
    rm -f "$hosts_tmp"
fi
rm -rf "$EDR_HOME" "$TRAY_HOME" "$IPC_DIR"
# Tetragon, only if CyEDR installed it: one that was already on the host
# belongs to its owner.
if [[ "$OS_KEY" == "LINUX" && -f /etc/tetragon/.installed-by-cyedr ]]; then
    systemctl disable --now tetragon 2>/dev/null || true
    if [[ -f /etc/tetragon/.cyedr-files ]]; then
        while IFS= read -r f; do
            [[ "$f" == usr/local/* ]] && rm -f "/$f"
        done < /etc/tetragon/.cyedr-files
    fi
    rm -rf /etc/tetragon /usr/local/lib/tetragon /etc/systemd/system/tetragon.service
    systemctl daemon-reload 2>/dev/null || true
    ok "Tetragon removed"
fi
command -v semanage >/dev/null 2>&1 && semanage fcontext -d "$EDR_HOME/logs(/.*)?" 2>/dev/null || true
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
