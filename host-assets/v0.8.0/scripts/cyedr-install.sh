#!/usr/bin/env bash
# CyAssure 360 — CyEDR Agent Installer
# Installs CyEDR on Linux and macOS endpoints.
#
# What this installs:
#   Linux  — auditd + CyEDR audit rules, YARA, CyEDR Python bridge daemon (systemd)
#   macOS  — YARA, CyEDR Python bridge daemon (LaunchDaemon), oslog subscription
#
# A system-tray/menu-bar icon (cyedr-tray) is installed by default on
# workstation asset types — shows CyEDR is running, offers an on-demand scan,
# and a password-gated Stop/Exit (admin password set in Cy360 -> EDR Policies
# -> Tamper Protection). Use --no-tray to skip it, or --with-tray to force it
# on non-workstation asset types.
#
# Usage:
#   curl -fsSL https://<platform>/cyedr-install.sh | bash -s -- \
#       --token <DEPLOY_TOKEN> --platform https://<platform> [OPTIONS]
#
#   Options:
#     --token TOKEN          Deployment token (required)
#     --platform URL         CyAssure 360 platform URL (required)
#     --asset-type TYPE      Asset type: workstation|server|database|domain_controller|
#                            api_gateway|jump_server (default: workstation)
#     --with-tray            Install the system-tray app even on non-workstation asset types
#     --no-tray              Skip installing the system-tray app
#     --silent               Non-interactive
#     --impl python|go       Which agent implementation to install (default: go, as of
#                            2026-09-07 — Python EDR is being fully discarded in favor
#                            of agent-go; the platform no longer builds/serves fresh
#                            Python binaries at all, see deploy.yml's build-edr-macos
#                            if:false comment). "python" is accepted but will 404
#                            against any release cut after this change.
#     --help                 Show this help

set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; YEL='\033[1;33m'; GRN='\033[0;32m'; BLU='\033[0;34m'; DIM='\033[2m'; NC='\033[0m'
info()  { echo -e "${BLU}[CyEDR]${NC} $*"; }
ok()    { echo -e "${GRN}[CyEDR]${NC} $*"; }
warn()  { echo -e "${YEL}[CyEDR]${NC} $*"; }
die()   { echo -e "${RED}[CyEDR ERROR]${NC} $*" >&2; exit 1; }

# Safety net: any command that fails without an explicit `|| true`/`|| warn`
# guard would otherwise kill the script under `set -e` with zero CyEDR-branded
# output (e.g. apt-get update failing because unattended-upgrades holds the
# dpkg lock on a freshly booted host) — that reads as "the installer just
# silently stopped". This guarantees a visible error with line + command.
trap 'echo -e "${RED}[CyEDR ERROR]${NC} Installer aborted at line ${LINENO}: ${BASH_COMMAND}" >&2' ERR

# ── Defaults ───────────────────────────────────────────────────────────────────
DEPLOY_TOKEN=""
PLATFORM_URL=""
ASSET_TYPE="workstation"
WITH_TRAY=""            # empty=default (workstation only), "yes"=force install, "no"=skip
SILENT=false
# Go-rewrite cutover (2026-09-05) — opt-in only, defaults to the existing
# PyInstaller agent unchanged. Requests the agent-go binary from the same
# /api/edr/installer/agent-bundle route via its impl=go query param — see
# that route's own comment in blueprints/edr/routes.py. Only meaningful for
# manual dogfooding right now (Phase 1 of the cutover plan); no fleet-wide
# default or UI toggle exists yet.
IMPL="go"
EDR_HOME="/opt/cyassure/edr"
EDR_USER="cyedr"
TRAY_HOME="/opt/cyassure/edr-tray"   # separate from EDR_HOME (root-only 750) — the tray
                                      # binary must be world-executable for any local user

# Kept in sync with agent/cyedr_agent.py's AGENT_VERSION by git-push.sh on every
# release (same mechanism that already syncs cyassure-setup.sh's header line and
# backend/pyproject.toml) — never bump this by hand.
CYEDR_AGENT_VERSION="1.0.248"

banner() {
    echo -e "${BLU}"
    cat << 'EOF'
  ██████╗██╗   ██╗     ███████╗██████╗ ██████╗
 ██╔════╝╚██╗ ██╔╝     ██╔════╝██╔══██╗██╔══██╗
 ██║      ╚████╔╝      █████╗  ██║  ██║██████╔╝
 ██║       ╚██╔╝       ██╔══╝  ██║  ██║██╔══██╗
 ╚██████╗   ██║███████╗███████╗██████╔╝██║  ██║
  ╚═════╝   ╚╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝
EOF
    echo -e "${NC}${GRN}  CyAssure 360 — CyEDR Endpoint Defense  |  FROM SIGNALS TO STRENGTH${NC}"
    # CyEDR Agent Build != platform release version by design — the agent
    # script's own version only bumps when agent/tray code changes, not on
    # every platform release (syncing the two caused a self-update restart
    # loop in the past, see AGENT_VERSION comment in agent/cyedr_agent.py).
    # Platform version is echoed separately in print_summary() once
    # PLATFORM_URL is known, so the two numbers are never shown looking like
    # a single "version" that should match.
    echo -e "${DIM}  CyEDR Agent Build: v${CYEDR_AGENT_VERSION}${NC}"
    echo -e "${BLU}  ─────────────────────────────────────────────────────────────────${NC}"
    echo ""
}

# ── Argument parsing ───────────────────────────────────────────────────────────
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --token)      DEPLOY_TOKEN="$2"; shift 2 ;;
            --platform)   PLATFORM_URL="${2%/}"; shift 2 ;;
            --asset-type) ASSET_TYPE="$2"; shift 2 ;;
            --with-tray)   WITH_TRAY="yes"; shift ;;
            --no-tray)     WITH_TRAY="no"; shift ;;
            --silent)      SILENT=true; shift ;;
            --impl)        IMPL="$2"; shift 2 ;;
            --help|-h)
                banner
                grep '^#' "$0" | grep -v '#!/' | sed 's/^# //' | sed 's/^#//'
                exit 0 ;;
            *) die "Unknown argument: $1" ;;
        esac
    done
    [[ -z "$DEPLOY_TOKEN" ]] && die "Missing --token <DEPLOY_TOKEN>"
    [[ -z "$PLATFORM_URL" ]] && die "Missing --platform <URL>"
    [[ "$IMPL" != "python" && "$IMPL" != "go" ]] && die "Invalid --impl '$IMPL' (must be 'python' or 'go')"
    # `[[ cond ]] && die ...` as the LAST statement in a function is a classic
    # `set -e` trap: when cond is false (the normal, valid-args case), the `&&`
    # list's exit status is 1, that becomes parse_args's own return status, and
    # since main() calls `parse_args "$@"` as a bare statement, `set -e` treats
    # the whole script as having failed a command and aborts immediately —
    # silently, because die()/the ERR trap never actually ran. This is exactly
    # what made the installer print the banner and then exit with no message.
    return 0
}

# ── Platform detection ─────────────────────────────────────────────────────────
detect_platform() {
    OS_TYPE="$(uname -s)"
    ARCH="$(uname -m)"
    case "$OS_TYPE" in
        Linux)  OS_KEY="LINUX"  ;;
        Darwin) OS_KEY="MACOS"  ;;
        *)      die "Unsupported OS: $OS_TYPE. Use cyedr-install.ps1 for Windows." ;;
    esac
    # cyedr_agent.py's own os_type convention (platform.system().upper()) is
    # DARWIN, not MACOS — OS_KEY="MACOS" above is this SHELL SCRIPT's naming
    # for API endpoints/server enrollment (matches routes.py's ("MACOS",...)
    # dicts), a deliberately separate concern. They only diverge for macOS
    # (LINUX happens to equal LINUX either way, which is exactly why this
    # went unnoticed) — writing OS_KEY into config.json's "os_type" field
    # meant cfg.os_type was "MACOS" for every single macOS install, and
    # every `if cfg.os_type == "DARWIN":` check in the agent (the entire
    # Shadow AI DNS/browser-history detection block, and the Full Disk
    # Access reminder) silently never ran, on any Mac, ever. This is what
    # config.json's own "os_type" value must be — nowhere else.
    _PY_OS_TYPE="$(echo "$OS_TYPE" | tr '[:lower:]' '[:upper:]')"
    info "Detected platform: $OS_TYPE ($ARCH)"
}

# ── Root check ─────────────────────────────────────────────────────────────────
check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        die "CyEDR installer must run as root (sudo bash $0 ...)"
    fi
}

# ── Architecture detection ─────────────────────────────────────────────────────
detect_arch() {
    case "$ARCH" in
        x86_64)           AGENT_ARCH="x86_64";  DEB_ARCH="amd64";  PKG_ARCH="intel64" ;;
        aarch64|arm64)    AGENT_ARCH="aarch64"; DEB_ARCH="arm64";  PKG_ARCH="arm64"   ;;
        *)
            warn "Unknown arch $ARCH — defaulting to x86_64"
            AGENT_ARCH="x86_64"; DEB_ARCH="amd64"; PKG_ARCH="intel64"
            ;;
    esac
    info "Architecture: $ARCH → agent bundle key: $AGENT_ARCH"
}

# ── Install system packages ────────────────────────────────────────────────────
install_packages_linux() {
    info "Installing system dependencies..."
    if command -v apt-get &>/dev/null; then
        # Debian / Ubuntu / Raspberry Pi OS / Kali (all arches)
        # Non-fatal: a fresh boot's unattended-upgrades often holds the dpkg
        # lock for the first few minutes, which would otherwise abort the
        # entire install here under set -e before the agent is even deployed.
        apt-get update -qq 2>/dev/null || warn "apt-get update failed (dpkg lock or unreachable mirror?) — continuing with existing package lists"
        apt-get install -y -qq auditd audispd-plugins yara curl \
            python3 python3-pip python3-venv \
            python3-requests python3-psutil python3-yaml \
            iptables iproute2 nmap snmp 2>/dev/null || true
    elif command -v dnf &>/dev/null; then
        # RHEL 8/9, CentOS Stream 8/9, Fedora, Rocky Linux, AlmaLinux, Amazon Linux 2023
        # python3-venv is NOT a separate package on RPM distros — venv is built into python3
        dnf install -y -q audit yara curl \
            python3 python3-pip \
            python3-requests python3-psutil python3-pyyaml \
            iptables iproute nmap net-snmp-utils 2>/dev/null || true
    elif command -v yum &>/dev/null; then
        # RHEL 7, CentOS 7, Amazon Linux 2 (legacy)
        yum install -y -q audit audit-libs yara curl \
            python3 python3-pip \
            python3-requests python3-psutil python3-pyyaml \
            iptables iproute nmap net-snmp-utils 2>/dev/null || true
    elif command -v apk &>/dev/null; then
        # Alpine Linux (all arches) — package names differ from Debian/RPM
        apk add --quiet python3 py3-pip \
            py3-requests py3-psutil py3-yaml \
            nmap net-snmp-tools 2>/dev/null || true
        # Note: auditd and yara are not in Alpine standard repos
    else
        warn "Unknown package manager — skipping auto-install; ensure auditd, yara, nmap, and snmpwalk are present"
    fi
    ok "System packages installed"
}

install_packages_macos() {
    info "Installing system dependencies (macOS)..."
    # When run as `sudo bash`, root's PATH excludes Homebrew directories.
    # Probe known Homebrew prefix locations explicitly before falling back to PATH.
    local BREW_BIN=""
    for _try in \
        /opt/homebrew/bin/brew \
        /usr/local/bin/brew \
        "$(command -v brew 2>/dev/null)"; do
        [[ -x "$_try" ]] && { BREW_BIN="$_try"; break; }
    done

    if [[ -n "$BREW_BIN" ]]; then
        # Homebrew refuses to run as root. When invoked via `sudo bash`, delegate
        # the install back to the original user via SUDO_USER.
        local _BREW_USER="${SUDO_USER:-}"
        local _brew_install
        if [[ -n "$_BREW_USER" && "$_BREW_USER" != "root" ]]; then
            _brew_install="HOMEBREW_NO_AUTO_UPDATE=1 sudo -u $_BREW_USER $BREW_BIN install"
        else
            _brew_install="HOMEBREW_NO_AUTO_UPDATE=1 $BREW_BIN install"
        fi
        eval "$_brew_install yara" 2>/dev/null \
            || warn "Homebrew yara install failed — YARA scanning may be unavailable"
        eval "$_brew_install nmap" 2>/dev/null \
            || warn "Homebrew nmap install failed — Network Probe subnet scan may be unavailable"
        eval "$_brew_install net-snmp" 2>/dev/null \
            || warn "Homebrew net-snmp install failed — SNMP probe scan may be unavailable"
    else
        warn "Homebrew not found — YARA, nmap, and snmpwalk may be unavailable. Install: https://brew.sh"
    fi
    # Python3 is expected via Xcode CLT or Homebrew
    ok "System packages installed"
}

# Resolve the absolute path to the yara binary after package install.
# LaunchDaemons/systemd services run with a stripped PATH that excludes
# Homebrew and /usr/local/bin, so we must embed the absolute path in config.json.
resolve_yara_binary() {
    local bin
    for bin in \
        "$(command -v yara 2>/dev/null)" \
        /opt/homebrew/bin/yara \
        /usr/local/bin/yara \
        /usr/bin/yara \
        /bin/yara; do
        [[ -x "$bin" ]] && { echo "$bin"; return 0; }
    done
    echo "yara"   # fallback: keep as name, agent will try absolute paths at runtime
}

# ── Deploy CyEDR agent ─────────────────────────────────────────────────────────
deploy_agent() {
    info "Creating CyEDR installation directory: $EDR_HOME"
    mkdir -p "$EDR_HOME/"{rules,ioc_cache,quarantine,logs,yara_rules}

    # Create dedicated system user (no login, no home)
    if [[ "$OS_KEY" == "LINUX" ]]; then
        if ! id "$EDR_USER" &>/dev/null; then
            useradd -r -s /bin/false -d "$EDR_HOME" -M "$EDR_USER" 2>/dev/null || true
        fi
    fi

    # Download arch-specific pre-built CyEDR agent binary from platform.
    # macOS staged filenames/route mapping use "arm64" (Apple's own naming),
    # not "aarch64" — AGENT_ARCH is "aarch64" on Apple Silicon (shared with
    # the LINUX arch-normalization above, where "aarch64" IS correct). The
    # tray download a few lines below already overrides to PKG_ARCH="arm64"
    # for exactly this reason; do the same here so a fresh install gets the
    # compiled binary (its own distinct Full Disk Access identity) instead of
    # silently 404'ing and falling back to Python-script mode. The server
    # additionally aliases ("MACOS","aarch64") now too, so this is
    # belt-and-suspenders correctness, not the only thing fixing it.
    local BUNDLE_ARCH="$AGENT_ARCH"
    [[ "$OS_KEY" == "MACOS" ]] && BUNDLE_ARCH="$PKG_ARCH"
    info "Downloading CyEDR agent binary (${OS_KEY}/${BUNDLE_ARCH}, impl=${IMPL})..."
    local BUNDLE_URL="$PLATFORM_URL/api/edr/installer/agent-bundle?os=${OS_KEY}&arch=${BUNDLE_ARCH}&impl=${IMPL}"
    if curl -fsSL --max-time 60 \
        -H "Authorization: Bearer $DEPLOY_TOKEN" \
        "$BUNDLE_URL" \
        -o "$EDR_HOME/cyedr-agent" 2>/dev/null; then
        chmod 750 "$EDR_HOME/cyedr-agent"
        ok "Agent binary downloaded"
    else
        # Air-gap fallback: look for binary alongside the installer script.
        # Staged filenames use BUNDLE_ARCH's convention (e.g. macOS "arm64"),
        # same as the remote download above — not AGENT_ARCH.
        warn "Pre-built binary not available for ${OS_KEY}/${BUNDLE_ARCH} from $PLATFORM_URL — checking for a local bundle..."
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || true
        local FALLBACK="" OS_KEY_LOWER
        OS_KEY_LOWER="$(echo "$OS_KEY" | tr '[:upper:]' '[:lower:]')"
        for try_path in \
            "${SCRIPT_DIR}/cyedr-agent-${OS_KEY_LOWER}-${BUNDLE_ARCH}" \
            "${SCRIPT_DIR}/../agent/cyedr-agent" \
            "/tmp/cyedr-agent"; do
            [[ -f "$try_path" ]] && { FALLBACK="$try_path"; break; }
        done
        if [[ -n "$FALLBACK" ]]; then
            cp "$FALLBACK" "$EDR_HOME/cyedr-agent"
            chmod 750 "$EDR_HOME/cyedr-agent"
            warn "Using local bundle: $FALLBACK"
        else
            # No Python-mode fallback anymore (removed 2026-08-25 — binary
            # coverage is complete on every release: Linux/macOS arm64
            # always were, macOS intel64 as of this date; see
            # docs/CYEDR_AGENT_HARDENING_PROGRESS.md). A missing binary here
            # means either a genuinely bad/stale release or a platform-side
            # asset-sync issue — both need fixing at the source, not papering
            # over with an uncompiled Python install on the endpoint.
            die "No CyEDR agent binary available for ${OS_KEY}/${BUNDLE_ARCH} — checked $PLATFORM_URL and this script's own directory. This is a platform-side issue, not your deployment token: ask the CyAssure 360 admin to check 'docker compose logs backend' for a docker-entrypoint.sh WARNING about /var/lib/cyassure-agent-packages/edr, and confirm this release actually shipped a binary for this platform (deploy.yml's 'Verify Windows EDR binaries are current' step, or the release's own asset list on GitHub)."
        fi
    fi

    # macOS only: wrap the downloaded binary in a proper .app bundle so it
    # shows up as "CyEDR" with the real brand icon in System Settings >
    # Privacy & Security > Full Disk Access, instead of a bare, unbranded
    # executable path. TCC resolves the display name/icon shown in that
    # prompt/list from the nearest enclosing Contents/Info.plist, walking up
    # from the actual running executable's path — a flat binary with no
    # bundle around it has none to find, so macOS falls back to the raw
    # filename and a generic icon. install_launchdaemon() below points the
    # LaunchDaemon at this nested path; the FDA-instructions step further
    # down already detects and reports whichever path is actually running,
    # bundle or not, so it needs no separate change for this.
    if [[ "$OS_KEY" == "MACOS" ]]; then
        info "Wrapping agent binary in a branded .app bundle..."
        local APP_DIR="$EDR_HOME/CyEDR.app"
        mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
        mv "$EDR_HOME/cyedr-agent" "$APP_DIR/Contents/MacOS/cyedr-agent"
        chmod 750 "$APP_DIR/Contents/MacOS/cyedr-agent"

        if curl -fsSL --max-time 30 \
            -H "Authorization: Bearer $DEPLOY_TOKEN" \
            "$PLATFORM_URL/api/edr/installer/agent-icon-macos" \
            -o "$APP_DIR/Contents/Resources/CyEDR.icns" 2>/dev/null; then
            ok "Brand icon staged"
        else
            warn "Could not download brand icon — bundle will use macOS's generic executable icon (cosmetic only; Full Disk Access still works)"
        fi

        cat > "$APP_DIR/Contents/Info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>CyEDR</string>
    <key>CFBundleDisplayName</key>
    <string>CyEDR</string>
    <key>CFBundleIdentifier</key>
    <string>com.cyassure.edr</string>
    <key>CFBundleExecutable</key>
    <string>cyedr-agent</string>
    <key>CFBundleIconFile</key>
    <string>CyEDR</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSBackgroundOnly</key>
    <true/>
</dict>
</plist>
PLIST
        chmod 644 "$APP_DIR/Contents/Info.plist"
        ok "CyEDR.app bundle created"
    fi

    # Download YARA rules bundle from platform
    info "Downloading YARA rule bundle..."
    curl -fsSL --max-time 30 \
        -H "Authorization: Bearer $DEPLOY_TOKEN" \
        "$PLATFORM_URL/api/edr/installer/yara-rules" \
        -o "$EDR_HOME/yara_rules/cyassure.yar" 2>/dev/null \
        || warn "YARA rules download failed — local scanning will use built-in signatures only"

    # Write agent config
    HOSTNAME="$(hostname -f 2>/dev/null || hostname)"
    YARA_BIN="$(resolve_yara_binary)"
    # tetragon_addr (item #22/B8) — only meaningful for impl=go on Linux;
    # agent-go's control-plane hooks are the only thing that ever dials this
    # (see internal/config/config.go's TetragonAddr comment). Left empty
    # everywhere else — config.go's own zero-value default already means
    # "disabled, BLOCK_HASH stays tier-1-only," so an empty string here is a
    # real, correct value, not a placeholder. Matches install_tetragon()'s own
    # socket path below (Tetragon's own release default, unchanged).
    TETRAGON_ADDR_CFG=""
    if [[ "$OS_KEY" == "LINUX" && "$IMPL" == "go" ]]; then
        TETRAGON_ADDR_CFG="unix:///var/run/tetragon/tetragon.sock"
    fi
    cat > "$EDR_HOME/config.json" << CONF
{
  "platform_url":    "$PLATFORM_URL",
  "deploy_token":    "$DEPLOY_TOKEN",
  "asset_type":      "$ASSET_TYPE",
  "hostname":        "$HOSTNAME",
  "os_type":         "${_PY_OS_TYPE}",
  "edr_home":        "$EDR_HOME",
  "poll_interval":   60,
  "heartbeat_interval": 60,
  "telemetry_batch": 20,
  "yara_binary":     "$YARA_BIN",
  "yara_rules":      "$EDR_HOME/yara_rules/cyassure.yar",
  "quarantine_dir":  "$EDR_HOME/quarantine",
  "ioc_cache":       "$EDR_HOME/ioc_cache/ioc.json",
  "log_file":        "$EDR_HOME/logs/cyedr_agent.log",
  "tetragon_addr":   "$TETRAGON_ADDR_CFG"
}
CONF

    # agent_id/enrollment_token are intentionally left unset here — enroll_agent()
    # always re-enrolls fresh below and writes the current, valid token. Carrying
    # a stale token forward across reinstalls previously left agents permanently
    # broken with no way to recover short of manually editing config.json.
    chmod 600 "$EDR_HOME/config.json"
    ok "CyEDR agent deployed to $EDR_HOME"
}

# ── Decide whether to install the system-tray app ──────────────────────────────
want_tray() {
    [[ "$WITH_TRAY" == "no" ]] && return 1
    [[ "$WITH_TRAY" == "yes" ]] && return 0
    [[ "$ASSET_TYPE" == "workstation" ]] && return 0
    return 1   # default: skip on headless server/database/DC/etc. asset types
}

# ── Deploy CyEDR system-tray binary ─────────────────────────────────────────────
# Separate download, separate directory from EDR_HOME on purpose: EDR_HOME is
# locked to root-only traversal (750) by harden_permissions() below because
# config.json inside it holds the enrollment token — the tray binary and its
# IPC token/socket must be reachable by any locally logged-in user, so they
# live in their own world-traversable directory instead of loosening EDR_HOME.
deploy_tray() {
    info "Downloading CyEDR system-tray binary (${OS_KEY}/${AGENT_ARCH})..."
    mkdir -p "$TRAY_HOME"
    local TRAY_ARCH="$AGENT_ARCH"
    [[ "$OS_KEY" == "MACOS" ]] && TRAY_ARCH="$PKG_ARCH"
    local TRAY_URL="$PLATFORM_URL/api/edr/installer/tray-bundle?os=${OS_KEY}&arch=${TRAY_ARCH}"
    if curl -fsSL --max-time 60 \
        -H "Authorization: Bearer $DEPLOY_TOKEN" \
        "$TRAY_URL" \
        -o "$TRAY_HOME/cyedr-tray" 2>/dev/null; then
        chown root:root "$TRAY_HOME/cyedr-tray" 2>/dev/null || true
        chmod 755 "$TRAY_HOME/cyedr-tray"
        chmod 755 "$TRAY_HOME"
        ok "System-tray binary installed to $TRAY_HOME"
        return 0
    fi
    warn "Tray binary not available for ${OS_KEY}/${TRAY_ARCH} — skipping tray install " \
         "(run agent/packages/build-edr-packages.sh on the platform server, or pass --no-tray to silence this)"
    return 1
}

# ── Linux: XDG autostart for the tray (any desktop session, any user) ──────────
install_tray_autostart_linux() {
    mkdir -p /etc/xdg/autostart
    cat > /etc/xdg/autostart/cyedr-tray.desktop << DESKTOP
[Desktop Entry]
Type=Application
Name=CyEDR
Comment=CyAssure 360 endpoint protection status
Exec=$TRAY_HOME/cyedr-tray
Icon=security-high
Terminal=false
X-GNOME-Autostart-enabled=true
NoDisplay=false
DESKTOP
    chmod 644 /etc/xdg/autostart/cyedr-tray.desktop
    ok "Tray autostart registered (XDG autostart — starts for any user's desktop session)"
}

# ── macOS: system-wide LaunchAgent for the tray (any GUI login session) ────────
install_tray_launchagent_macos() {
    local PLIST="/Library/LaunchAgents/com.cyassure.edrtray.plist"
    cat > "$PLIST" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.cyassure.edrtray</string>
    <key>ProgramArguments</key>
    <array>
        <string>$TRAY_HOME/cyedr-tray</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>ProcessType</key>
    <string>Interactive</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
PLIST
    chown root:wheel "$PLIST"
    chmod 644 "$PLIST"
    # /Library/LaunchAgents plists auto-load for every user at their next GUI
    # login with no further action. Best-effort: also load it immediately for
    # whichever user is in the current console session, if any.
    local console_user
    console_user="$(stat -f%Su /dev/console 2>/dev/null || true)"
    if [[ -n "$console_user" && "$console_user" != "root" ]]; then
        local console_uid
        console_uid="$(id -u "$console_user" 2>/dev/null || true)"
        if [[ -n "$console_uid" ]]; then
            launchctl asuser "$console_uid" launchctl bootstrap "gui/$console_uid" "$PLIST" 2>/dev/null || true
        fi
    fi
    ok "Tray LaunchAgent installed: com.cyassure.edrtray (system-wide, any GUI login)"
}

# ── Linux: auditd configuration ────────────────────────────────────────────────
configure_auditd_linux() {
    info "Configuring auditd for CyEDR..."

    # CyEDR-specific auditd rules file (separate from Wazuh's existing rules)
    cat > /etc/audit/rules.d/60-cyedr.rules << 'AUDRULES'
## CyAssure 360 CyEDR — Endpoint Detection Rules
## Key prefix cy360_edr_* ensures no collision with Wazuh cy360_wazuh_tamper rules

# Process execution tracking
-a always,exit -F arch=b64 -S execve -k cy360_edr_exec
-a always,exit -F arch=b32 -S execve -k cy360_edr_exec

# Network connections
-a always,exit -F arch=b64 -S connect -k cy360_edr_net
-a always,exit -F arch=b32 -S connect -k cy360_edr_net

# Process injection / fileless memory syscalls
-a always,exit -F arch=b64 -S ptrace -k cy360_edr_inject
-a always,exit -F arch=b64 -S process_vm_writev -k cy360_edr_inject
-a always,exit -F arch=b64 -S process_vm_readv -k cy360_edr_inject
-a always,exit -F arch=b64 -S memfd_create -k cy360_edr_inject

# Privileged process execution (uid changes)
-a always,exit -F arch=b64 -S setuid -S setgid -k cy360_edr_privesc
-a always,exit -F arch=b64 -S setresuid -S setresgid -k cy360_edr_privesc

# Sensitive file access
-w /etc/passwd -p rwa -k cy360_edr_credentials
-w /etc/shadow -p rwa -k cy360_edr_credentials
-w /etc/sudoers -p rwa -k cy360_edr_credentials
-w /root/.ssh -p rwa -k cy360_edr_credentials

# Item #37 — deception layer: decoy credentials planted by the agent's own
# plant_deception_canaries() (cyedr_agent.py). Unlike the real files above,
# these have zero legitimate access path — read-only access alone is a
# near-certain compromise signal, not just an elevated one. -w requires an
# already-existing path at rule-load time; the agent creates both
# directories on first startup (before this rules file is (re)loaded on
# next boot), so a fresh install briefly has no watch until the next
# augenrules reload — acceptable since nothing is planted to be found yet
# either, in that same window.
-w /root/.aws/credentials -p rwa -k cy360_edr_deception
-w /root/.ssh_backup/id_rsa -p rwa -k cy360_edr_deception

# Persistence paths — write/attribute-change only (rwxa also caught routine reads:
# cron re-reads /etc/cron.d every minute and systemd re-reads /etc/systemd/system on
# nearly every unit lookup, so "r" and "x" flooded this key on completely benign hosts).
-w /etc/cron.d -p wa -k cy360_edr_persist
-w /etc/systemd/system -p wa -k cy360_edr_persist
-w /etc/rc.local -p wa -k cy360_edr_persist

# Anti-tamper: CyEDR agent self-defence (new key; Wazuh still watches cy360_wazuh_tamper)
-w /opt/cyassure/edr -p wa -k cy360_edr_tamper
AUDRULES
    chmod 640 /etc/audit/rules.d/60-cyedr.rules

    # Configure audisp to emit events to /var/log/audit/audit.log (default) AND
    # to a named pipe that CyEDR reads without interfering with Wazuh's af_unix plugin
    if [[ -d /etc/audisp/plugins.d ]]; then
        cat > /etc/audisp/plugins.d/cyedr.conf << 'AUDISP'
active = yes
direction = out
path = builtin_af_unix
type = builtin
args = 0660 /var/run/cyedr_audit.sock
format = string
AUDISP
        chmod 640 /etc/audisp/plugins.d/cyedr.conf
    fi

    # Load new rules immediately
    augenrules --load 2>/dev/null || auditctl -R /etc/audit/rules.d/60-cyedr.rules 2>/dev/null || true
    systemctl enable auditd 2>/dev/null && systemctl restart auditd 2>/dev/null || true
    ok "auditd configured with CyEDR rules"
}

# ── Linux: systemd service ─────────────────────────────────────────────────────
install_systemd_service() {
    info "Installing CyEDR systemd service..."

    local EXEC_START="$EDR_HOME/cyedr-agent --config $EDR_HOME/config.json"

    cat > /etc/systemd/system/cyedr-agent.service << SVCFILE
[Unit]
Description=CyAssure 360 EDR Agent
Documentation=https://docs.cyassure.eu/edr
After=network-online.target auditd.service
Wants=network-online.target
# Watchdog via companion .timer — see cyedr-watchdog.service

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=$EDR_HOME
ExecStart=$EXEC_START
Restart=always
RestartSec=10
StandardOutput=append:$EDR_HOME/logs/cyedr_agent.log
StandardError=append:$EDR_HOME/logs/cyedr_agent.log
# Harden: prevent CyEDR from being killed by OOM killer
OOMScoreAdjust=-900
# Resource limits
MemoryMax=256M
CPUQuota=25%
# Protect self from non-root writes
ProtectSystem=strict
ReadWritePaths=$EDR_HOME /var/run /var/log/audit /tmp

[Install]
WantedBy=multi-user.target
SVCFILE

    # Watchdog service — restarts cyedr-agent if it goes down, UNLESS the stop
    # was tray-authorized (marker at $EDR_HOME/.tray_stopped — see
    # IPCListener._do_stop() in cyedr_agent.py). Without this check, an admin-
    # password-gated "Stop/Exit CyEDR" from the tray would silently get
    # reverted within 5 minutes, making that password gate meaningless on
    # Linux specifically (macOS/Windows have no equivalent watchdog to fight).
    cat > /etc/systemd/system/cyedr-watchdog.service << WDFILE
[Unit]
Description=CyEDR Agent Watchdog
After=cyedr-agent.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'systemctl is-active --quiet cyedr-agent || { [ -f $EDR_HOME/.tray_stopped ] && exit 0; systemctl restart cyedr-agent; }'
WDFILE

    cat > /etc/systemd/system/cyedr-watchdog.timer << WDTIMER
[Unit]
Description=CyEDR Watchdog Timer

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
WDTIMER

    chmod 644 /etc/systemd/system/cyedr-{agent,watchdog}.service \
              /etc/systemd/system/cyedr-watchdog.timer
    systemctl daemon-reload
    systemctl enable cyedr-agent cyedr-watchdog.timer
    ok "systemd services installed (cyedr-agent, cyedr-watchdog)"
}

# ── Linux: Tetragon (item #22/B8) — real kernel exec-blocking for BLOCK_HASH
# tier 2 ──────────────────────────────────────────────────────────────────────
# impl=go only: agent-go's control-plane hooks (internal/ebpf) are the only
# thing that ever dials tetragon_addr — the Python agent has no equivalent,
# so there is nothing for Tetragon to serve on a Python install. Uses
# Tetragon's own officially-supported bare-metal release, not a hand-rolled
# systemd unit: its release tarball ships install.sh, a systemd unit, and a
# tetragon.conf.d/ directory whose shipped defaults already point
# --server-address at a Unix socket (unix:///var/run/tetragon/tetragon.sock)
# — the "Unix socket, not TCP" requirement agent-go/internal/ebpf/
# DEPLOYMENT.md flagged as unbuilt turns out to already be upstream's own
# default, not something this script needs to configure itself. The one real
# gap DEPLOYMENT.md's own live testing found (edr-i-49/go-i-13,15) —
# --enable-ancestors=base, silently required for items #24/#29's real
# multi-level process-lineage capture, no error/warning without it — is what
# this function actually adds on top of Tetragon's shipped defaults.
#
# Pinned to v1.7.1, not latest — matches DEPLOYMENT.md's own live-verified
# kernel-compatibility finding (v1.2.0's bpf_multi_kprobe_v61.o failed to
# load on a real production kernel; v1.7.1 was the version actually tested
# against that same kernel and confirmed working).
#
# Never fatal on failure — BLOCK_HASH's reactive tier-1 scan (all 3
# platforms, no Tetragon needed) still works with zero Tetragon at all; this
# only ever adds the opt-in tier-2 kernel-level instant-block capability,
# the same "never required" contract config.go's TetragonAddr comment
# documents. A download/checksum/start failure here must never abort the
# rest of the CyEDR install over what is, for BLOCK_HASH's tier-1 baseline,
# a pure enhancement.
TETRAGON_VERSION="v1.7.1"
install_tetragon() {
    [[ "$OS_KEY" != "LINUX" || "$IMPL" != "go" ]] && return 0
    command -v systemctl &>/dev/null || { warn "No systemd — skipping Tetragon install, BLOCK_HASH will stay tier-1-only"; return 0; }

    local ALREADY_RUNNING=0
    systemctl is-active --quiet tetragon 2>/dev/null && ALREADY_RUNNING=1

    if [[ "$ALREADY_RUNNING" -eq 0 ]]; then
        info "Installing Tetragon ${TETRAGON_VERSION} (real kernel exec-blocking for BLOCK_HASH tier 2)..."
        local TG_TMP; TG_TMP="$(mktemp -d)"
        local TG_TARBALL="tetragon-${TETRAGON_VERSION}-${DEB_ARCH}.tar.gz"
        local TG_URL="https://github.com/cilium/tetragon/releases/download/${TETRAGON_VERSION}/${TG_TARBALL}"

        if ! curl -fsSL --max-time 120 -o "$TG_TMP/$TG_TARBALL" "$TG_URL"; then
            warn "Could not download Tetragon (${TG_URL}) — BLOCK_HASH will stay tier-1-only (reactive scan). Not fatal."
            rm -rf "$TG_TMP"; return 0
        fi
        if ! curl -fsSL --max-time 30 -o "$TG_TMP/${TG_TARBALL}.sha256sum" "${TG_URL}.sha256sum"; then
            warn "Could not download Tetragon's checksum — refusing to install an unverified binary. BLOCK_HASH will stay tier-1-only."
            rm -rf "$TG_TMP"; return 0
        fi
        if ! (cd "$TG_TMP" && sha256sum -c "${TG_TARBALL}.sha256sum" &>/dev/null); then
            warn "Tetragon checksum verification FAILED — refusing to install. BLOCK_HASH will stay tier-1-only."
            rm -rf "$TG_TMP"; return 0
        fi

        tar xzf "$TG_TMP/$TG_TARBALL" -C "$TG_TMP"
        local TG_SRC="$TG_TMP/tetragon-${TETRAGON_VERSION}-${DEB_ARCH}"
        if [[ ! -d "$TG_SRC" ]]; then
            warn "Tetragon tarball did not extract as expected — BLOCK_HASH will stay tier-1-only."
            rm -rf "$TG_TMP"; return 0
        fi

        # Mirrors Tetragon's own install.sh step-for-step (read, not run
        # blindly, so the extra --enable-ancestors config below can be
        # written BEFORE the first `systemctl start`, not after).
        cp -Rf "$TG_SRC/usr/local/"* /usr/local/
        cp -f /usr/local/lib/tetragon/systemd/tetragon.service /etc/systemd/system/tetragon.service
        install -d /etc/tetragon/tetragon.conf.d/
        install -d /etc/tetragon/tetragon.tp.d/
        cp -n /usr/local/lib/tetragon/tetragon.conf.d/* /etc/tetragon/tetragon.conf.d/ 2>/dev/null || true
        rm -rf "$TG_TMP"
    else
        info "Tetragon already running — reconciling config (--enable-ancestors=base) and reloading"
    fi

    # Required for real multi-level process-lineage (items #24/#29) — without
    # it Tetragon silently returns empty Ancestors on every event, no error.
    # See DEPLOYMENT.md's own live-verified finding (go-i-15).
    echo "base" > /etc/tetragon/tetragon.conf.d/enable-ancestors

    systemctl daemon-reload
    systemctl enable tetragon &>/dev/null || true
    if [[ "$ALREADY_RUNNING" -eq 1 ]]; then
        systemctl restart tetragon
    else
        systemctl start tetragon
    fi

    if systemctl is-active --quiet tetragon; then
        ok "Tetragon running (unix:///var/run/tetragon/tetragon.sock) — BLOCK_HASH tier 2 (real kernel exec-blocking) available"
    else
        warn "Tetragon installed but is not active (check: journalctl -u tetragon --no-pager | tail -30) — BLOCK_HASH will stay tier-1-only. Not fatal to the rest of this install."
    fi
}

# ── macOS: LaunchDaemon ────────────────────────────────────────────────────────
install_launchdaemon() {
    info "Installing CyEDR LaunchDaemon (macOS)..."
    local PLIST="/Library/LaunchDaemons/com.cyassure.edr.plist"

    # deploy_agent() wraps the binary in "CyEDR.app" for a branded
    # Full Disk Access identity (see its own comment) — point the
    # LaunchDaemon at the binary's real nested location inside that bundle,
    # not the flat path it downloaded to before wrapping.
    local PROG_ARGS="    <string>$EDR_HOME/CyEDR.app/Contents/MacOS/cyedr-agent</string>
        <string>--config</string>
        <string>$EDR_HOME/config.json</string>"

    mkdir -p "$EDR_HOME/logs"

    cat > "$PLIST" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.cyassure.edr</string>
    <key>ProgramArguments</key>
    <array>
        $PROG_ARGS
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$EDR_HOME/logs/cyedr_agent.log</string>
    <key>StandardErrorPath</key>
    <string>$EDR_HOME/logs/cyedr_agent.log</string>
    <key>WorkingDirectory</key>
    <string>$EDR_HOME</string>
    <key>ProcessType</key>
    <string>Background</string>
    <key>Nice</key>
    <integer>10</integer>
    <key>HardResourceLimits</key>
    <dict>
        <key>MemoryLock</key>
        <integer>268435456</integer>
    </dict>
</dict>
</plist>
PLIST

    chown root:wheel "$PLIST"
    chmod 644 "$PLIST"
    # bootstrap is the modern API (macOS 13+); fall back to legacy load for older systems
    launchctl bootstrap system "$PLIST" 2>/dev/null || launchctl load -w "$PLIST" 2>/dev/null || true
    ok "LaunchDaemon installed: com.cyassure.edr"
}

# ── Enroll with platform ───────────────────────────────────────────────────────
enroll_agent() {
    # Always re-enroll, even on reinstall. self_enroll_agent() on the server matches
    # the existing row by hardware_uuid/hostname and UPDATEs it rather than inserting
    # a duplicate, so this is safe — and it guarantees the agent always ends up with
    # the current, valid enrollment_token instead of silently carrying a stale one
    # forward across reinstalls.
    info "Enrolling with CyAssure 360 platform..."
    HOSTNAME="$(hostname -f 2>/dev/null || hostname)"

    # Collect stable hardware UUID for deduplication across reinstalls
    HW_UUID=""
    if [[ "$OS_KEY" == "MACOS" ]]; then
        HW_UUID="$(ioreg -rd1 -c IOPlatformExpertDevice 2>/dev/null | grep -o '"IOPlatformUUID" = "[^"]*"' | grep -oE '[0-9A-F-]{36}' | head -1)"
    elif [[ "$OS_KEY" == "LINUX" ]]; then
        HW_UUID="$(cat /etc/machine-id 2>/dev/null || cat /var/lib/dbus/machine-id 2>/dev/null || cat /sys/class/dmi/id/product_uuid 2>/dev/null | head -1)"
        HW_UUID="${HW_UUID^^}"  # uppercase
    fi
    [[ -z "$HW_UUID" ]] && warn "Could not detect hardware UUID — hostname will be used for deduplication"

    # Collect agent IP
    if [[ "$OS_KEY" == "LINUX" ]]; then
        AGENT_IP="$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}' | head -1)"
    else
        AGENT_IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")"
    fi
    AGENT_IP="${AGENT_IP:-unknown}"

    # Detect default gateway MAC at install time (trusted corporate environment)
    # This seeds the network zone auto-learning so the server knows which gateway
    # is the corporate one without admin needing to configure it manually.
    GW_IP=""; GW_MAC=""
    if [[ "$OS_KEY" == "LINUX" ]]; then
        GW_IP="$(ip route show default 2>/dev/null | awk '/via/{print $3; exit}')"
        if [[ -n "$GW_IP" ]]; then
            GW_MAC="$(arp -n "$GW_IP" 2>/dev/null | awk 'NR==2{print $3}' | tr '[:lower:]' '[:upper:]')"
        fi
    else
        # macOS: get default route then ARP lookup
        GW_IP="$(netstat -rn 2>/dev/null | awk '/^default/{print $2; exit}')"
        if [[ -n "$GW_IP" ]]; then
            GW_MAC="$(arp "$GW_IP" 2>/dev/null | grep -oE '[0-9a-fA-F]{1,2}(:[0-9a-fA-F]{1,2}){5}' | head -1 | tr '[:lower:]' '[:upper:]')"
        fi
    fi
    [[ -z "$GW_MAC" ]] && warn "Could not detect gateway MAC — zone auto-learning will rely on heartbeat"

    local ENROLL_RESPONSE
    ENROLL_RESPONSE=$(curl -fsSL --max-time 30 \
        -X POST "$PLATFORM_URL/api/edr/agents/self-enroll" \
        -H "Authorization: Bearer $DEPLOY_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"deployment_token\": \"$DEPLOY_TOKEN\",
            \"hostname\":      \"$HOSTNAME\",
            \"os_type\":       \"$OS_KEY\",
            \"asset_type\":    \"$ASSET_TYPE\",
            \"agent_ip\":      \"$AGENT_IP\",
            \"version\":       \"1.0.0\",
            \"hardware_uuid\": \"$HW_UUID\",
            \"gateway_ip\":    \"$GW_IP\",
            \"gateway_mac\":   \"$GW_MAC\",
            \"build_source\":  \"$IMPL\"
        }") || die "Enrollment failed — check network connectivity to $PLATFORM_URL"

    # Extract agent_id and enrollment_token from response
    AGENT_ID=$(echo "$ENROLL_RESPONSE" | grep -o '"agent_id":"[^"]*"' | cut -d'"' -f4)
    ENROLLMENT_TOKEN=$(echo "$ENROLL_RESPONSE" | grep -o '"enrollment_token":"[^"]*"' | cut -d'"' -f4)
    [[ -z "$AGENT_ID" ]] && die "Enrollment response did not include agent_id: $ENROLL_RESPONSE"
    [[ -z "$ENROLLMENT_TOKEN" ]] && die "Enrollment response did not include enrollment_token: $ENROLL_RESPONSE"

    # Persist agent_id, enrollment_token, and hardware_uuid into config
    python3 - << PYINLINE
import json
cfg_path = "$EDR_HOME/config.json"
with open(cfg_path) as f:
    cfg = json.load(f)
cfg["agent_id"]         = "$AGENT_ID"
cfg["enrollment_token"] = "$ENROLLMENT_TOKEN"
if "$HW_UUID":
    cfg["hardware_uuid"] = "$HW_UUID"
with open(cfg_path, "w") as f:
    json.dump(cfg, f, indent=2)
PYINLINE

    ok "Enrolled — Agent ID: $AGENT_ID"
}

# ── Lock down file permissions ─────────────────────────────────────────────────
harden_permissions() {
    info "Hardening CyEDR file permissions..."
    local _grp; _grp="$(if [[ "$OS_KEY" == "MACOS" ]]; then echo wheel; else echo root; fi)"
    chown -R "root:${_grp}" "$EDR_HOME"
    chmod -R 750 "$EDR_HOME"
    chmod 700 "$EDR_HOME/quarantine"
    chmod 600 "$EDR_HOME/config.json"
    chmod 755 "$EDR_HOME/logs"
    ok "Permissions set"
}

# ── Start agent ────────────────────────────────────────────────────────────────
start_agent() {
    info "Starting CyEDR agent..."
    if [[ "$OS_KEY" == "LINUX" ]]; then
        # restart, not start: on a reinstall over an already-running agent, `start`
        # is a systemd no-op on an active unit — daemon-reload picks up the new
        # ExecStart (python3 mode, new binary, etc.) but the OLD process keeps
        # running untouched until something actually restarts it. `restart`
        # behaves identically to `start` when the unit isn't running yet, so this
        # is safe for both fresh installs and reinstalls.
        systemctl restart cyedr-agent
        sleep 2
        if systemctl is-active --quiet cyedr-agent; then
            ok "cyedr-agent is running"
        else
            warn "cyedr-agent failed to start — check: journalctl -u cyedr-agent -n 50"
        fi
    else
        launchctl kickstart -k system/com.cyassure.edr 2>/dev/null || launchctl start com.cyassure.edr 2>/dev/null || true
        sleep 2
        if launchctl print system/com.cyassure.edr 2>/dev/null | grep -q "state ="; then
            ok "CyEDR agent is running (macOS)"
        else
            warn "CyEDR agent may not be running — check: $EDR_HOME/logs/cyedr_agent.log"
        fi
    fi
}

# ── Summary ────────────────────────────────────────────────────────────────────
print_summary() {
    echo ""
    echo -e "${GRN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GRN} CyEDR Agent Installation Complete                    ${NC}"
    echo -e "${GRN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Platform:   $PLATFORM_URL"
    # Best-effort — shown side by side, clearly labeled, so nobody mistakes
    # the agent build number for a platform-version mismatch (they're
    # intentionally different counters, see banner()/AGENT_VERSION comment
    # in agent/cyedr_agent.py). Never fails the install if unreachable.
    #
    # /api/system/version's response also embeds a "version" key inside each
    # release_notes[] entry, and Flask serializes object keys alphabetically
    # ("release_notes" < "version"), so the array comes BEFORE the top-level
    # field in the raw JSON text. A plain `grep -o '"version":"..."' | head -1`
    # therefore always matched release_notes[0]'s version instead of the real
    # one — showing whichever release GitHub listed first, not what the
    # server actually has deployed. Parse it properly with python3 when
    # available; fall back to a `tail -1`-anchored regex (the top-level field
    # is the last "version" occurrence in the text, since it's serialized
    # last) only if python3 isn't on this host.
    _VERSION_JSON=$(curl -fsSL --max-time 10 "$PLATFORM_URL/api/system/version" 2>/dev/null || true)
    if command -v python3 >/dev/null 2>&1; then
        _PLATFORM_VER=$(echo "$_VERSION_JSON" | python3 -c '
import json, sys
try:
    print(json.load(sys.stdin).get("version", ""))
except Exception:
    pass' 2>/dev/null)
    else
        _PLATFORM_VER=$(echo "$_VERSION_JSON" \
            | grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' | tail -1 \
            | sed -E 's/.*"([^"]+)"$/\1/')
    fi
    echo "  Platform version:   ${_PLATFORM_VER:-unknown}"
    echo "  CyEDR Agent Build:  v${CYEDR_AGENT_VERSION}  (independent counter — only bumps when agent/tray code changes)"
    echo "  Agent home: $EDR_HOME"
    echo "  Logs:       $EDR_HOME/logs/cyedr_agent.log"
    if [[ "$OS_KEY" == "LINUX" ]]; then
        echo ""
        echo "  Status:     systemctl status cyedr-agent"
        echo "  Logs:       journalctl -u cyedr-agent -f"
        echo "  Restart if stopped (tray Stop/Exit, or a crash):"
        echo "              sudo systemctl start cyedr-agent"
    else
        echo ""
        echo "  Status:     sudo launchctl list com.cyassure.edr"
        echo "  Logs:       tail -f $EDR_HOME/logs/cyedr_agent.log"
        # Printed here permanently, not only inside the tray's dialogs — by
        # the time someone needs this, the tray may be showing the
        # unreachable/red state and this may be the only place it's written
        # down (the agent's own log stops updating once it's stopped).
        echo "  Restart if stopped: use \"Start CyEDR...\" in the tray menu"
        echo "              (asks for the CyEDR admin password, then macOS's own"
        echo "               admin authentication) — or from Terminal:"
        echo "              sudo launchctl bootstrap system /Library/LaunchDaemons/com.cyassure.edr.plist"
        echo "              (if that errors 'already bootstrapped', use instead:"
        echo "               sudo launchctl kickstart -k system/com.cyassure.edr)"
        echo ""
        echo -e "${YEL}  ACTION NEEDED: Grant Full Disk Access${NC}"
        echo "  CyEDR runs as a background system service, so macOS blocks it from"
        echo "  reading browser history — required for full Shadow AI detection"
        echo "  (catching ChatGPT/Gemini/Perplexity/etc. used in a browser tab, not"
        echo "  just installed AI apps). Without it, only AI-app/process detection"
        echo "  works; the agent will remind you periodically until this is granted."
        echo "    1. System Settings > Privacy & Security > Full Disk Access"
        # Resolve the REAL running binary via `ps`, not the static
        # ProgramArguments path — belt-and-suspenders correctness in case
        # the plist's path and the real on-disk binary ever diverge (e.g. a
        # future re-signing/relocation). Asking the already-started daemon
        # (start_agent ran above) what its kernel-reported path actually is
        # sidesteps that entirely.
        local _fda_pid _fda_target
        _fda_pid="$(pgrep -x cyedr-agent 2>/dev/null | head -1)"
        _fda_target=""
        if [[ -n "$_fda_pid" ]]; then
            _fda_target="$(ps -o comm= -p "$_fda_pid" 2>/dev/null | sed 's/^[[:space:]]*//')"
        fi
        if [[ -n "$_fda_target" ]]; then
            # If it's inside a .app bundle, Finder's FDA picker shows the
            # bundle itself (e.g. "CyEDR.app"), not the raw inner
            # binary. Since deploy_agent() now wraps the binary in a proper
            # bundle with a real Info.plist (CFBundleName "CyEDR"), the
            # entry Finder/System Settings shows once added is genuinely
            # named "CyEDR" with the real brand icon — no longer a bare,
            # unbranded path a user has to recognize by guesswork.
            if [[ "$_fda_target" == *"/Contents/MacOS/"* ]]; then
                _fda_target="${_fda_target%%/Contents/MacOS/*}"
            fi
            echo "    2. Click + and add: $_fda_target"
            echo "       (resolved live from the actually-running process, not a"
            echo "        guess — once added, it shows up named \"CyEDR\" with the"
            echo "        CyAssure brand icon, easy to recognize in the list)"
        else
            # Agent isn't up yet (race/failed start) — fall back to the static
            # ProgramArguments guess, flagged as possibly-imprecise.
            warn "Could not detect the running agent process to resolve its exact Full Disk Access target — falling back to the configured path below."
            echo "    2. Click + and add: $EDR_HOME/CyEDR.app"
        fi
        # Best-effort: jump straight to the right pane for whoever's at the
        # console right now. Harmless no-op over a headless/SSH install.
        local console_user
        console_user="$(stat -f%Su /dev/console 2>/dev/null || true)"
        if [[ -n "$console_user" && "$console_user" != "root" ]]; then
            local console_uid
            console_uid="$(id -u "$console_user" 2>/dev/null || true)"
            if [[ -n "$console_uid" ]]; then
                launchctl asuser "$console_uid" sudo -u "$console_user" \
                    open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles" \
                    2>/dev/null || true
            fi
        fi
    fi
    if [[ -x "$TRAY_HOME/cyedr-tray" ]]; then
        echo ""
        echo "  Tray:       $TRAY_HOME/cyedr-tray (starts automatically at next login)"
    fi
    echo ""
    echo -e "${YEL}  Next: View this endpoint in CyAssure 360 > Endpoint Fleet${NC}"
    echo ""
}

# ── Main ───────────────────────────────────────────────────────────────────────
main() {
    banner
    parse_args "$@"
    check_root
    detect_platform

    # OS-specific package install
    if [[ "$OS_KEY" == "LINUX" ]]; then
        install_packages_linux
    else
        install_packages_macos
    fi

    detect_arch
    deploy_agent

    if [[ "$OS_KEY" == "LINUX" ]]; then
        configure_auditd_linux
        install_systemd_service
        install_tetragon
    else
        install_launchdaemon
    fi

    if want_tray && deploy_tray; then
        if [[ "$OS_KEY" == "LINUX" ]]; then
            install_tray_autostart_linux
        else
            install_tray_launchagent_macos
        fi
    fi

    harden_permissions
    enroll_agent
    start_agent
    print_summary
}

main "$@"
