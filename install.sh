#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# CyAssure 360 -- Setup & Update Wizard v0.0.123 -- 2026-09-13 17:02 UTC
#
# ONE script now does the whole job — this used to be a two-script install
# (scripts/install.sh for the Docker app bring-up, this file for everything
# else) split across two commands. Merged 2026-08-09: install.sh is gone,
# and a fresh run of this script now ALSO downloads the release's Docker
# bundle, generates .env, and runs `docker compose pull && up -d` before
# moving on to the host-prep steps below (see "DOCKER APPLICATION" step).
# Ubuntu/Debian (apt-get) target only — the old install.sh's macOS/Docker
# Desktop evaluation path is retired; use DOCKER_DEPLOYMENT.md's "Manual
# install" section on a Mac instead (a few extra commands, no apt-get needed).
#
# FRESH INSTALL (Docker app bring-up + host prep + EDR staging + hardening):
#   sudo bash cyassure-setup.sh
#   (running as root already? drop "sudo".)
#
# --token/GH_TOKEN is now OPTIONAL (2026-08-26) — without one, host-assets
# (CyEDR agent/tray binaries, YARA/Sysmon, RELEASE_NOTES.md, self-update) are
# fetched from the public cyassure/cy360-install mirror instead of this repo's
# private Releases API; Community and Enterprise ship identical binaries, so
# there was never a real gate here. Pass --token <PAT> only if you need a
# private/pre-release build instead of the latest public one:
#   sudo bash cyassure-setup.sh --token <your-github-PAT>
#   (--token is more reliable than `export GH_TOKEN=... && sudo -E ...`:
#   sudo's env_reset policy silently strips exported vars, even with -E, on
#   some systems even root-to-root — a flag always survives sudo regardless
#   of that policy.)
#
# UPDATE EXISTING SERVER (skips infra + app bring-up, only refreshes host-side
# packages/assets — the running app stack updates via Settings > Update/Upgrade
# in the portal, or manually with `docker compose pull && up -d`):
#   sudo bash cyassure-setup.sh --update
#
# FLAGS:
#   --skip-ufw          skip the UFW firewall step entirely
#   --skip-ssh-harden   leave SSH on its current port (no move to 2026)
#   --dir <path>        install the Docker app into this directory (default: ./cy360)
#   --token <PAT>       optional — GitHub PAT to pull a private/pre-release build from
#                        cyassure/cy360's Releases API instead of the public cy360-install
#                        mirror (or set GH_TOKEN env var)
#   --version vX.Y.Z    install a specific release instead of the latest
#
# NON-INTERACTIVE PRE-SEEDS (set before the command to skip the matching
# prompt — this is what the portal's Setup Wizard generates for you):
#   CYASSURE_SETUP_DOMAIN=company.com    pre-seeds the base-domain prompt
#   CYASSURE_SETUP_ENV=prod|staging      pre-seeds the certbot environment prompt
#
# CyDataLake (Kafka+ClickHouse, or the Docker-native redpanda+clickhouse
# equivalent when installed via the app bring-up step) is part of the
# default stack unconditionally now — there is no prompt or opt-out here.
#
# The Flask backend, cysiemstack-engine, and portal all run as Docker Compose
# services. See DOCKER_DEPLOYMENT.md for the full reference:
#
#   docker compose up -d      start everything
#   docker compose down       stop everything
#
# Beyond the app bring-up, this script handles things that ARE NOT about app
# hosting and remain genuinely useful on a Docker host: the host nginx
# vhost + TLS cert for BASE_DOMAIN (see "HOST VHOST + TLS PROVISIONING",
# --tls-mode), the IAP gateway (oauth2-proxy + nginx auth_request), CyEDR
# endpoint-agent package staging, GeoIP/Sysmon config staging, platform
# branding, RBAC seed defaults, cron jobs, the UFW firewall, and SSH
# hardening. Steps that used to install native PostgreSQL/Redis, deploy the
# portal, pip-install the backend wheel, or run DB migrations have been
# removed — each removal has an inline comment at its former location
# explaining what replaced it and any gap left behind (search this file for
# "DEPRECATED" and "KNOWN GAP"). The old per-module (cy360/cyasm) nginx
# vhosts + certbot TLS were removed in the Docker pivot and restored
# 2026-08-23 as a single simplified vhost — see "HOST VHOST + TLS
# PROVISIONING" below. Azure Arc support was fully retired
# 2026-07-27 — it was only ever used for Key Vault Managed Identity and one
# Infisical auth option, and neither requires it (see core/kv_secrets.py's
# Universal Auth path, the only Infisical auth method now supported).
#
# Known open gaps:
#   - License-watchdog enforcement (the systemd timer that used to stop
#     services on license expiry) was removed with the systemd services it
#     targeted and has no Docker-native replacement yet — license_validator.py
#     is still staged but nothing currently runs it on a schedule for a
#     Docker deployment. Needs a real design pass (APScheduler job in the
#     Flask container, or a sidecar with docker socket access), not a
#     mechanical port.
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Captured here, before anything below ever `cd`s (the "DOCKER APPLICATION"
# step below cds into APP_DIR, e.g. ./cy360/) — realpath/readlink on a
# RELATIVE $0 (the common case: `curl -o cyassure-setup.sh -> sudo bash
# cyassure-setup.sh`) resolves against the CURRENT working directory at the
# time it's called, so computing this later, after the cd, silently resolves
# to the wrong path (e.g. ./cy360/cyassure-setup.sh instead of the real
# ./cyassure-setup.sh) — the self-copy step further down then fails with
# "cp: cannot stat '<wrong path>': No such file or directory". Must be first.
_SCRIPT_ABS_PATH="$(realpath "$0" 2>/dev/null || readlink -f "$0" 2>/dev/null || echo "$0")"

# ── Colours & helpers (defined early — used by license check below) ───────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; WHITE='\033[1;37m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

info()    { echo -e "${CYAN}  ▸ ${NC}$*"; }
success() { echo -e "${GREEN}  ✓ ${NC}$*"; }
warn()    { echo -e "${YELLOW}  ⚠ ${NC}$*"; }
error()   { echo -e "${RED}  ✗ ${NC}$*"; }
divider() { echo -e "${DIM}  ────────────────────────────────────────────────${NC}"; }

gen_secret() { openssl rand -hex 24; }
gen_pass()   { openssl rand -base64 18 | tr -dc 'A-Za-z0-9' | head -c 20; }
_port_up()   { ss -tlnp 2>/dev/null | grep -q ":${1} "; }
# Escape a string for use as the replacement field in a sed s|...|...|  expression.
# Handles: \ (escape char), | (our delimiter), & (sed backreference).
_escape_sed_repl() { local s="$1"; s="${s//\\/\\\\}"; s="${s//|/\\|}"; s="${s//&/\\&}"; printf '%s' "$s"; }

# ── Parse flags ───────────────────────────────────────────────────────────────
MODE="full"
SKIP_UFW=false
SKIP_SSH_HARDEN=false
APP_DIR="./cy360"
APP_VERSION=""
# TLS_MODE: how the "HOST VHOST + TLS" step (below the IAP Gateway step)
# provisions the host nginx vhost + certificate for BASE_DOMAIN.
#   http01     — Let's Encrypt via certbot --webroot (default). Needs DNS
#                pointing directly at this host on :80 — fails behind a
#                proxying CDN (Cloudflare orange-cloud etc.).
#   dns01      — Let's Encrypt via certbot-dns-cloudflare. Works regardless of
#                proxying. Needs CYASSURE_SETUP_DNS_API_TOKEN set.
#   byo        — customer-supplied cert. Needs CYASSURE_SETUP_CERT_PATH/_KEY_PATH.
#   selfsigned — local self-signed cert (eval/air-gapped). Also the automatic
#                fallback when http01/dns01 fail, so the app is never left
#                completely unreachable from BASE_DOMAIN.
#   none       — today's behavior: no host vhost is written at all. Use this
#                when something other than host nginx terminates TLS
#                (Cloudflare Tunnel, another LB) — point IT at 127.0.0.1:4180.
# Left empty (not defaulted to http01) here on purpose — the interactive
# prompt below (BASE DOMAIN CONFIGURATION's sibling "TLS / HOST VHOST"
# prompt) needs to tell "user/flag explicitly chose http01" apart from
# "nothing was set yet, ask them." A hard default of http01 is applied later,
# right before the HOST VHOST + TLS step runs, as a safety net for
# --update/--infra runs where the interactive block above is skipped entirely.
TLS_MODE="${CYASSURE_SETUP_TLS_MODE:-}"
_args=("$@")
for ((_i=0; _i<${#_args[@]}; _i++)); do
    arg="${_args[$_i]}"
    case "$arg" in
        --update)           MODE="update" ;;
        --infra)            MODE="infra"  ;;
        --skip-ufw)         SKIP_UFW=true ;;
        --skip-ssh-harden)  SKIP_SSH_HARDEN=true ;;
        --dir)              APP_DIR="${_args[$((_i+1))]}"; _i=$((_i+1)) ;;
        --dir=*)            APP_DIR="${arg#*=}" ;;
        --token)            GH_TOKEN="${_args[$((_i+1))]}"; _i=$((_i+1)) ;;
        --token=*)          GH_TOKEN="${arg#*=}" ;;
        --version)          APP_VERSION="${_args[$((_i+1))]}"; _i=$((_i+1)) ;;
        --version=*)        APP_VERSION="${arg#*=}" ;;
        --tls-mode)         TLS_MODE="${_args[$((_i+1))]}"; _i=$((_i+1)) ;;
        --tls-mode=*)       TLS_MODE="${arg#*=}" ;;
        --cert-path)        CYASSURE_SETUP_CERT_PATH="${_args[$((_i+1))]}"; _i=$((_i+1)) ;;
        --cert-path=*)      CYASSURE_SETUP_CERT_PATH="${arg#*=}" ;;
        --key-path)         CYASSURE_SETUP_KEY_PATH="${_args[$((_i+1))]}"; _i=$((_i+1)) ;;
        --key-path=*)       CYASSURE_SETUP_KEY_PATH="${arg#*=}" ;;
    esac
done

if [[ -n "$TLS_MODE" ]]; then
    case "$TLS_MODE" in
        http01|dns01|byo|selfsigned|none) ;;
        *) echo "Unknown --tls-mode '${TLS_MODE}' — must be one of: http01, dns01, byo, selfsigned, none" >&2; exit 1 ;;
    esac
fi


# ── License check (full install only — updates are always allowed) ────────────
# Validator is embedded as a heredoc — single-file installer, no external
# license_validator.py required alongside the script or binary.
_LIC_FILE="/opt/cyassure/cyassure.lic"
# Also accept a .lic placed alongside this script (for licensed one-file installs)
[[ ! -f "$_LIC_FILE" ]] && \
    _LIC_FILE_LOCAL="${_SCRIPT_DIR:-$(dirname "${BASH_SOURCE[0]:-$0}")}/cyassure.lic" && \
    [[ -f "$_LIC_FILE_LOCAL" ]] && _LIC_FILE="$_LIC_FILE_LOCAL"

# ── Certbot environment: set during fresh install prompt (Step 1a below) ─────
CERTBOT_ENV="--staging"   # safe default; overridden to "" for PROD during fresh install

if [[ "$MODE" == "full" ]]; then
    # Write embedded validator to a secure temp file
    _VALIDATOR_DEST="/tmp/cyassure_license_validator_$$.py"
    cat > "$_VALIDATOR_DEST" << 'CYASSURE_VALIDATOR_EOF'
#!/usr/bin/env python3
import base64, json, os, subprocess, sys, tempfile
from datetime import date
from pathlib import Path

CYASSURE_PUBLIC_KEY = b"""-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3PWTGpjM9/RTMTA4FMmj
coYBxAEtckGxiv/Vf9vtZHbZBsoqaZk+Fx30DeiHCD2x0P//xkLxb/+yhY4vGsx5
cYEJpUHCxlskxFaBlBOQmZGIqgq6BHicfEnAiRCmmX6GznmCNPzqIIgXXtTOVILz
ez/oTDQkfNp5z3qrHK9XAqleqHehyJR3genS9XAPB8sNey6RfjYPa4FZixm4O7DI
i0nQeWeGjhPeZLaWo+BIGeMzCZQZpLOg4HBvsdNQZ9Jp4ktHnPKAFqyLzI+4BctE
o6cG5hWtmCcvUXWwzB+5YTPmMDp28kRNNOyMLo9DPsS6LHcW5R96uEXsyE8G1lZo
oQIDAQAB
-----END PUBLIC KEY-----
"""
LICENSE_PATH  = Path("/opt/cyassure/cyassure.lic")

def _verify_signature(payload_str, sig_b64):
    try: sig_bytes = base64.b64decode(sig_b64)
    except Exception: return False
    with tempfile.NamedTemporaryFile(delete=False, suffix=".pem") as kf:
        kf.write(CYASSURE_PUBLIC_KEY); kf_path = kf.name
    with tempfile.NamedTemporaryFile(delete=False, suffix=".sig") as sf:
        sf.write(sig_bytes); sf_path = sf.name
    try:
        p = subprocess.run(["openssl","dgst","-sha256","-verify",kf_path,"-signature",sf_path],
                           input=payload_str.encode(), capture_output=True)
        return p.returncode == 0
    except FileNotFoundError: return False
    finally: os.unlink(kf_path); os.unlink(sf_path)

def _parse_lic_file(path):
    try: text = path.read_text()
    except Exception: return None, None
    try:
        pb64 = text.split("-----BEGIN CYASSURE LICENSE-----")[1].split("-----END CYASSURE LICENSE-----")[0].strip()
        sb64 = text.split("-----BEGIN CYASSURE SIGNATURE-----")[1].split("-----END CYASSURE SIGNATURE-----")[0].strip()
        ps   = base64.b64decode(pb64).decode()
        return json.loads(ps), sb64, ps
    except Exception: return None, None, None

def _days_remaining(exp): return (date.fromisoformat(exp) - date.today()).days

def validate(lic_path=LICENSE_PATH):
    # No license file -> Community Edition. Permanent, no countdown, no expiry -- this
    # is a real edition, not a trial. (There used to be a time-boxed local "demo" here;
    # that predates the 2026-08-02 permanent Community/Enterprise licensing model and
    # is gone. See DOCKER_DEPLOYMENT.md section 5 / core/license_validator.py for the
    # same rule enforced at runtime by the app itself.)
    p = Path(lic_path)
    if not p.exists():
        return {"valid":True,"type":"community","days_remaining":None,"features":[],
                "customer":"Community","message":"No license file — running Community Edition (free forever)"}
    r = _parse_lic_file(p)
    if len(r) == 2:
        return {"valid":False,"type":"none","days_remaining":0,"features":[],"customer":"unknown",
                "message":"License file is corrupt or unreadable"}
    payload, sig_b64, payload_str = r
    if payload is None:
        return {"valid":False,"type":"none","days_remaining":0,"features":[],"customer":"unknown",
                "message":"License file could not be parsed"}
    if not _verify_signature(payload_str, sig_b64):
        return {"valid":False,"type":"none","days_remaining":0,"features":[],
                "customer":payload.get("customer","unknown"),
                "message":"License signature is invalid — file may have been tampered"}
    days = _days_remaining(payload["expires"])
    if days < 0:
        return {"valid":False,"type":payload["type"],"days_remaining":0,
                "features":payload.get("features",[]),"customer":payload["customer"],
                "message":f"License expired on {payload['expires']}"}
    return {"valid":True,"type":payload["type"],"days_remaining":days,
            "features":payload.get("features",[]),"customer":payload["customer"],
            "message":f"License valid — {days} day(s) remaining (expires {payload['expires']})"}

if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--license", default=str(LICENSE_PATH))
    ap.add_argument("--quiet", action="store_true")
    args = ap.parse_args()
    lic = Path(args.license)
    result = validate(lic)
    if not args.quiet: print(json.dumps(result, indent=2))
    # Exit codes: 0=full, 1=demo, 2=expired, 3=tampered/invalid, 4=no license (auto-demo)
    if not lic.exists(): sys.exit(4)
    if result.get("valid"):
        sys.exit(0 if result.get("type") == "full" else 1)
    sys.exit(2 if result.get("days_remaining", 1) <= 0 else 3)
CYASSURE_VALIDATOR_EOF
    chmod 600 "$_VALIDATOR_DEST"

    set +e
    _LIC_JSON=$(python3 "$_VALIDATOR_DEST" --license "$_LIC_FILE" 2>/dev/null)
    _LIC_CODE=$?
    set -e
    _LIC_TYPE=$(echo "$_LIC_JSON"  | python3 -c "import sys,json;print(json.load(sys.stdin).get('type','none'))" 2>/dev/null || echo "none")
    _LIC_DAYS=$(echo "$_LIC_JSON"  | python3 -c "import sys,json;print(json.load(sys.stdin).get('days_remaining',0))" 2>/dev/null || echo "0")
    _LIC_MSG=$(echo "$_LIC_JSON"   | python3 -c "import sys,json;print(json.load(sys.stdin).get('message',''))" 2>/dev/null || echo "")
    _LIC_CUST=$(echo "$_LIC_JSON"  | python3 -c "import sys,json;print(json.load(sys.stdin).get('customer',''))" 2>/dev/null || echo "")
    rm -f "$_VALIDATOR_DEST"

    # None of these ever abort the install. A missing/expired/invalid license means
    # Community Edition, not a blocked install -- Enterprise activates only when a
    # currently-valid signed license is present. Same rule the running app enforces
    # itself (core/license_validator.py) and the one documented in
    # DOCKER_DEPLOYMENT.md section 5 -- this installer used to disagree with both via
    # a stale pre-2026-08-02 "15-day demo" concept that no longer exists.
    case $_LIC_CODE in
        0) success "License: ENTERPRISE — ${_LIC_CUST} — ${_LIC_DAYS} day(s) remaining"
           CYASSURE_DEMO_MODE=0 ;;
        1) info "License: time-boxed evaluation — ${_LIC_DAYS} day(s) remaining"
           CYASSURE_DEMO_MODE=1 ;;
        2) warn "Enterprise license EXPIRED — ${_LIC_MSG}"
           warn "Continuing with Community Edition. Renew at https://cyassure.eu to restore Enterprise."
           CYASSURE_DEMO_MODE=1 ;;
        3) warn "Enterprise license INVALID — ${_LIC_MSG}"
           warn "Continuing with Community Edition. Contact support@cyassure.eu if this is unexpected."
           CYASSURE_DEMO_MODE=1 ;;
        4|*)
           info "No license found — running Community Edition (free forever)."
           info "Place cyassure.lic alongside this script any time to activate Enterprise."
           CYASSURE_DEMO_MODE=1 ;;
    esac
    export CYASSURE_DEMO_MODE
    export CYASSURE_LICENSE_TYPE="${_LIC_TYPE}"
fi

# ── ask / ask_secret / ask_yn helpers (interactive fallbacks) ────────────────
ask() {
    local varname=$1 prompt=$2 default=${3:-}
    local disp=""; [[ -n "$default" ]] && disp=" ${DIM}[${default}]${NC}"
    echo -ne "  ${WHITE}${prompt}${NC}${disp}: "
    read -r value
    [[ -z "$value" && -n "$default" ]] && value="$default"
    eval "$varname='$value'"
}
ask_secret() {
    local varname=$1 prompt=$2
    echo -ne "  ${WHITE}${prompt}${NC} ${DIM}[auto-generate]${NC}: "
    read -rs value; echo
    [[ -z "$value" ]] && value=$(openssl rand -hex 16) && info "Generated: ${DIM}${value}${NC}"
    eval "$varname='$value'"
}
ask_yn() {
    local prompt=$1 default=${2:-y}
    local opts="Y/n"; [[ "$default" == "n" ]] && opts="y/N"
    echo -ne "  ${WHITE}${prompt}${NC} ${DIM}[${opts}]${NC}: "
    read -r value; [[ -z "$value" ]] && value="$default"
    [[ "$value" =~ ^[Yy] ]] && return 0 || return 1
}

# Published version of this script — updated automatically by git-push.sh on each release.
# Used by --update mode to skip re-installation when the server is already on the latest version.
_SCRIPT_VERSION="v0.0.123"

# Mask GIT auth tokens in URLs before printing to output
_mask_url() { echo "$1" | sed 's|pkg\.github\.com/.*/|pkg.github.com/[TOKEN]/|g'; }

step=0
_LAST_STEP="(initializing)"

# ── Error trap — fires on any unexpected non-zero exit (set -euo pipefail) ──────
trap '
    ec=$?
    echo ""
    echo -e "\n${RED}${BOLD}  ✗ FATAL: Setup aborted during STEP ${step} \"${_LAST_STEP}\"${NC}"
    echo -e "  ${RED}  Failed command : ${BASH_COMMAND}${NC}"
    echo -e "  ${RED}  Exit code      : ${ec}  |  Line: ${BASH_LINENO[0]}${NC}"
    echo -e "  ${DIM}  Fix the issue above, then re-run: sudo bash cyassure-setup.sh${NC}"
    echo ""
' ERR

step_header() {
    step=$((step+1))
    _LAST_STEP="$1"
    echo -e "\n${BOLD}${CYAN}  ── STEP ${step}: $1${NC}"
    divider
}

[[ $EUID -ne 0 ]] && { error "Run as root: sudo bash cyassure-setup.sh"; exit 1; }

ERRORS=()

# ── Banner ────────────────────────────────────────────────────────────────────
[[ -t 1 ]] && clear; echo ""
echo -e "${CYAN}${BOLD}"
echo "   ██████╗██╗   ██╗ █████╗ ███████╗███████╗██╗   ██╗██████╗ ███████╗"
echo "  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔════╝██║   ██║██╔══██╗██╔════╝"
echo "  ██║      ╚████╔╝ ███████║███████╗███████╗██║   ██║██████╔╝█████╗  "
echo "  ██║       ╚██╔╝  ██╔══██║╚════██║╚════██║██║   ██║██╔══██╗██╔══╝  "
echo "  ╚██████╗   ██║   ██║  ██║███████║███████║╚██████╔╝██║  ██║███████╗"
echo "   ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "${NC}"
echo -e "  ${BOLD}360° Security Operations Platform${NC}"
echo -e "  ${DIM}Setup & Update Wizard — ${_SCRIPT_VERSION} — $(date -u +"%Y-%m-%d %H:%M UTC")${NC}"
echo ""; divider

if [[ "$MODE" == "update" ]]; then
    echo -e "  ${YELLOW}MODE: UPDATE${NC} — skipping infrastructure, updating packages only"
elif [[ "$MODE" == "infra" ]]; then
    echo -e "  ${YELLOW}MODE: INFRA ONLY${NC} — installing infrastructure only"
else
    echo -e "  ${DIM}MODE: FULL INSTALL${NC} — infrastructure + application"
fi
divider; echo ""

# ── Step 1: Interactive configuration — every prompt lives here, up front ────
# All operator questions (domain, environment type, CyDataLake) are
# asked in this single block before any work starts. This matters because the
# "DOWNLOAD RELEASE BUNDLE" step further down re-execs this script from a
# freshly downloaded copy (`exec bash "$_BUNDLE_SETUP" "$@"`) once the bundle
# is fetched — that replaces the running process, so anything asked *after*
# that point but not exported is lost and silently re-asked from the top on
# the next pass.
#
# Exporting the answers is not enough by itself: the detection checks below
# (dpkg/.env/systemd-unit existence) reflect *system* state, not "was this
# already decided this run" — on the re-exec'd process those checks land on
# the same answer as before, so without an explicit run-once guard this block would ask every
# question a second time regardless of the export. _CYASSURE_PROMPTS_DONE is
# that guard: it's what actually makes the re-exec'd process trust the
# inherited answers instead of re-deriving them.
if [[ -z "${_CYASSURE_PROMPTS_DONE:-}" ]]; then

    _FRESH_INSTALL=false
    [[ "$MODE" == "full" && ! -f "/opt/cyassure/.env" ]] && _FRESH_INSTALL=true

    if [[ "$_FRESH_INSTALL" == "true" ]]; then
        step_header "BASE DOMAIN CONFIGURATION"
        # CYASSURE_SETUP_DOMAIN pre-seeds this prompt — set by the portal's
        # first-login Setup Wizard so its generated command runs unattended
        # over SSH instead of blocking on a read. Interactive runs are
        # unaffected (the var is simply unset).
        if [[ -n "${CYASSURE_SETUP_DOMAIN:-}" ]]; then
            BASE_DOMAIN="$CYASSURE_SETUP_DOMAIN"
            info "Using domain from CYASSURE_SETUP_DOMAIN: ${BASE_DOMAIN}"
        else
            read -p "Enter your base domain name [cyassure.eu]: " USER_DOMAIN
            BASE_DOMAIN="${USER_DOMAIN:-cyassure.eu}"
        fi

        step_header "ENVIRONMENT TYPE"
        # CYASSURE_SETUP_ENV=prod|staging pre-seeds this the same way.
        if [[ -n "${CYASSURE_SETUP_ENV:-}" ]]; then
            _ENV_CHOICE="$CYASSURE_SETUP_ENV"
        else
            echo "  Select environment type:"
            echo "    [1] PROD     — request a real Let's Encrypt certificate"
            echo "    [2] STAGING  — use Let's Encrypt staging (no browser-trusted cert)"
            read -p "  Choice [1/2, default=2]: " _ENV_CHOICE
        fi
        if [[ "$_ENV_CHOICE" == "1" || "$_ENV_CHOICE" == "prod" ]]; then
            CERTBOT_ENV=""
            info "PROD selected — using Let's Encrypt production environment for certbot."
        else
            CERTBOT_ENV="--staging"
            info "STAGING selected — using Let's Encrypt staging environment for certbot."
        fi

        step_header "TLS / HOST VHOST"
        # --tls-mode / CYASSURE_SETUP_TLS_MODE pre-seeds this the same way the
        # two prompts above are pre-seeded — set by the portal's Setup Wizard
        # so its generated command runs unattended. Interactive runs ask.
        if [[ -n "$TLS_MODE" ]]; then
            info "Using TLS mode from --tls-mode/CYASSURE_SETUP_TLS_MODE: ${TLS_MODE}"
        else
            echo "  How should this server's TLS certificate be set up?"
            echo "    [1] Let's Encrypt — direct DNS (recommended; this domain points straight at this server, no CDN/proxy in front)"
            echo "    [2] Let's Encrypt — DNS API (domain is proxied through Cloudflare or another CDN/WAF)"
            echo "    [3] I'll provide my own certificate"
            echo "    [4] Self-signed (evaluation / air-gapped — no public DNS at all)"
            echo "    [5] None — something else (Cloudflare Tunnel, another load balancer) already terminates TLS"
            read -p "  Choice [1-5, default=1]: " _TLS_CHOICE
            case "${_TLS_CHOICE:-1}" in
                2) TLS_MODE="dns01" ;;
                3) TLS_MODE="byo" ;;
                4) TLS_MODE="selfsigned" ;;
                5) TLS_MODE="none" ;;
                *) TLS_MODE="http01" ;;
            esac
            info "TLS mode: ${TLS_MODE}"
        fi

        if [[ "$TLS_MODE" == "dns01" && -z "${CYASSURE_SETUP_DNS_API_TOKEN:-}" ]]; then
            read -r -s -p "  Cloudflare API Token (DNS:Edit scope, this zone): " CYASSURE_SETUP_DNS_API_TOKEN; echo
        elif [[ "$TLS_MODE" == "byo" ]]; then
            [[ -z "${CYASSURE_SETUP_CERT_PATH:-}" ]] && read -r -p "  Full-chain certificate path (on this server): " CYASSURE_SETUP_CERT_PATH
            [[ -z "${CYASSURE_SETUP_KEY_PATH:-}"  ]] && read -r -p "  Private key path (on this server): " CYASSURE_SETUP_KEY_PATH
        fi
    fi

    # CyDataLake is part of the default stack unconditionally now — the
    # Docker Compose app bring-up (see "DOCKER APPLICATION" step) installs
    # redpanda+clickhouse+ingest-worker as standard services with
    # CYDATALAKE_ENABLED=true, no prompt and no opt-out. The old native
    # Kafka+ClickHouse systemd install this block used to gate (a pre-Docker-
    # pivot bare-metal path referencing a `cyassure-backend` systemd service
    # that no longer exists) was removed 2026-08-09 rather than defaulted to
    # "yes" — installing it would have stood up a second, redundant,
    # non-functional Kafka/ClickHouse stack alongside the Docker-native one.

    # Export every collected decision (plus the guard itself) so they survive
    # the self-update re-exec further down.
    export BASE_DOMAIN CERTBOT_ENV
    export _CYASSURE_PROMPTS_DONE=1

fi


# ═══════════════════════════════════════════════════════════════════════════════
# INFRASTRUCTURE BLOCK — skipped when MODE=update
# ═══════════════════════════════════════════════════════════════════════════════

if [[ "$MODE" != "update" ]]; then

# ── Step 1: System packages ───────────────────────────────────────────────────
step_header "SYSTEM DEPENDENCIES"
apt-get update -y -qq
apt-get install -y -qq \
    curl wget gnupg lsb-release ca-certificates jq \
    python3 python3-pip \
    openssl nginx certbot python3-certbot-nginx \
    2>/dev/null
# python3-certbot-dns-cloudflare is only pulled in later, conditionally, by the
# "HOST VHOST + TLS" step when --tls-mode=dns01 is actually selected — no
# point installing a DNS-provider plugin nobody asked for on every install.
# nmap, whois, rsync, git, snmp were installed here for the host itself, not
# for this script — dropped 2026-07-27 after confirming none has a live host-
# side caller anymore: nmap/whois were only ever used by cy_asm scan modules,
# which now run inside the backend container (nmap itself was found MISSING
# from that image and added to backend/Dockerfile as part of this same
# audit — python-whois is pure Python, needs no system binary on either
# side); rsync/git were leftover from the bare-metal portal-rsync-deploy and
# release-tarball-via-git paths, both retired; snmp's CLI tools (snmpwalk
# etc.) are unrelated to pysnmp-lextudio (backend/requirements.txt), which is
# a native asyncio implementation needing no system package at all.
success "System packages installed"

# ── Docker install ─────────────────────────────────────────────────────────────
if command -v docker >/dev/null 2>&1 && docker --version | grep -q "2[4-9]\.\|[3-9][0-9]\."; then
    success "Docker already installed — $(docker --version)"
else
    info "Installing Docker ..."
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        apt-get remove -y "$pkg" 2>/dev/null || true
    done
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
        https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y -qq
    apt-get install -y -qq \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
    systemctl enable docker
    systemctl start docker
    success "Docker installed — $(docker --version)"
fi

# ── Step 1.5: Docker application bring-up (merged in from the old, now-
# deleted scripts/install.sh 2026-08-09) ──────────────────────────────────────
# Only for MODE=full — --infra intentionally installs host prep without the
# app, and --update's job is refreshing host-side assets, not the running
# app stack (that updates via Settings > Update/Upgrade in the portal, or a
# manual `docker compose pull && up -d`; see this script's header). Detects
# an already-brought-up install (docker-compose.yml in the CWD or APP_DIR)
# and skips straight to `cd`'ing into it so every later step in this script
# that assumes CWD == the app's install directory (env sync, health checks,
# etc.) keeps working — this only actually downloads+starts anything on a
# genuinely first-time install.
if [[ "$MODE" == "full" ]]; then
    step_header "DOCKER APPLICATION"

    _APP_COMPOSE_DIR=""
    if [[ -f "./docker-compose.yml" ]]; then
        _APP_COMPOSE_DIR="."
    elif [[ -f "${APP_DIR}/docker-compose.yml" ]]; then
        _APP_COMPOSE_DIR="$APP_DIR"
    fi

    if [[ -n "$_APP_COMPOSE_DIR" ]]; then
        cd "$_APP_COMPOSE_DIR"
        success "Docker app already installed at $(pwd) — skipping bring-up, continuing with host prep"
    else
        # No GH_TOKEN needed here: ghcr.io/cyassure/cy360-* images are public
        # (anonymous `docker pull` works), and the deploy bundle below
        # (docker-compose.yml/.env.example — no product source, ever, see
        # scripts/docker-release.sh's header) is mirrored publicly to
        # cyassure/cy360-install alongside this script itself. GH_TOKEN is only
        # for the later "DOWNLOAD RELEASE BUNDLE" step's CyEDR agent/host-
        # assets bundle, which stays private — unrelated to this step.
        _APP_MIRROR="https://raw.githubusercontent.com/cyassure/cy360-install/main"

        if [[ -n "$APP_VERSION" ]]; then
            _APP_TAG="$APP_VERSION"
        else
            info "Resolving latest version..."
            _APP_TAG=$(curl -fsSL "${_APP_MIRROR}/manifest.json" | jq -r '.latest // empty') \
                || { error "Could not reach ${_APP_MIRROR}/manifest.json to resolve the latest version."; exit 1; }
            [[ -n "$_APP_TAG" ]] || { error "manifest.json had no 'latest' field."; exit 1; }
        fi
        info "Installing ${_APP_TAG}..."

        [[ -e "$APP_DIR" ]] && { error "${APP_DIR} already exists but has no docker-compose.yml — remove it or pass --dir <new-path>."; exit 1; }
        mkdir -p "$APP_DIR"
        info "Downloading deployment bundle..."
        curl -fsSL "${_APP_MIRROR}/bundles/${_APP_TAG}/docker-compose.yml" -o "${APP_DIR}/docker-compose.yml" \
            || { error "No deploy bundle found for ${_APP_TAG} at ${_APP_MIRROR}/bundles/${_APP_TAG}/ — check the version exists in ${_APP_MIRROR}/manifest.json."; exit 1; }
        curl -fsSL "${_APP_MIRROR}/bundles/${_APP_TAG}/.env.example" -o "${APP_DIR}/.env.example"
        curl -fsSL "${_APP_MIRROR}/bundles/${_APP_TAG}/docker-compose.gvm.yml" -o "${APP_DIR}/docker-compose.gvm.yml" 2>/dev/null || true
        success "Bundle downloaded to ${APP_DIR}/"

        cd "$APP_DIR"

        info "Creating /opt/cyassure, /var/lib/cyassure-agent-packages, and /var/log/cyassure..."
        mkdir -p /opt/cyassure /var/lib/cyassure-agent-packages /var/log/cyassure
        chown -R 999:999 /opt/cyassure /var/lib/cyassure-agent-packages /var/log/cyassure
        success "Host data directories ready"

        if [[ ! -f .env ]]; then
            info "Generating .env with random secrets..."
            cp .env.example .env
            sed -i "s/change-me-to-a-strong-random-value/$(openssl rand -hex 24)/" .env
            # Roadmap item #34 Phase 2 (edr-i-54) — a genuinely separate
            # secret from POSTGRES_PASSWORD above, own sed invocation so it
            # gets its own independently-generated value, not a shared one.
            sed -i "s/change-me-to-a-cyassure-app-random-value/$(openssl rand -hex 24)/" .env
            sed -i "s/change-me-to-a-long-random-value/$(openssl rand -hex 32)/" .env
            sed -i "s/change-me-to-a-random-value/$(openssl rand -hex 24)/" .env
            # Deliberately a separate sed invocation from the two above — sharing a
            # placeholder string across env vars would give them the SAME generated
            # secret instead of independent ones ($(openssl rand ...) only runs once
            # per invocation).
            sed -i "s/change-me-to-a-clickhouse-random-value/$(openssl rand -hex 24)/" .env
            _app_proj_name=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9_-]/-/g')
            sed -i "s|^GH_TOKEN=.*|GH_TOKEN=$(_escape_sed_repl "${GH_TOKEN:-}")|" .env
            sed -i "s|^COMPOSE_PROJECT_DIR=.*|COMPOSE_PROJECT_DIR=$(pwd)|" .env
            sed -i "s|^COMPOSE_PROJECT_NAME=.*|COMPOSE_PROJECT_NAME=${_app_proj_name}|" .env
            success ".env created — edit it later for OAuth/SMTP/etc, none of that is required to start."
        else
            info ".env already exists — leaving it as-is."
        fi
        # Roadmap item #34 Phase 2 (edr-i-54) — an existing .env from before
        # CYASSURE_APP_DB_PASSWORD existed as its own secret needs it patched
        # in (matching the CYASSURE_DB_URL back-compat patch pattern
        # elsewhere in this script); db_least_privilege.py falls back to
        # reusing POSTGRES_PASSWORD when this is genuinely absent, but every
        # deployment should get the real fix on its next `docker compose up`.
        if ! grep -q "^CYASSURE_APP_DB_PASSWORD=" .env 2>/dev/null; then
            echo "CYASSURE_APP_DB_PASSWORD=$(openssl rand -hex 24)" >> .env
            info "Added CYASSURE_APP_DB_PASSWORD to .env (separate secret from POSTGRES_PASSWORD)"
        fi
        chmod o+w .env

        info "Pulling images..."
        docker compose pull

        info "Starting the application..."
        docker compose up -d

        _APP_PORT=$(grep -m1 '^APP_PORT=' .env | cut -d= -f2); _APP_PORT="${_APP_PORT:-8080}"
        success "CyAssure 360 ${_APP_TAG} is starting in $(pwd)/"
        info "Once healthy, open http://localhost:${_APP_PORT}"
        info "Default login: cyadmin@cyassure.eu / Admin@123 — change this immediately."
    fi
fi

# ── Step 2/3: PostgreSQL + Redis — DEPRECATED, now Docker services ───────────
# PostgreSQL 16 and Redis used to be installed natively here (bare-metal
# systemd services). The app now runs via `docker compose up -d`
# (docker-compose.yml: db=postgres:16-alpine, redis=redis:7-alpine) — see
# DOCKER_DEPLOYMENT.md. CORR_DB_PASS generation/preservation is kept below
# because Step 6-9 further down still writes it into /opt/cyassure/.env and
# cysiemstack.env for reference/back-compat; nothing here provisions a native
# database or cache anymore.
step_header "CORRELATION DB PASSWORD"

_EXISTING_CORR=$(grep "^POSTGRES_PASSWORD=" /opt/cyassure/cysiemstack.env 2>/dev/null \
    | cut -d= -f2 || true)
CORR_DB_PASS="${_EXISTING_CORR:-$(gen_pass)}"
[[ -n "$_EXISTING_CORR" ]] \
    && info "Preserving existing correlation DB password" \
    || info "Generated new correlation DB password"

# ── Step 4: Nuclei (ProjectDiscovery — not in standard apt repos) ─────────────
step_header "NUCLEI SCANNER"

if command -v nuclei >/dev/null 2>&1; then
    success "Nuclei already installed — $(nuclei -version 2>&1 | head -1)"
else
    info "Installing Nuclei from ProjectDiscovery releases..."
    apt-get install -y -qq unzip 2>/dev/null || true

    # Break into two steps so a 403/rate-limit from the GitHub API doesn't abort the
    # whole script via set -euo pipefail (curl exits 22 on HTTP 4xx with -f flag).
    _NUCLEI_API=$(curl -sSL --max-time 15 \
        "https://api.github.com/repos/projectdiscovery/nuclei/releases/latest" \
        2>/dev/null) || true
    _NUCLEI_URL=$(printf '%s' "$_NUCLEI_API" \
        | python3 -c "import sys,json; assets=json.load(sys.stdin)['assets']; print(next(a['browser_download_url'] for a in assets if 'linux_amd64.zip' in a['name']))" \
        2>/dev/null) || true

    # Fallback: resolve latest tag via HTTP redirect (no API quota needed)
    if [[ -z "$_NUCLEI_URL" ]]; then
        _NUCLEI_TAG=$(curl -sSL -o /dev/null -w '%{url_effective}' --max-time 10 \
            "https://github.com/projectdiscovery/nuclei/releases/latest" 2>/dev/null \
            | sed 's|.*/tag/||') || true
        if [[ -n "$_NUCLEI_TAG" && "$_NUCLEI_TAG" =~ ^v[0-9] ]]; then
            _NUCLEI_URL="https://github.com/projectdiscovery/nuclei/releases/download/${_NUCLEI_TAG}/nuclei_${_NUCLEI_TAG#v}_linux_amd64.zip"
        fi
    fi

    if [[ -z "$_NUCLEI_URL" ]]; then
        warn "Could not resolve Nuclei download URL — skipping. Install manually later."
    else
        curl -fsSL "$_NUCLEI_URL" -o /tmp/nuclei_linux_amd64.zip
        unzip -o /tmp/nuclei_linux_amd64.zip nuclei -d /usr/local/bin/ 2>/dev/null
        chmod +x /usr/local/bin/nuclei
        rm -f /tmp/nuclei_linux_amd64.zip

        if command -v nuclei >/dev/null 2>&1; then
            nuclei -update-templates -silent 2>/dev/null || true
            success "Nuclei installed — $(nuclei -version 2>&1 | head -1)"
        else
            warn "Nuclei binary install failed — ASM Nuclei scanner will be skipped at runtime"
        fi
    fi
fi

fi  # end INFRA block

# reportlab/matplotlib/numpy/Pillow (PDF report generation) and the
# --break-system-packages pip3 detection that used to install them on the
# host were removed 2026-07-27 — those packages are only ever imported by
# code that now runs inside the backend container (backend/requirements.txt
# already pins all four), never by this script or anything else on the host.

# ═══════════════════════════════════════════════════════════════════════════════
# APP BLOCK — runs in all modes
# ═══════════════════════════════════════════════════════════════════════════════

# Ensure jq is present for all modes
command -v jq >/dev/null 2>&1 || apt-get install -y -qq jq

# In update mode read CORR_DB_PASS from existing env
if [[ "$MODE" == "update" ]]; then
    # Try standalone POSTGRES_PASSWORD= line first (written by v1.0.61+)
    CORR_DB_PASS=$(grep "^POSTGRES_PASSWORD=" /opt/cyassure/cysiemstack.env 2>/dev/null \
        | sed 's/^POSTGRES_PASSWORD=//' | tr -d '"' || true)
    # Fallback: extract from DATABASE_URL (installs prior to v1.0.61 had no standalone key)
    if [[ -z "$CORR_DB_PASS" ]]; then
        CORR_DB_PASS=$(grep "^DATABASE_URL=" /opt/cyassure/cysiemstack.env 2>/dev/null \
            | sed 's|.*://[^:]*:\([^@]*\)@.*|\1|' || true)
        [[ -n "$CORR_DB_PASS" ]] && info "Correlation DB password recovered from DATABASE_URL"
    fi
    if [[ -z "$CORR_DB_PASS" ]]; then
        warn "POSTGRES_PASSWORD not found in /opt/cyassure/cysiemstack.env — generating a new one"
        warn "If the correlation DB already exists, update POSTGRES_PASSWORD in cysiemstack.env manually"
        CORR_DB_PASS=$(gen_pass)
    fi
fi

# ── Download release bundle ───────────────────────────────────────────────────
step_header "DOWNLOAD RELEASE BUNDLE"

# In update mode .env is not sourced until Step 5, so read GH_TOKEN early
# from .env if it is not already in the shell environment.
if [[ -z "${GH_TOKEN:-}" && -f "/opt/cyassure/.env" ]]; then
    GH_TOKEN="$(grep '^GH_TOKEN=' /opt/cyassure/.env 2>/dev/null | head -1 | cut -d= -f2- | tr -d ' \r')"
fi
GH_ORG="cyassure"
GH_REPO="cy360"

# ── Detect local bundle (running from inside an already-extracted tarball) ────
# When the server runs:  tar -xzf bundle.tar.gz && sudo bash cyassure-setup.sh
# manifest.json will be in the same directory as this script.  In that case
# we skip the download entirely — GH_TOKEN is not required.
#
# Derived from _SCRIPT_ABS_PATH (captured at the very top of the script,
# before any `cd`) rather than re-resolving BASH_SOURCE[0]/$0 here — by this
# point the "DOCKER APPLICATION" step above has already cd'd into APP_DIR, so
# a relative $0 would resolve against the WRONG (now-current) directory
# instead of where the script actually lives. Same bug class fixed for
# _SELF/_SETUP_DEST and _SCRIPT_BASE further down — see _SCRIPT_ABS_PATH's
# own comment at the top of the file.
_SCRIPT_DIR="$(dirname "$_SCRIPT_ABS_PATH")"
BUNDLE_DIR="/tmp/cyassure-release"
# Tracks whether $BUNDLE_DIR is scratch space this script created (safe to
# rm -rf at Step 25 below) or an existing directory it's merely reading from.
# See that step's comment for the incident this guards against.
_BUNDLE_IS_TEMP=false

if [[ -f "$_SCRIPT_DIR/manifest.json" && "$_SCRIPT_DIR" != "/opt/cyassure" ]]; then
    info "Local bundle detected — skipping download"
    BUNDLE_DIR="$_SCRIPT_DIR"
    # Resolve version from local bundle for the update-mode pre-check below
    CYASSURE_VERSION=$(cat "$_SCRIPT_DIR/VERSION" 2>/dev/null || jq -r '.version' "$_SCRIPT_DIR/manifest.json" 2>/dev/null || echo "unknown")
    _RELEASE_JSON=""
else
    # ── Remote download path ───────────────────────────────────────────────
    # Public mirror (no token needed) unless GH_TOKEN is explicitly set, in
    # which case the private release path below is used instead (unchanged,
    # kept for pre-release/private testing).
    #
    # 2026-08-26: this used to hard-require GH_TOKEN and skip host-assets
    # staging entirely without one. Reconsidered — the host-assets content
    # (CyEDR agent/tray binaries, YARA/Sysmon, install/uninstall scripts,
    # RELEASE_NOTES.md) does not differ between Community and Enterprise
    # (core/license_validator.py), and Community is license-free (no .lic to
    # embed a scoped download credential into even if we wanted to), so
    # requiring a personal GitHub PAT on every fresh install AND every
    # --update bought no real commercial boundary — only friction. deploy.yml
    # (build-and-publish / build-edr-macos / build-edr-windows) now mirrors
    # this same content to the public cyassure/cy360-install repo on every
    # release, the same public repo the "DOCKER APPLICATION" step above
    # already pulls docker-compose.yml/.env.example from.
    if [[ -z "${GH_TOKEN:-}" ]]; then
        _HA_MIRROR="https://raw.githubusercontent.com/cyassure/cy360-install/main"
        info "No GH_TOKEN — fetching host-assets from the public mirror instead..."
        _HA_TAG="${APP_VERSION:-}"
        if [[ -z "$_HA_TAG" ]]; then
            _HA_TAG=$(curl -fsSL "${_HA_MIRROR}/manifest.json" 2>/dev/null | jq -r '.latest // empty')
        fi
        if [[ -z "$_HA_TAG" ]]; then
            warn "Could not resolve latest version from the public mirror — skipping host-assets staging"
            warn "(CyEDR asset staging, Sysmon staging, RELEASE_NOTES.md, and self-update). Pass --token <PAT> to use the private release instead."
            BUNDLE_DIR=""
            CYASSURE_VERSION="${APP_VERSION:-unknown}"
            _RELEASE_JSON=""
        else
            _HA_BASE="${_HA_MIRROR}/host-assets/${_HA_TAG}"
            BUNDLE_DIR="/tmp/cyassure-release"
            rm -rf "$BUNDLE_DIR"
            mkdir -p "$BUNDLE_DIR/scripts" "$BUNDLE_DIR/agent/assets/yara" "$BUNDLE_DIR/agent/assets/sysmon" "$BUNDLE_DIR/agent-packages/edr"
            _BUNDLE_IS_TEMP=true
            _ha_ok=0
            curl -fsSL "${_HA_BASE}/manifest.json"                                  -o "$BUNDLE_DIR/manifest.json"                                  2>/dev/null && _ha_ok=1
            curl -fsSL "${_HA_BASE}/cyassure-setup.sh"                              -o "$BUNDLE_DIR/cyassure-setup.sh"                              2>/dev/null
            curl -fsSL "${_HA_BASE}/scripts/cyedr-install.sh"                       -o "$BUNDLE_DIR/scripts/cyedr-install.sh"                       2>/dev/null
            curl -fsSL "${_HA_BASE}/scripts/cyedr-install.ps1"                      -o "$BUNDLE_DIR/scripts/cyedr-install.ps1"                      2>/dev/null
            curl -fsSL "${_HA_BASE}/scripts/cyedr-uninstall.sh"                     -o "$BUNDLE_DIR/scripts/cyedr-uninstall.sh"                     2>/dev/null
            curl -fsSL "${_HA_BASE}/scripts/cyedr-uninstall.ps1"                    -o "$BUNDLE_DIR/scripts/cyedr-uninstall.ps1"                    2>/dev/null
            curl -fsSL "${_HA_BASE}/agent/AGENT_VERSION"                            -o "$BUNDLE_DIR/agent/AGENT_VERSION"                            2>/dev/null
            curl -fsSL "${_HA_BASE}/agent/assets/yara/cyassure.yar"                 -o "$BUNDLE_DIR/agent/assets/yara/cyassure.yar"                 2>/dev/null
            curl -fsSL "${_HA_BASE}/agent/assets/sysmon/cyassure_sysmon_config.xml" -o "$BUNDLE_DIR/agent/assets/sysmon/cyassure_sysmon_config.xml" 2>/dev/null
            curl -fsSL "${_HA_BASE}/RELEASE_NOTES.md"                               -o "$BUNDLE_DIR/RELEASE_NOTES.md"                               2>/dev/null
            for _ha_bin in cyedr-agent-linux-x86_64 cyedr-agent-linux-aarch64 cyedr-tray-linux-x86_64 cyedr-tray-linux-aarch64; do
                curl -fsSL "${_HA_BASE}/agent-packages/edr/${_ha_bin}" -o "$BUNDLE_DIR/agent-packages/edr/${_ha_bin}" 2>/dev/null \
                    || rm -f "$BUNDLE_DIR/agent-packages/edr/${_ha_bin}"
            done
            if [[ "$_ha_ok" == "1" ]]; then
                success "Host-assets fetched from public mirror (${_HA_TAG})"
            else
                warn "Public mirror did not have host-assets for ${_HA_TAG} yet (release still publishing?) — some CyEDR asset staging may be incomplete this run. Re-run with --update once it's synced, or pass --token <PAT> for the private release."
            fi
            CYASSURE_VERSION="$_HA_TAG"
            _RELEASE_JSON=""
        fi
    else
    # Step 1: resolve latest release metadata (single API call — no maven)
    info "Fetching latest release metadata from GitHub..."
    _RELEASE_JSON=$(curl -fsSL \
        -H "Authorization: Bearer ${GH_TOKEN}" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/${GH_ORG}/${GH_REPO}/releases/latest")

    CYASSURE_VERSION=$(echo "$_RELEASE_JSON" | jq -r '.tag_name')
    [[ -z "$CYASSURE_VERSION" || "$CYASSURE_VERSION" == "null" ]] && \
        { error "Could not resolve latest release from GitHub API — check GH_TOKEN (needs repo scope)"; exit 1; }
    info "Latest release: ${CYASSURE_VERSION}"

    # Step 2: find the host-assets bundle in release metadata.
    # NOTE: named "cy360-host-assets-*.tar.gz" (added to deploy.yml
    # 2026-07-27) — NOT the "cy360-docker-*.tar.gz" customer bundle that
    # docker-publish.yml also uploads to the same release (that one is the
    # docker-compose.yml/.env.example/README bundle this script's own
    # "DOCKER APPLICATION" step downloads; this one is host-side assets this
    # script itself needs: manifest.json, CyEDR agent source + install
    # scripts + prebuilt Linux binaries, YARA/Sysmon assets, RELEASE_NOTES.md,
    # and a copy of this script for self-update).
    # Previously looked for a "cyassure-release"-named asset containing a
    # wheel + full backend/portal source tree — that format (and the wheel
    # entirely) was retired along with bare-metal hosting; this step wasn't
    # updated to match until 2026-07-27, so it always failed with "Bundle
    # asset not found" in between.
    _bundle_asset_url=$(echo "$_RELEASE_JSON" | \
        jq -r '.assets[] | select(.name | test("^cy360-host-assets-.*\\.tar\\.gz$")) | .url' | head -1)
    if [[ -z "$_bundle_asset_url" || "$_bundle_asset_url" == "null" ]]; then
        warn "No cy360-host-assets-*.tar.gz asset in release ${CYASSURE_VERSION} — check .github/workflows/deploy.yml published correctly"
        warn "CyEDR asset staging, Sysmon staging, RELEASE_NOTES.md, and self-update will be skipped this run"
        BUNDLE_DIR=""
    else
        # Step 3: download via asset API URL (required for private repos — direct URL returns 404)
        rm -rf "$BUNDLE_DIR" /tmp/cy360-host-assets.tar.gz
        info "Downloading host-assets bundle..."
        curl -fsSL \
            -H "Authorization: Bearer ${GH_TOKEN}" \
            -H "Accept: application/octet-stream" \
            "$_bundle_asset_url" \
            -o /tmp/cy360-host-assets.tar.gz \
            && success "Bundle downloaded" \
            || { error "Bundle download failed — check GH_TOKEN permissions"; exit 1; }
        mkdir -p "$BUNDLE_DIR"
        tar -xzf /tmp/cy360-host-assets.tar.gz -C "$BUNDLE_DIR"
        _BUNDLE_IS_TEMP=true
    fi
    fi
fi

# ── Version pre-check (update mode only) ─────────────────────────────────────
# NOTE: we do NOT exit early when already at the latest version.
# Pip install is idempotent and the service restarts below are required to
# ensure the running engine process loads the latest deployed bytecode.
# Without the restart, stale in-memory bytecode survives indefinitely even
# when .py files on disk are updated by pip.
if [[ "$MODE" == "update" && "${FORCE_UPDATE:-0}" != "1" ]]; then
    _installed_ver=$(cat /opt/cyassure/version 2>/dev/null | tr -d '[:space:]' || echo "")
    if [[ -n "$_installed_ver" && "$_installed_ver" == "$CYASSURE_VERSION" ]]; then
        echo ""
        success "Already at the latest version: ${CYASSURE_VERSION}"
        info    "Re-applying packages and restarting services to ensure running code is current."
    elif [[ -n "$_installed_ver" ]]; then
        info "Update available: ${_installed_ver} → ${CYASSURE_VERSION}"
    fi
fi

# Host-assets bundle (and its manifest.json) is optional — see the "cy360-
# host-assets" resolution above. Fall back to CYASSURE_VERSION (the tag name
# already resolved from the GitHub API, or the local bundle's VERSION file)
# rather than hard-exiting; nothing here is required for this script's still-
# live purposes (IAP gateway, UFW, SSH hardening, cron).
MANIFEST="${BUNDLE_DIR:+$BUNDLE_DIR/manifest.json}"
if [[ -n "$MANIFEST" && -f "$MANIFEST" ]]; then
    BUNDLE_VERSION=$(jq -r '.version' "$MANIFEST")
else
    BUNDLE_VERSION="${CYASSURE_VERSION:-unknown}"
    [[ -n "$MANIFEST" ]] && warn "manifest.json not found in bundle at ${BUNDLE_DIR} — using ${BUNDLE_VERSION} from release metadata"
fi

success "Bundle version  : ${BUNDLE_VERSION}"

# Write version file (always — so System Settings page can read it)
mkdir -p /opt/cyassure
echo "${BUNDLE_VERSION}" > /opt/cyassure/version
success "Version file written: /opt/cyassure/version → ${BUNDLE_VERSION}"

# ── Early package dir setup ──────────────────────────────────────────────────
# Created NOW — before the self-copy below overwrites this script — so the
# CyEDR asset staging block right after it (which relies on this dir) always
# has somewhere to write. Bash is still reading the file it originally opened
# here, so this runs on every run regardless of inode behaviour.
_EARLY_PKG_DIR="/var/lib/cyassure-agent-packages"
mkdir -p "$_EARLY_PKG_DIR"
chmod 755 "$_EARLY_PKG_DIR"; chown www-data:www-data "$_EARLY_PKG_DIR" 2>/dev/null || true

# ── Stage CyEDR installer + agent files (mirrors agent package seeding above) ─
# Source files live in the repo; this block copies them to the NGINX-served dir
# automatically on every install/update run — no manual download-packages step needed.
_EDR_PKG_DEST="${_EARLY_PKG_DIR}/edr"
mkdir -p "$_EDR_PKG_DEST"
chmod 755 "$_EDR_PKG_DEST"; chown www-data:www-data "$_EDR_PKG_DEST" 2>/dev/null || true

for _edr_src_dest in \
    "${BUNDLE_DIR}/scripts/cyedr-install.sh:cyedr-install.sh" \
    "${BUNDLE_DIR}/scripts/cyedr-install.ps1:cyedr-install.ps1" \
    "${BUNDLE_DIR}/scripts/cyedr-uninstall.sh:cyedr-uninstall.sh" \
    "${BUNDLE_DIR}/scripts/cyedr-uninstall.ps1:cyedr-uninstall.ps1" \
    "${BUNDLE_DIR}/agent/AGENT_VERSION:AGENT_VERSION" \
    "${BUNDLE_DIR}/agent/assets/yara/cyassure.yar:cyassure.yar"; do
    _src="${_edr_src_dest%%:*}"
    _dst_name="${_edr_src_dest##*:}"
    if [[ -f "$_src" ]]; then
        cp -f "$_src" "${_EDR_PKG_DEST}/${_dst_name}"
        chmod 644 "${_EDR_PKG_DEST}/${_dst_name}"
        chown www-data:www-data "${_EDR_PKG_DEST}/${_dst_name}" 2>/dev/null || true
        success "CyEDR asset staged: ${_dst_name}"
    else
        warn "CyEDR asset not found in bundle: ${_src##*/}"
    fi
done

# Write RELEASE_NOTES.md for System Settings page — shipped inside the release bundle
_RN_DEST="/opt/cyassure/RELEASE_NOTES.md"
mkdir -p /opt/cyassure

# Root of the bundle is canonical (moved there from docs/RELEASE_NOTES.md
# 2026-08-24 — docs/ is gitignored, so a file living there could never reach
# a CI-built bundle no matter how well git-push.sh maintained it locally,
# which is exactly why this warning fired on every single release before).
# docs/ kept as a fallback only for leniency with an old-format bundle.
if [[ -f "$BUNDLE_DIR/RELEASE_NOTES.md" ]]; then
    cp "$BUNDLE_DIR/RELEASE_NOTES.md" "$_RN_DEST"
    success "RELEASE_NOTES.md deployed to ${_RN_DEST}"
elif [[ -f "$BUNDLE_DIR/docs/RELEASE_NOTES.md" ]]; then
    cp "$BUNDLE_DIR/docs/RELEASE_NOTES.md" "$_RN_DEST"
    success "RELEASE_NOTES.md deployed to ${_RN_DEST}"
else
    warn "RELEASE_NOTES.md not found in bundle — Settings tab release history may be outdated"
fi

# Update /opt/cyassure/cyassure-setup.sh from the bundle (idempotent).
# When invoked as `bash /opt/cyassure/cyassure-setup.sh --update` the self-copy
# below is a no-op (_SELF == _SETUP_DEST).  Preferring the bundle copy fixes that:
# on the first run the bundle's newer .sh is written to /opt/cyassure/; subsequent
# runs see identical files and skip the copy.
_SELF="$_SCRIPT_ABS_PATH"
_SETUP_DEST="/opt/cyassure/cyassure-setup.sh"
_BUNDLE_SETUP="$BUNDLE_DIR/cyassure-setup.sh"
if [[ -f "$_BUNDLE_SETUP" ]] && \
   ! cmp -s "$_BUNDLE_SETUP" "$_SETUP_DEST" 2>/dev/null; then
    cp "$_BUNDLE_SETUP" "$_SETUP_DEST"
    chmod 750 "$_SETUP_DEST"
    success "Setup script updated from bundle — re-executing new version..."
    # Re-exec from the bundle copy so the NEW script runs completely from line 1.
    # Running from $BUNDLE_DIR means manifest.json is present → local bundle detection
    # fires → download is skipped → bundle-seed copies agent packages → no 404.
    exec bash "$_BUNDLE_SETUP" "$@"
elif [[ "$_SELF" != "$_SETUP_DEST" ]]; then
    cp "$_SELF" "$_SETUP_DEST"
    chmod 750  "$_SETUP_DEST"
    success "Setup script deployed to $_SETUP_DEST"
else
    success "Setup script already current at $_SETUP_DEST"
fi

# Deploy docker-maintenance.sh alongside setup script
# Use BUNDLE_DIR so this works in both fresh-install (BUNDLE_DIR==_SCRIPT_DIR) and
# portal --update paths (script runs from /opt/cyassure but bundle is at /tmp/cyassure-release).
_MAINT_SRC="${BUNDLE_DIR}/docker-maintenance.sh"
[[ ! -f "$_MAINT_SRC" ]] && _MAINT_SRC="${_SCRIPT_DIR}/docker-maintenance.sh"   # fallback for dev
_MAINT_DEST="/opt/cyassure/docker-maintenance.sh"
if [[ -f "$_MAINT_SRC" ]]; then
    if [[ "$(realpath "$_MAINT_SRC")" != "$(realpath "$_MAINT_DEST" 2>/dev/null)" ]]; then
        cp "$_MAINT_SRC" "$_MAINT_DEST"
        chmod 750 "$_MAINT_DEST"
        success "docker-maintenance.sh deployed to ${_MAINT_DEST}"
    else
        success "docker-maintenance.sh already at ${_MAINT_DEST} — no copy needed"
    fi
else
    # Not in bundle — check if a previous install already deployed it.
    # If so, keep the existing copy silently.
    # If not, this is a fresh server: the Flask backend generates and writes
    # docker-maintenance.sh automatically the first time the Scheduler is saved
    # in System Settings → Scheduler (via _write_docker_maintenance_script()).
    # No manual action is required.
    if [[ -f "$_MAINT_DEST" ]]; then
        success "docker-maintenance.sh already present at ${_MAINT_DEST} — keeping existing copy"
    else
        info "docker-maintenance.sh not in bundle — will be created automatically when Scheduler is saved in System Settings"
    fi
fi

# NOTE: Docker maintenance schedule is managed by the CyAssure 360 Scheduler
# (System Settings → Scheduler tab). When the schedule is enabled and saved,
# the Flask backend generates and writes docker-maintenance.sh to /opt/cyassure/
# automatically (via _write_docker_maintenance_script() in blueprints/system/routes.py).
# cron entries are written by the portal's /api/system/schedules endpoint.

# Deploy license validator + watchdog scripts
_SCRIPT_BASE="$(dirname "$_SCRIPT_ABS_PATH")"
if [[ -f "$_SCRIPT_BASE/license_validator.py" ]]; then
    cp "$_SCRIPT_BASE/license_validator.py" /opt/cyassure/license_validator.py
    chmod 755 /opt/cyassure/license_validator.py
    success "License validator deployed → /opt/cyassure/license_validator.py"
elif [[ -f "$BUNDLE_DIR/license_validator.py" ]]; then
    cp "$BUNDLE_DIR/license_validator.py" /opt/cyassure/license_validator.py
    chmod 755 /opt/cyassure/license_validator.py
    success "License validator deployed from bundle"
else
    # Not in bundle or alongside installer.
    # Two self-healing mechanisms exist — no action required:
    #   1. If /opt/cyassure/license_validator.py already exists (previous install
    #      or prior --update), it is used as an override by the Flask backend
    #      (see _LIC_VALIDATOR in blueprints/system/routes.py).
    #   2. If it does not exist, the Flask license endpoint (_run_validator())
    #      imports core.license_validator.validate() directly in-process from
    #      the backend Docker image — no file needs to be staged here at all
    #      for normal operation (fixed 2026-07-27; this used to reference a
    #      now-retired "installed cyassure-backend wheel" path that no longer
    #      exists post Docker-pivot).
    # The deployed copy at /opt/cyassure/ is only needed for the daily watchdog
    # cron (itself a known open gap — see this file's header) and for shipping
    # a vendor-supplied updated validator without a full image rebuild. It is
    # deployed on the next --update once the file is in the bundle.
    if [[ -f "/opt/cyassure/license_validator.py" ]]; then
        success "license_validator.py already present at /opt/cyassure/ — keeping existing copy"
    else
        info "license_validator.py not in bundle — license UI uses in-package fallback; daily watchdog will use it once deployed via --update"
    fi
fi

# If a license file is present alongside the installer, copy it in
if [[ -f "$_SCRIPT_BASE/cyassure.lic" && ! -f /opt/cyassure/cyassure.lic ]]; then
    cp "$_SCRIPT_BASE/cyassure.lic" /opt/cyassure/cyassure.lic
    chmod 600 /opt/cyassure/cyassure.lic
    success "License file installed → /opt/cyassure/cyassure.lic"
fi
# ── Step 6-9: Interactive config (full install only) ─────────────────────────

if [[ "$MODE" == "full" ]]; then
    # Use BASE_DOMAIN from earlier prompt or .env
    if [[ ! -f "/opt/cyassure/.env" ]]; then
        BASE_DOMAIN="${BASE_DOMAIN:-cyassure.eu}"
    else
        source /opt/cyassure/.env
        BASE_DOMAIN="${BASE_DOMAIN:-cyassure.eu}"
    fi
    
    # ── No interactive prompts — all config is set via environment variables or
    # ── edited in /opt/cyassure/.env post-install.
    CLIENT_NAME="${CLIENT_NAME:-cyassure}"
    CLIENT_EMAIL="${CLIENT_EMAIL:-admin@cyassure.eu}"
    BASE_DOMAIN="${BASE_DOMAIN:-cyassure.eu}"
    OAUTH_PROVIDER="${OAUTH_PROVIDER:-google}"
    # ── OAuth credentials — loaded from Azure Key Vault at runtime.
    # Written as empty here; the app fetches them from Key Vault on startup
    # (AZURE_KEYVAULT_URL must be set in .env pointing to your vault).
    GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID:-}"
    GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET:-}"
    MICROSOFT_CLIENT_ID="${MICROSOFT_CLIENT_ID:-}"
    MICROSOFT_CLIENT_SECRET="${MICROSOFT_CLIENT_SECRET:-}"
    AI_PROVIDER="none"; AI_API_KEY=""; AI_MODEL=""
    SMTP_HOST=""; SMTP_PORT=""; SMTP_USER=""; SMTP_PASS=""; SUPPORT_EMAIL="support@${BASE_DOMAIN}"
    INSTALL_CYSIEM=true; INSTALL_CYSOAR=true

    info "Domain : ${BASE_DOMAIN}  |  OAuth: ${OAUTH_PROVIDER}"
    info "Post-install → edit /opt/cyassure/.env and restart: systemctl restart cyassure"

    step_header "GENERATING SECRETS"
    _env="/opt/cyassure/.env"
    _get() { grep -m1 "^${1}=" "$_env" 2>/dev/null | cut -d= -f2- | tr -d '"' || true; }
    if [[ -f "$_env" ]]; then
        info "Existing .env found — preserving session secrets"
        FLASK_SECRET=$(_get SECRET_KEY);   [[ -z "$FLASK_SECRET"   ]] && FLASK_SECRET=$(gen_secret)
        JWT_SECRET=$(_get JWT_SECRET);     [[ -z "$JWT_SECRET"     ]] && JWT_SECRET=$(gen_secret)
        NODERED_SECRET=$(_get NODE_RED_CREDENTIAL_SECRET)
        [[ -z "$NODERED_SECRET" ]] && NODERED_SECRET=$(gen_secret)
    else
        FLASK_SECRET=$(gen_secret); JWT_SECRET=$(gen_secret)
        NODERED_SECRET=$(gen_secret)
    fi
    ADMIN_API_KEY=$(gen_secret)
    CYSOAR_OIDC_SECRET=$(gen_secret)
    CYSIEM_OIDC_SECRET=$(gen_secret)
    CY360SSO_OIDC_SECRET=$(gen_secret)
    # oauth2-proxy: client secret (used by CyAssure OIDC) + 32-byte cookie secret
    OAUTH2PROXY_SECRET=$(gen_secret)
    OAUTH2PROXY_COOKIE_SECRET=$(openssl rand -base64 32 | tr -d '\n' | head -c 32)
    success "All secrets ready"

else
    # Update mode — read existing config from .env
    info "Update mode — reading configuration from /opt/cyassure/.env ..."
    [[ ! -f /opt/cyassure/.env ]] && {
        error "/opt/cyassure/.env not found. Run full install first."
        exit 1
    }
    set -a; source /opt/cyassure/.env; set +a
    CLIENT_NAME="${CLIENT_NAME:-cyassure}"
    CLIENT_EMAIL="${CLIENT_EMAIL:-admin@cyassure.eu}"
    BASE_DOMAIN="${BASE_DOMAIN:-cyassure.eu}"
    INSTALL_CYSIEM=true; INSTALL_CYSOAR=true
    success "Loaded existing configuration (domain: ${BASE_DOMAIN})"

    # ── Patch .env for update mode ────────────────────────────────────────────
    # SAFE: only removes specific dead/orphaned vars by name, and only appends
    # vars that are missing entirely.  Customer custom entries ARE preserved.
    # The full .env is NEVER rewritten in update mode — only surgical edits.
    step_header "PATCHING /opt/cyassure/.env"
    _env="/opt/cyassure/.env"

    # Remove dead / orphaned variables
    for _dead in USE_CUSTOM_IMAGES SIEM_LLM_ENABLED SIEM_MISP_ENABLED \
                 AI_PROVIDER AI_API_KEY AI_MODEL \
                 POSTGRES_PASSWORD; do
        if grep -q "^${_dead}=" "$_env" 2>/dev/null; then
            sed -i "/^${_dead}=/d" "$_env"
            info "Removed orphaned var: ${_dead}"
        fi
    done

    # Add CLOUD_MISP_* if missing (introduced in v1.0.X)
    if ! grep -q "^CLOUD_MISP_URL=" "$_env" 2>/dev/null; then
        cat >> "$_env" << PATCHEOF

# ── Cloud CyMISP (Cyassure-managed MISP at cymisp.cyassure.eu) ────────────────
CLOUD_MISP_URL=${CLOUD_MISP_URL:-https://cymisp.cyassure.eu}
CLOUD_MISP_API_KEY=${CLOUD_MISP_API_KEY:-}
AZURE_KEYVAULT_URL=${AZURE_KEYVAULT_URL:-}
PATCHEOF
        info "Added CLOUD_MISP_* to .env"
    fi

    # Backfill CLOUD_MISP defaults if the value was written empty (pre-v1.2.56)
    if grep -q "^CLOUD_MISP_URL=$" "$_env" 2>/dev/null; then
        _fill_misp_url="${CLOUD_MISP_URL:-https://cymisp.cyassure.eu}"
        sed -i "s|^CLOUD_MISP_URL=$|CLOUD_MISP_URL=${_fill_misp_url}|" "$_env"
        info "Backfilled CLOUD_MISP_URL → ${_fill_misp_url}"
    fi
    if grep -q "^CLOUD_MISP_API_KEY=$" "$_env" 2>/dev/null; then
        _fill_misp_key="${CLOUD_MISP_API_KEY:-BPxY79PEX9Y39eooVpNVu0UpayhYaqCfe74ZOHJb}"
        sed -i "s|^CLOUD_MISP_API_KEY=$|CLOUD_MISP_API_KEY=${_fill_misp_key}|" "$_env"
        info "Backfilled CLOUD_MISP_API_KEY default"
    fi


    # Add CYSIEM_OIDC_SECRET if missing (SSO v1 — introduced with full OIDC)
    if ! grep -q "^CYSIEM_OIDC_SECRET=" "$_env" 2>/dev/null; then
        echo "CYSIEM_OIDC_SECRET=$(openssl rand -hex 32)" >> "$_env"
        info "Added CYSIEM_OIDC_SECRET to .env"
    fi

    # Add CYMIND_API_* if missing (central CyMind vault-managed credentials)
    if ! grep -q "^CYMIND_API_URL=" "$_env" 2>/dev/null; then
        cat >> "$_env" << PATCHEOF

# ── CyMind (central AI hub — company-wide instance) ───────────────────────────
# Populated at startup from vault (CYMIND-API-URL / CYMIND-API-KEY).
# Leave empty to use vault injection; set non-empty to override vault.
CYMIND_API_URL=${CYMIND_API_URL:-}
CYMIND_API_KEY=${CYMIND_API_KEY:-}
PATCHEOF
        info "Added CYMIND_API_* to .env"
    fi

    # Add CY360SSO_OIDC_SECRET if missing (portal self-IdP SSO client)
    if ! grep -q "^CY360SSO_OIDC_SECRET=" "$_env" 2>/dev/null; then
        echo "CY360SSO_OIDC_SECRET=$(openssl rand -hex 32)" >> "$_env"
        info "Added CY360SSO_OIDC_SECRET to .env"
    fi

    # Add IAP oauth2-proxy secrets if missing (introduced with IAP switch)
    if ! grep -q "^OAUTH2PROXY_SECRET=" "$_env" 2>/dev/null; then
        _new_oauth2_secret=$(openssl rand -hex 32)
        _new_cookie_secret=$(openssl rand -base64 32 | tr -d '\n' | head -c 32)
        cat >> "$_env" << PATCHEOF

# ── IAP oauth2-proxy secrets ───────────────────────────────────────────────────
OAUTH2PROXY_SECRET=${_new_oauth2_secret}
OAUTH2PROXY_COOKIE_SECRET=${_new_cookie_secret}
PATCHEOF
        info "Added OAUTH2PROXY_SECRET + OAUTH2PROXY_COOKIE_SECRET to .env"
        # Export into current session so the IAP setup step below can use them
        OAUTH2PROXY_SECRET="$_new_oauth2_secret"
        OAUTH2PROXY_COOKIE_SECRET="$_new_cookie_secret"
    fi

    # Add CYASSURE_APP_DB_PASSWORD if missing (roadmap item #34 Phase 2,
    # edr-i-54) — a genuinely separate secret from POSTGRES_PASSWORD. The
    # fresh-install branch above (DOCKER APPLICATION step) already backfills
    # this for a NEW install, but that block never runs for an EXISTING one
    # (it's gated on docker-compose.yml not existing yet), so an existing
    # deployment from before this var existed never got it here — found live
    # via the portal's Update/Upgrade buttons hard-failing `docker compose
    # pull` with "CYASSURE_APP_DB_PASSWORD is missing a value" once a release
    # synced in a docker-compose.yml referencing it (see updater/server.py's
    # _backfill_env_vars, the equivalent patch for that code path). A freshly
    # generated value here needs no coordination: backend/core/
    # db_least_privilege.py ALTERs the cyassure_app Postgres role's password
    # to match whatever this holds on every backend boot.
    if ! grep -q "^CYASSURE_APP_DB_PASSWORD=" "$_env" 2>/dev/null; then
        echo "CYASSURE_APP_DB_PASSWORD=$(openssl rand -hex 24)" >> "$_env"
        info "Added CYASSURE_APP_DB_PASSWORD to .env (separate secret from POSTGRES_PASSWORD)"
    fi

    # Add CYASSURE_DB_URL if missing (introduced with PostgreSQL-backed RBAC)
    # cyassure_app, not corruser — roadmap item #34 Phase 2: corruser is a
    # Postgres superuser by default, which bypasses RLS. See
    # backend/core/db_least_privilege.py and docker-compose.yml's backend
    # service comment for the full fix.
    if ! grep -q "^CYASSURE_DB_URL=" "$_env" 2>/dev/null; then
        _CY_DB_URL="postgresql://cyassure_app:${CORR_DB_PASS}@127.0.0.1:5433/correlation"
        cat >> "$_env" << PATCHEOF

# ── CyAssure 360 user DB — Flask RBAC backed by PostgreSQL ─────────────────────
CYASSURE_DB_URL=${_CY_DB_URL}
PATCHEOF
        info "Added CYASSURE_DB_URL to .env"
    fi

    # Add ASM scanner tuning vars if missing (introduced with protocol-probe engine)
    if ! grep -q "^PROTO_PROBE_TIMEOUT=" "$_env" 2>/dev/null; then
        cat >> "$_env" << PATCHEOF

# ── ASM Scanner tuning ────────────────────────────────────────────────────────
ENABLE_EXTENDED_PORT_SCAN=false
ENABLE_UDP_SCAN=false
PROTO_PROBE_TIMEOUT=5
INFRA_EXPOSURE_PORTS=2375,2376,6443,9200,9300,11211,5900,9090,9091,8161
PATCHEOF
        info "Added ASM scanner tuning vars to .env"
    fi

    # Add MAXMIND_KEY if missing (hardcoded default shipped with setup.sh)
    if ! grep -q "^MAXMIND_KEY=" "$_env" 2>/dev/null; then
        echo "MAXMIND_KEY=${MAXMIND_KEY:-}" >> "$_env"
        info "Added MAXMIND_KEY to .env"
    fi

    # Remove stale CYMIND_API_KEY / CYMIND_API_URL from cysiemstack.env.
    # v1.2.45+ moves these shared keys to .env which the engine service now loads
    # FIRST via EnvironmentFile=/opt/cyassure/.env. If the old cymk_ admin key is
    # still present in cysiemstack.env it wins (last EnvironmentFile wins for
    # duplicate keys) and overrides the correct CyM_ chat key, causing 401 on
    # every SIEM AI analysis call.
    _siem_env_cymi="/opt/cyassure/cysiemstack.env"
    if [[ -f "$_siem_env_cymi" ]]; then
        _cymi_changed=false
        if grep -q "^CYMIND_API_KEY=" "$_siem_env_cymi" 2>/dev/null; then
            sed -i "/^CYMIND_API_KEY=/d" "$_siem_env_cymi"
            _cymi_changed=true
        fi
        if grep -q "^CYMIND_API_URL=" "$_siem_env_cymi" 2>/dev/null; then
            sed -i "/^CYMIND_API_URL=/d" "$_siem_env_cymi"
            _cymi_changed=true
        fi
        [[ "$_cymi_changed" == "true" ]] && \
            info "Removed stale CYMIND_API_KEY/URL from cysiemstack.env (now inherited from .env)"
    fi

    chmod 600 "$_env"
    success ".env patched"
fi
if [[ "$MODE" == "full" ]]; then

    step_header "WRITING CONFIGURATION FILES"
    mkdir -p /opt/cyassure && chmod 700 /opt/cyassure

    # Reset demo clock on every fresh full install — prevents a stale .demo_start
    # from a previous installation on the same server from immediately expiring the demo.
    chattr -i /opt/cyassure/.demo_start 2>/dev/null || true
    date -u +"%Y-%m-%d" > /opt/cyassure/.demo_start
    chattr +i /opt/cyassure/.demo_start 2>/dev/null || true
    chattr -i /opt/cyassure/.license_expired 2>/dev/null || true
    rm -f /opt/cyassure/.license_expired
    info "Demo clock reset to today ($(cat /opt/cyassure/.demo_start))"

    cat > /opt/cyassure/.env << ENVEOF
# CyAssure 360 — generated by setup wizard v7.1
# Version: ${BUNDLE_VERSION} | Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

BASE_DOMAIN=${BASE_DOMAIN}
CLIENT_NAME=${CLIENT_NAME}
SECRET_KEY=${FLASK_SECRET}
JWT_SECRET=${JWT_SECRET}
ADMIN_API_KEY=${ADMIN_API_KEY}
FRONTEND_URL=https://${BASE_DOMAIN}
BASE_URL=https://${BASE_DOMAIN}
OAUTH_PROVIDER=${OAUTH_PROVIDER}
ENVEOF

    # Always write all OAuth credentials so admins can switch provider by
    # editing a single OAUTH_PROVIDER line in /opt/cyassure/.env
    cat >> /opt/cyassure/.env << ENVEOF
# OAuth — Google SSO
GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}

# OAuth — Microsoft Azure AD
MICROSOFT_CLIENT_ID=${MICROSOFT_CLIENT_ID}
MICROSOFT_CLIENT_SECRET=${MICROSOFT_CLIENT_SECRET}
ENVEOF

    cat >> /opt/cyassure/.env << ENVEOF

CYSOAR_OIDC_SECRET=${CYSOAR_OIDC_SECRET}
CYSIEM_OIDC_SECRET=${CYSIEM_OIDC_SECRET}
CY360SSO_OIDC_SECRET=${CY360SSO_OIDC_SECRET}

# ── IAP oauth2-proxy ────────────────────────────────────────────────────────────
# oauth2-proxy uses OIDC against this same DOMAIN (single-origin — see
# portal/nginx.conf). It is the SSO gate in front of the whole app.
OAUTH2PROXY_SECRET=${OAUTH2PROXY_SECRET}
OAUTH2PROXY_COOKIE_SECRET=${OAUTH2PROXY_COOKIE_SECRET}

CYASSURE_PORTAL_URL=https://${BASE_DOMAIN}
NODE_RED_CREDENTIAL_SECRET=${NODERED_SECRET}

SMTP_HOST=${SMTP_HOST:-}
SMTP_PORT=${SMTP_PORT:-}
SMTP_USER=${SMTP_USER:-}
SMTP_PASS=${SMTP_PASS:-}
SUPPORT_EMAIL=${SUPPORT_EMAIL:-support@cyassure.eu}

SIEM_ENGINE_URL=http://127.0.0.1:8100

# ── CyAssure 360 user DB — Flask RBAC backed by PostgreSQL ─────────────────────
# Reuses the existing correlation DB (port 5433) — no new database required.
# cyassure_app, not corruser — roadmap item #34 Phase 2: corruser is a
# Postgres superuser by default, which bypasses RLS. See
# backend/core/db_least_privilege.py and docker-compose.yml's backend
# service comment for the full fix.
CYASSURE_DB_URL=postgresql://cyassure_app:${CORR_DB_PASS}@127.0.0.1:5433/correlation

# GitHub token — used by the portal backend to download updates/upgrades without
# requiring the customer to enter it in the UI.  Set via GH_TOKEN env var at install time.
GH_TOKEN=${GH_TOKEN:-}

# ── Cloud CyMISP (Cyassure-managed MISP at cymisp.cyassure.eu) ────────────────
# When a customer selects "Cloud CyMISP" in System Settings > Integrations, the
# backend uses these credentials automatically.  CLOUD_MISP_API_KEY must be set
# to the vendor-issued API key for this installation.
CLOUD_MISP_URL=${CLOUD_MISP_URL:-https://cymisp.cyassure.eu}
CLOUD_MISP_API_KEY=${CLOUD_MISP_API_KEY:-BPxY79PEX9Y39eooVpNVu0UpayhYaqCfe74ZOHJb}


# ── CyMind (central AI hub — company-wide instance) ───────────────────────────
# Populated at startup from vault (CYMIND-API-URL / CYMIND-API-KEY).
# Leave empty to use vault injection; set non-empty to override vault.
CYMIND_API_URL=${CYMIND_API_URL:-}
CYMIND_API_KEY=${CYMIND_API_KEY:-}

# ── Secrets backend selection ─────────────────────────────────────────────────
# Choose ONE backend to use for secret injection at startup:
#   azure      → Azure Key Vault via DefaultAzureCredential
#   hashicorp  → HashiCorp Vault via Token or AppRole auth
#   infisical  → Infisical via Universal Auth (client ID + secret)
# Leave blank to rely solely on values in this .env file.
SECRETS_BACKEND=${SECRETS_BACKEND:-azure}

# ── Azure Key Vault — set to your vault URL to enable secret bootstrap ─────────
# The app fetches secrets from Key Vault at startup when this is set.
# Auth (tried in order by DefaultAzureCredential):
#   1. AZURE_CLIENT_ID + AZURE_CLIENT_SECRET + AZURE_TENANT_ID  ← Service Principal
#   2. `az login` CLI session  ← local dev
AZURE_KEYVAULT_URL=${AZURE_KEYVAULT_URL:-}
ENVEOF
    echo "MAXMIND_KEY=${MAXMIND_KEY:-}" >> /opt/cyassure/.env

    # ── ASM Scanner tuning (optional — defaults are safe for most deployments) ──
    cat >> /opt/cyassure/.env << ASMEOF

# ── ASM Scanner tuning ────────────────────────────────────────────────────────
# These vars tune the cy-asm engine. Defaults are safe for standard installs.
# ENABLE_EXTENDED_PORT_SCAN: scan all 65535 ports (slower, more thorough)
ENABLE_EXTENDED_PORT_SCAN=${ENABLE_EXTENDED_PORT_SCAN:-false}
# ENABLE_UDP_SCAN: add UDP scan layer (requires root; significantly slower)
ENABLE_UDP_SCAN=${ENABLE_UDP_SCAN:-false}
# PROTO_PROBE_TIMEOUT: seconds per protocol-specific handshake probe (SSH/RDP/SMB/etc.)
PROTO_PROBE_TIMEOUT=${PROTO_PROBE_TIMEOUT:-5}
# INFRA_EXPOSURE_PORTS: extra ports checked for infrastructure exposure in Deep scans
# Default covers Docker, Kubernetes, Elasticsearch, Memcached, VNC, Prometheus, ActiveMQ
INFRA_EXPOSURE_PORTS=${INFRA_EXPOSURE_PORTS:-2375,2376,6443,9200,9300,11211,5900,9090,9091,8161}
ASMEOF
    chmod 600 /opt/cyassure/.env
   # mkdir -p /root/cy-asm && cp /opt/cyassure/.env /root/cy-asm/.env
   # success "Main .env written → /opt/cyassure/.env"

    # LLM enrichment is on by default; operators can set LLM_ENABLED=false in
    # /opt/cyassure/cysiemstack.env to disable automated background enrichment.
    # Manual on-demand analysis (analyst-triggered from the portal) is never blocked.
    _LLM_FLAG="true"

    cat > /opt/cyassure/cysiemstack.env << SIEMEOF
# CySIEMStack environment — auto-generated by setup.sh — DO NOT EDIT MANUALLY
# Engine-specific settings only.  Shared config (vault credentials, API keys,
# CLOUD_MISP_*, CYMIND_*, BASE_DOMAIN, etc.) comes from /opt/cyassure/.env,
# which the cysiemstack-engine.service loads first.  Only update .env.

# cyassure_app, not corruser — roadmap item #34 Phase 2: corruser is a
# Postgres superuser by default, which bypasses RLS. See
# backend/core/db_least_privilege.py and docker-compose.yml's
# cysiemstack-engine service comment for the full fix.
DATABASE_URL=postgresql+asyncpg://cyassure_app:${CORR_DB_PASS}@127.0.0.1:5433/correlation
# Standalone key so --update mode can read the DB password without parsing DATABASE_URL
POSTGRES_PASSWORD=${CORR_DB_PASS}

REDIS_URL=redis://127.0.0.1:6379/0
REDIS_ALERT_KEY=cysiemstack:alerts:raw

# LLM enrichment — set to false to disable automated background enrichment.
# Manual on-demand analysis (analyst-triggered from the portal) is never blocked.
LLM_ENABLED=${_LLM_FLAG}

CORRELATION_WINDOW_MINUTES=15
INCIDENT_MAX_AGE_MINUTES=30
UEBA_BASELINE_DAYS=30
RISK_DECAY_HOURS=24
INCIDENT_ID_PREFIX=INC
LOG_LEVEL=INFO
UEBA_ML_SHADOW_MODE=true
UEBA_ML_MIN_TRAIN_DAYS=7
UEBA_ML_MODEL_DIR=/opt/cyassure/ml_models
SIEMEOF
    chmod 600 /opt/cyassure/cysiemstack.env
    success "cysiemstack.env written → /opt/cyassure/cysiemstack.env"

    # Auto-detect and persist the server's public IP as CY360_PUBLIC_IP, for any
    # future agent-installer path that needs to bypass the Cloudflare-proxied
    # hostname and connect directly to the server IP (e.g. a raw-TCP enrollment
    # port that Cloudflare wouldn't proxy). Nothing in the codebase reads this
    # var today — CyEDR/CyCollector enrollment is plain HTTPS through nginx, so
    # it doesn't need it — kept as a harmless no-op until something does.
    _PUBLIC_IP=$(curl -fsSL --max-time 5 https://ifconfig.me 2>/dev/null || \
                 curl -fsSL --max-time 5 https://api.ipify.org 2>/dev/null || true)
    if [[ -n "$_PUBLIC_IP" ]]; then
        if grep -q '^CY360_PUBLIC_IP=' /opt/cyassure/.env 2>/dev/null; then
            sed -i "s|^CY360_PUBLIC_IP=.*|CY360_PUBLIC_IP=${_PUBLIC_IP}|" /opt/cyassure/.env
        else
            echo "CY360_PUBLIC_IP=${_PUBLIC_IP}" >> /opt/cyassure/.env
        fi
        success "Server public IP detected: ${_PUBLIC_IP} → CY360_PUBLIC_IP in .env"
    else
        warn "Could not detect public IP — agent installer will fall back to cysiem.${BASE_DOMAIN}"
        warn "Set CY360_PUBLIC_IP=<your-server-ip> in /opt/cyassure/.env to fix agent registration"
    fi

    # Create ML model persistence directory
    mkdir -p /opt/cyassure/ml_models
    chmod 755 /opt/cyassure/ml_models
    success "ML model directory created → /opt/cyassure/ml_models"

fi  # end full env block

# ── Step 4.3b: IAP Gateway (oauth2-proxy) ─────────────────────────────────────
# Runs in all modes (full / update). Idempotent.
# Single OIDC gate in front of the whole app, on the SAME origin as everything
# else (portal/nginx.conf serves /, /api/, /auth/, /oidc/, /mcp/ all under one
# hostname in the Docker architecture — there is no separate cy360./cyasm.
# vhost per module the way the old bare-metal multi-subdomain layout had).

step_header "IAP GATEWAY (oauth2-proxy)"

# Load vars from .env if not already in memory (update mode)
[[ -z "${BASE_DOMAIN:-}" ]] && \
    BASE_DOMAIN=$(grep "^BASE_DOMAIN=" /opt/cyassure/.env 2>/dev/null | cut -d= -f2- || true)
BASE_DOMAIN="${BASE_DOMAIN:-cyassure.eu}"

# ── Sync BASE_DOMAIN into the app's own .env ──────────────────────────────────
# Everything above only ever fed /opt/cyassure/.env (legacy) and cy-proxy's own
# env vars — it never touched the actual Docker Compose project .env that
# core/config.py reads for cookies/OIDC/MCP URLs and everything the portal
# itself shows (e.g. Scan Operations' target-domain prefill, Settings >
# Organization Domain). That gap meant running this script with
# CYASSURE_SETUP_DOMAIN=yourdomain.com correctly configured cy-proxy but left
# the app itself showing whatever BASE_DOMAIN the project .env already had
# (install.sh's placeholder default on a fresh install) — confirmed live on a
# real server 2026-07-30: cy-proxy correctly used the configured domain while
# the portal kept showing the placeholder, because the backend container was
# never told the domain had changed. Runs unconditionally here, independent of
# whether IAP Gateway itself is even being configured (the oauth2-proxy secret
# gate is below this), since every customer who sets a real domain needs the
# app synced regardless of IAP Gateway. Deliberately only touches BASE_DOMAIN,
# never EXPOSURE_TARGET_DOMAIN — the latter is a separate, more specialized
# knob (see core/config.py's docstring) that this script has never configured
# and shouldn't start guessing at; leaving it alone means it keeps correctly
# inheriting the new BASE_DOMAIN whenever it's unset (the common case).
step_header "SYNC DOMAIN TO APP CONFIG"
if [[ -f ./.env ]]; then
    _app_env_domain=$(grep "^BASE_DOMAIN=" ./.env 2>/dev/null | cut -d= -f2- || true)
    if [[ "$_app_env_domain" != "$BASE_DOMAIN" ]]; then
        if grep -q "^BASE_DOMAIN=" ./.env 2>/dev/null; then
            sed -i "s|^BASE_DOMAIN=.*|BASE_DOMAIN=${BASE_DOMAIN}|" ./.env
        elif grep -q "^# *BASE_DOMAIN=" ./.env 2>/dev/null; then
            sed -i "s|^# *BASE_DOMAIN=.*|BASE_DOMAIN=${BASE_DOMAIN}|" ./.env
        else
            echo "BASE_DOMAIN=${BASE_DOMAIN}" >> ./.env
        fi
        success "Synced BASE_DOMAIN=${BASE_DOMAIN} into ./.env (app config)"
        if command -v docker &>/dev/null && docker compose ps backend &>/dev/null; then
            info "Recreating the backend container to pick up the new domain..."
            docker compose up -d --no-deps --force-recreate backend 2>/dev/null \
                && success "backend restarted with the new domain" \
                || warn "Could not restart backend automatically — run this from the app's install directory: docker compose up -d --force-recreate backend"
        else
            warn "backend container not found from this directory — if the app is running elsewhere, cd there and run: docker compose up -d --force-recreate backend (otherwise the portal will keep showing the old domain until it's restarted)"
        fi
    else
        info "./.env already has BASE_DOMAIN=${BASE_DOMAIN} — no change needed"
    fi
else
    warn "./.env not found (this script wasn't run from the app's install directory) — BASE_DOMAIN was NOT synced to the app config. cd into your install directory and re-run, or manually set BASE_DOMAIN=${BASE_DOMAIN} in .env and run: docker compose up -d --force-recreate backend"
fi

[[ -z "${OAUTH2PROXY_SECRET:-}" ]] && \
    OAUTH2PROXY_SECRET=$(grep "^OAUTH2PROXY_SECRET=" /opt/cyassure/.env 2>/dev/null | cut -d= -f2- || true)
[[ -z "${OAUTH2PROXY_COOKIE_SECRET:-}" ]] && \
    OAUTH2PROXY_COOKIE_SECRET=$(grep "^OAUTH2PROXY_COOKIE_SECRET=" /opt/cyassure/.env 2>/dev/null | cut -d= -f2- || true)
[[ -z "${CYSIEM_OIDC_SECRET:-}" ]] && \
    CYSIEM_OIDC_SECRET=$(grep "^CYSIEM_OIDC_SECRET=" /opt/cyassure/.env 2>/dev/null | cut -d= -f2- || true)

# ── Sync OAUTH2PROXY_SECRET/COOKIE_SECRET into the app's own .env ────────────
# Same landmine as BASE_DOMAIN above, found live 2026-08-24: these are
# generated into /opt/cyassure/.env (legacy store, what cy-proxy's own
# `docker run` reads to start) but NEVER synced into ./.env — the actual
# docker-compose project .env core/config.py reads OAUTH2PROXY_SECRET from
# to build OIDC_CLIENTS["oauth2proxy"]["client_secret"]. Without this, the
# backend always has an EMPTY client_secret for oauth2-proxy, so oauth2-
# proxy's own token exchange fails with invalid_client on every install —
# regardless of how correctly everything else (vhost, nginx routing,
# oauth2-proxy's own container) is wired. Only matters once IAP Gateway
# secrets actually exist, same gate as everything else here.
if [[ -n "$OAUTH2PROXY_SECRET" && -n "$OAUTH2PROXY_COOKIE_SECRET" && -f ./.env ]]; then
    _oauth2_env_changed=false
    for _kv in "OAUTH2PROXY_SECRET=${OAUTH2PROXY_SECRET}" "OAUTH2PROXY_COOKIE_SECRET=${OAUTH2PROXY_COOKIE_SECRET}"; do
        _k="${_kv%%=*}"
        if grep -q "^${_k}=" ./.env 2>/dev/null; then
            if [[ "$(grep "^${_k}=" ./.env | cut -d= -f2-)" != "${_kv#*=}" ]]; then
                sed -i "s|^${_k}=.*|${_kv}|" ./.env
                _oauth2_env_changed=true
            fi
        else
            echo "$_kv" >> ./.env
            _oauth2_env_changed=true
        fi
    done
    if [[ "$_oauth2_env_changed" == "true" ]]; then
        success "Synced OAUTH2PROXY_SECRET/OAUTH2PROXY_COOKIE_SECRET into ./.env (app config)"
        if command -v docker &>/dev/null && docker compose ps backend &>/dev/null; then
            info "Recreating the backend container to pick up the IAP Gateway secrets..."
            docker compose up -d --no-deps --force-recreate backend 2>/dev/null \
                && success "backend restarted with IAP Gateway secrets" \
                || warn "Could not restart backend automatically — run: docker compose up -d --force-recreate backend"
        else
            warn "backend container not found from this directory — oauth2-proxy's token exchange will keep failing with invalid_client until: docker compose up -d --force-recreate backend"
        fi
    fi
fi
# APP_PORT: the host port the Docker frontend container actually publishes
# (docker-compose.yml: "${APP_PORT:-8080}:80"). oauth2-proxy's upstream must
# point HERE, not at the backend's internal port 5252 — that port is never
# published to the host at all in the Docker architecture (only reachable
# from other containers over the compose network), so anything pointed at
# 127.0.0.1:5252 on the host would never connect. This comes from the
# project's docker-compose .env, NOT /opt/cyassure/.env.
[[ -z "${APP_PORT:-}" ]] && \
    APP_PORT=$(grep "^APP_PORT=" ./.env 2>/dev/null | cut -d= -f2- || true)
APP_PORT="${APP_PORT:-8080}"

# ── Informational DNS check (advisory only — never blocks startup) ───────────
# Not needed anymore for cy-proxy to START (see --skip-oidc-discovery below),
# but real users still browse to https://${BASE_DOMAIN}/... to actually log
# in, and that step DOES need working DNS. Non-blocking heads-up only —
# deployments legitimately sitting behind Cloudflare/another CDN (see the
# CY360_PUBLIC_IP comment above) will often show a mismatch here on a
# perfectly working setup, so this is informational, not a correctness check.
_resolved_ip=$(getent hosts "$BASE_DOMAIN" 2>/dev/null | awk '{print $1}' | head -1)
if [[ -z "$_resolved_ip" ]]; then
    warn "${BASE_DOMAIN} does not resolve from this server yet — fine for setup, but login via https://${BASE_DOMAIN} won't work until its DNS A record is live."
fi

# ── DNS-independent OIDC wiring ───────────────────────────────────────────────
# oauth2-proxy normally fetches https://${BASE_DOMAIN}/oidc/.well-known/
# openid-configuration at every startup to discover its endpoints — a public
# HTTP round-trip through DNS for what is, on this exact host, a same-machine
# connection (cy-proxy runs --network host, right alongside the app). If
# BASE_DOMAIN's DNS isn't live yet (fresh install, propagation delay, or a
# registrar page like the one that caused a real incident on 2026-07-30 — see
# the "SYNC DOMAIN TO APP CONFIG" step's comment above), that discovery fetch
# hits whatever else is actually at that domain, fails to parse as JSON, and
# oauth2-proxy crash-loops forever with an unreadable HTML dump in its logs.
# Fixed by skipping discovery and wiring every server-to-server OIDC call
# directly over loopback (127.0.0.1:${APP_PORT}, same reachable-without-DNS
# path OAUTH2_PROXY_UPSTREAMS below already uses) instead — only the LOGIN
# URL stays on the public domain, because that's a browser redirect the
# user's own machine has to reach, which is unavoidably DNS-dependent (and
# not a container-startup concern — it only affects the login click, not
# whether cy-proxy comes up). OAUTH2_PROXY_OIDC_ISSUER_URL is still required
# even with discovery skipped: it's the string oauth2-proxy checks every ID
# token's "iss" claim against, not a URL it fetches.
# Verified live 2026-07-30: reproduced the crash against an unresolvable
# domain (confirms the failure mode), then confirmed this exact config starts
# cleanly against the same unresolvable domain (confirms the fix) — see
# socpilot Change Log for the full before/after test.

# ── oauth2-proxy container (gated on its own secrets) ────────────────────────
if [[ -z "$OAUTH2PROXY_SECRET" || -z "$OAUTH2PROXY_COOKIE_SECRET" ]]; then
    warn "oauth2-proxy secrets missing in .env — oauth2-proxy container skipped; re-run --update"
else
    # ── Pull and start oauth2-proxy container ───────────────────────────────────
    # Runs on 127.0.0.1:4180. nginx uses it as an internal auth_request backend.
    # Cookie domain .BASE_DOMAIN means ONE login covers all subdomains.
    _OAUTH2_PROXY_IMAGE="quay.io/oauth2-proxy/oauth2-proxy:latest"

    if docker ps -q --filter "name=cy-proxy" 2>/dev/null | grep -q .; then
        info "cy-proxy container already running — checking config..."
        # Compare cookie domain to detect domain change; recreate if needed
        _running_domain=$(docker inspect cy-proxy 2>/dev/null \
            | python3 -c "import sys,json; e=json.load(sys.stdin)[0]['Config']['Env']; \
              print(next((x.split('=',1)[1] for x in e if x.startswith('OAUTH2_PROXY_COOKIE_DOMAINS=')),'')" 2>/dev/null || true)
        if [[ "$_running_domain" == ".${BASE_DOMAIN}" ]]; then
            info "cy-proxy already configured for .${BASE_DOMAIN} — no restart needed"
        else
            info "cy-proxy domain changed — recreating container"
            docker rm -f cy-proxy 2>/dev/null || true
        fi
    fi

    if ! docker ps -q --filter "name=cy-proxy" 2>/dev/null | grep -q .; then
        docker pull "$_OAUTH2_PROXY_IMAGE" 2>/dev/null || \
            warn "oauth2-proxy pull failed — using cached image if available"

        docker run -d \
            --name cy-proxy \
            --restart unless-stopped \
            --network host \
            -e OAUTH2_PROXY_PROVIDER=oidc \
            -e OAUTH2_PROXY_OIDC_ISSUER_URL="https://${BASE_DOMAIN}/oidc" \
            -e OAUTH2_PROXY_SKIP_OIDC_DISCOVERY=true \
            -e OAUTH2_PROXY_LOGIN_URL="https://${BASE_DOMAIN}/oidc/authorize" \
            -e OAUTH2_PROXY_REDEEM_URL="http://127.0.0.1:${APP_PORT}/oidc/token" \
            -e OAUTH2_PROXY_OIDC_JWKS_URL="http://127.0.0.1:${APP_PORT}/oidc/jwks" \
            -e OAUTH2_PROXY_PROFILE_URL="http://127.0.0.1:${APP_PORT}/oidc/userinfo" \
            -e OAUTH2_PROXY_CLIENT_ID=oauth2proxy \
            -e OAUTH2_PROXY_CLIENT_SECRET="${OAUTH2PROXY_SECRET}" \
            -e OAUTH2_PROXY_REDIRECT_URL="https://${BASE_DOMAIN}/oauth2/callback" \
            -e OAUTH2_PROXY_HTTP_ADDRESS="127.0.0.1:4180" \
            -e OAUTH2_PROXY_COOKIE_SECRET="${OAUTH2PROXY_COOKIE_SECRET}" \
            -e OAUTH2_PROXY_COOKIE_DOMAINS=".${BASE_DOMAIN}" \
            -e OAUTH2_PROXY_WHITELIST_DOMAINS=".${BASE_DOMAIN}" \
            -e OAUTH2_PROXY_EMAIL_DOMAINS="*" \
            -e OAUTH2_PROXY_SCOPE="openid email profile" \
            -e OAUTH2_PROXY_SET_XAUTHREQUEST=true \
            -e OAUTH2_PROXY_PASS_ACCESS_TOKEN=false \
            -e OAUTH2_PROXY_PASS_AUTHORIZATION_HEADER=false \
            -e OAUTH2_PROXY_SKIP_PROVIDER_BUTTON=true \
            -e OAUTH2_PROXY_SKIP_JWT_BEARER_TOKENS=false \
            -e OAUTH2_PROXY_SSL_INSECURE_SKIP_VERIFY=true \
            -e OAUTH2_PROXY_COOKIE_SECURE=true \
            -e OAUTH2_PROXY_COOKIE_SAMESITE=lax \
            -e OAUTH2_PROXY_SESSION_STORE_TYPE=cookie \
            -e OAUTH2_PROXY_UPSTREAMS="http://127.0.0.1:${APP_PORT}" \
            "$_OAUTH2_PROXY_IMAGE" \
        && success "cy-proxy (oauth2-proxy) started on 127.0.0.1:4180" \
        || { warn "oauth2-proxy container failed to start — check: docker logs cy-proxy"; \
             ERRORS+=("oauth2-proxy failed to start"); }
    fi
fi  # end oauth2proxy gate

# ── Step 4.3c-pre: HOST VHOST + TLS PROVISIONING ──────────────────────────────
# Restores what the old bare-metal installer's Steps 15-16 did for cy360/cyasm
# (removed wholesale in the Docker pivot — see the former "KNOWN GAP" note that
# used to sit near the bottom of this file) adapted to the Docker architecture:
# the frontend container's own nginx (portal/nginx.conf) already does all
# same-origin /api /auth /oidc /mcp routing, so this step only ever needs to
# write ONE simple TLS-terminating reverse-proxy vhost, not the old per-module
# multi-vhost layout. Without this, a genuinely fresh install never gets a host
# nginx vhost for BASE_DOMAIN at all — oauth2-proxy and the app itself are only
# ever reachable on 127.0.0.1, never from the public domain. Confirmed live on
# a fresh install, 2026-08-23.
#
# Runs in every mode (full/update/infra), same as Step 4.3c below — but is
# internally idempotent: it only ever WRITES a vhost when none already exists
# for BASE_DOMAIN (reusing the exact detection loop Step 4.3c uses), so re-runs
# and module installs that later edit this same file are never clobbered. A
# full no-op when TLS_MODE=none — that's the "something else terminates TLS"
# case (Cloudflare Tunnel, another LB) documented in .env.example.
_UPSTREAM_PORT="${APP_PORT}"
[[ -n "$OAUTH2PROXY_SECRET" && -n "$OAUTH2PROXY_COOKIE_SECRET" ]] && _UPSTREAM_PORT="4180"

# Safety net: the "TLS / HOST VHOST" prompt above only runs on a genuinely
# fresh install (_FRESH_INSTALL gate). On --update/--infra runs against an
# existing server, TLS_MODE is otherwise still empty here unless explicitly
# passed this run — default it to http01 rather than leaving it unset.
TLS_MODE="${TLS_MODE:-http01}"

# dns01's API token is written to ./.env by the Setup Wizard (never shown in
# its generated command) rather than passed as a shell env var — same
# fallback pattern OAUTH2PROXY_SECRET etc. already use above.
[[ -z "${CYASSURE_SETUP_DNS_API_TOKEN:-}" && -f ./.env ]] && \
    CYASSURE_SETUP_DNS_API_TOKEN=$(grep "^CYASSURE_SETUP_DNS_API_TOKEN=" ./.env 2>/dev/null | cut -d= -f2- || true)

if [[ "$TLS_MODE" == "none" ]]; then
    :  # customer-managed edge — Step 4.3c's own info line covers this case
elif [[ -z "$BASE_DOMAIN" || "$BASE_DOMAIN" == "cyassure.eu" ]]; then
    info "BASE_DOMAIN not configured to a real domain yet — skipping host vhost/TLS provisioning (re-run once it's set)"
else
    step_header "HOST VHOST + TLS (mode: ${TLS_MODE})"

    _vhost_exists=""
    for _f in /etc/nginx/sites-enabled/*; do
        [[ -f "$_f" ]] || continue
        if grep -qE "server_name[[:space:]]+([^;]*[[:space:]])?${BASE_DOMAIN}([[:space:]]|;)" "$_f" 2>/dev/null; then
            _vhost_exists="$_f"
            break
        fi
    done

    if [[ -n "$_vhost_exists" ]]; then
        info "${_vhost_exists}: vhost for ${BASE_DOMAIN} already exists — leaving TLS/vhost provisioning untouched (Step 4.3c below keeps its proxy_pass wired to oauth2-proxy)"
    else
        _APP_VHOST="/etc/nginx/sites-available/cyassure-modules"
        _CERT_DIR="/etc/ssl/cyassure"
        mkdir -p "$_CERT_DIR" /var/www/html

        # $1=fullchain path  $2=privkey path  $3="real"|"selfsigned"
        _write_app_vhost() {
            local _fullchain="$1" _privkey="$2" _kind="$3"
            local _hsts='add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;'
            # HSTS + a self-signed cert is a permanent browser lockout once cached
            # (no bypass) — force max-age=0 until a real cert replaces it.
            [[ "$_kind" == "selfsigned" ]] && _hsts='add_header Strict-Transport-Security "max-age=0" always;'
            cat > "$_APP_VHOST" << VHOSTEOF
# CyAssure 360 host vhost — generated by cyassure-setup.sh — ${BASE_DOMAIN}
# TLS-terminating reverse proxy. Only /api/ (minus /api/sso/, see below) goes
# THROUGH oauth2-proxy (proxy_pass to it) when IAP Gateway is on — that's the
# actual protected surface (real app data). /oauth2/ goes TO oauth2-proxy
# itself (its own sign_in/callback/sign_out paths — a different thing from
# being gated BY it). Everything else, including the SPA shell at /, always
# bypasses straight to the app:
#   - /oauth2/: oauth2-proxy's own paths. Must reach oauth2-proxy on 4180
#     directly, never the app — /oauth2/callback in particular is where it
#     redeems the OIDC code and sets its own session cookie. Missing this
#     was a bug found mid-fix: once / stopped proxying to oauth2-proxy
#     (see the /api/ split below), /oauth2/callback silently fell through
#     to the app's SPA shell instead, so the whole OIDC round trip looked
#     like it worked (redirects all succeeded) but no session cookie was
#     ever actually set.
#   - /oidc/: CyAssure is its own OIDC Identity Provider here, and
#     oauth2-proxy's own login flow browser-redirects to /oidc/authorize
#     (OAUTH2_PROXY_LOGIN_URL) to authenticate. Routing that through
#     oauth2-proxy's own gate makes it try to authenticate against itself —
#     every request gets treated as unauthenticated and redirected back to
#     /oidc/authorize again (nesting the previous redirect into a growing
#     "state" param each hop) until the URL exceeds a header/URL size limit
#     and nginx 502s.
#   - /auth/ and /api/sso/: Google/Microsoft/local/SAML login — the ONLY way
#     to ever establish the native Cy360 session /oidc/authorize requires
#     before oauth2-proxy's own OIDC round trip can succeed. Gating these
#     too creates a deadlock: oauth2-proxy bounces to /oidc/authorize, which
#     bounces to / for the login form, which oauth2-proxy also gates —
#     the browser can never reach a login form at all. Gating the static
#     SPA shell itself was never real protection anyway; the actual
#     sensitive surface (/api/* minus /api/sso/) stays behind oauth2-proxy.
#   - /mcp/: authenticates via its own Bearer cymk_... key (M2M callers —
#     the correlation engine, CyMind Cloud), not a browser session. Same
#     structural problem as /oidc/ — a non-browser client can't complete
#     oauth2-proxy's browser-redirect login flow.
#   - /api/edr/installer/{unix,win,uninstall-unix,uninstall-win,agent-bundle,
#     tray-bundle,sysmon-config,sysmon-exe,yara-rules,yara-exe,
#     agent-icon-macos}:
#     the CyEDR install/uninstall one-liners admins curl|bash on a target
#     host — no browser session exists there either. Listed by exact path
#     (not the whole /api/edr/installer/ prefix) so the admin/agent-token
#     -protected siblings under that prefix stay behind oauth2-proxy. Found
#     2026-08-24: uninstall-unix was 404/HTML-redirect-looping through
#     oauth2-proxy's sign-in page on cy360.cyassure.eu because this bypass
#     didn't exist yet. agent-icon-macos added 2026-09-07 (deploy-token
#     -gated like the others here, just no browser session to complete
#     oauth2-proxy's login redirect with) — cyedr-install.sh downloads it to
#     brand the macOS agent's .app bundle for Full Disk Access prompts.
#   - /api/ai-security/browser-ext/{package.crx,package/update.xml}: same
#     failure mode, different caller — Chrome's own extension auto-updater,
#     not curl. It cannot attach a session cookie either (Omaha-protocol
#     GET, a platform constraint), so without this bypass the self-hosted
#     browser extension would silently fail to install/update fleet-wide.
#   - / (everything not more specifically matched above, i.e. the SPA shell
#     + static assets): always straight to the app too, for the same reason
#     as /auth/ — the login page itself lives here. A separate, more
#     specific location /api/ block below is where oauth2-proxy actually
#     gates something real.
# Confirmed live 2026-08-23/24: cy360.cyassure.eu's login was completely
# broken without all of these — /oidc/ alone stopped the 502 but left native
# login itself unreachable (a stable, non-crashing redirect loop), and
# gating / (instead of /api/) made that unreachable regardless.
map \$http_upgrade \$connection_upgrade {
    default upgrade;
    ''      close;
}
server {
    listen 80; listen [::]:80;
    server_name ${BASE_DOMAIN};
    location /.well-known/acme-challenge/ { root /var/www/html; }
    location / { return 301 https://\$host\$request_uri; }
}
server {
    listen 443 ssl; listen [::]:443 ssl;
    server_name ${BASE_DOMAIN};
    ssl_certificate     ${_fullchain};
    ssl_certificate_key ${_privkey};
    ssl_protocols TLSv1.2 TLSv1.3;
    ${_hsts}
    add_header X-Content-Type-Options "nosniff" always;
    # oauth2-proxy's own paths (sign_in, callback, sign_out, the internal
    # /oauth2/auth check) — these must reach oauth2-proxy ITSELF, port 4180,
    # never the app. Missed on the first pass of this fix: once / stopped
    # bypassing straight to oauth2-proxy (see the /api/ split below),
    # /oauth2/callback fell through to location / and hit the app's SPA
    # shell instead of actually being processed — no _oauth2_proxy cookie
    # ever got set, so the OIDC round trip silently never completed even
    # though every earlier step looked like it worked. Confirmed live
    # 2026-08-24 mid-fix, before this location existed.
    location /oauth2/ {
        proxy_pass         http://127.0.0.1:4180;
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    location /oidc/ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    location /auth/ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    location /api/sso/ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    # CyEDR installer/uninstaller script + asset endpoints: these are the
    # curl-able, deliberately no-auth routes (blueprints/edr/routes.py, see
    # each handler's own "no auth — public endpoint" docstring) that admins
    # run as a one-liner on a target host to install/uninstall the agent —
    # there's no browser session for oauth2-proxy to check. Listed by exact
    # path rather than bypassing the whole /api/edr/installer/ prefix so
    # the admin/session-protected siblings under that same prefix (token,
    # commands, uninstall-commands) stay behind oauth2-proxy.
    location ~ ^/api/edr/installer/(unix|win|uninstall-unix|uninstall-win|agent-bundle|tray-bundle|sysmon-config|sysmon-exe|yara-rules|yara-exe|agent-icon-macos)$ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    # Every endpoint an ENROLLED agent (or a not-yet-enrolled one, for
    # self-enroll) calls on its own — heartbeat, telemetry, FIM/SCA/tamper
    # reporting, response-command polling, self-enroll, self-update binary
    # download — all @require_agent_token Bearer-auth or deploy-token auth
    # at the Flask layer, none of them ever has a browser session. This
    # marker string (grep for CYEDR-AGENT-BYPASS) lets updater/server.py's
    # matching _wire_iap_gateway_vhost() idempotently inject this same block
    # into a vhost that predates it. Found live 2026-08-25: every one of
    # these was silently 302-redirecting into the OIDC login flow instead of
    # reaching Flask on any instance with IAP Gateway on — including
    # installer/agent-binary and installer/custom-yara, which an earlier
    # version of the comment above claimed should stay gated "as defense in
    # depth" on top of their own Bearer check; wrong, since a headless agent
    # can never complete an interactive OIDC login, so gating a route it
    # calls autonomously doesn't add defense, it makes the route
    # categorically unreachable. Meant enrollment AND telemetry from every
    # already-enrolled agent were both broken, not just new installs. Listed
    # by exact path/pattern (not the whole /api/edr/ prefix) so the
    # session-protected admin surface under that same prefix (agent list,
    # deployment tokens, agent enroll via admin session, policies, installer
    # token/commands) stays behind oauth2-proxy.
    # Also covers agents/<id>/self-test/detections — the internal
    # detection-efficacy CLI tool (devtools/edr-detection-test, a separate
    # repo, never shipped) authenticates as the agent itself the same way
    # real agents do, so it hits this exact same "no browser session"
    # problem. The route itself still 404s everywhere unless a lab has
    # explicitly set EDR_SELFTEST_ENABLED=true (blueprints/edr/routes.py) —
    # bypassing IAP for it doesn't expose anything new, it just lets a
    # lab that HAS opted in actually reach Flask instead of oauth2-proxy
    # silently swallowing the request. Found live 2026-09-10 exactly the
    # same way the rest of this block was found: the endpoint returned an
    # HTML/redirect response instead of JSON with no obvious error.
    # CYEDR-AGENT-BYPASS
    location ~ ^/api/edr/(agents/self-enroll|agents/[^/]+/heartbeat|agents/[^/]+/self-test/detections|telemetry|logs|inventory|fim/events|fim/baseline|sca/results|tamper-events|response/[^/]+/pending|response/[^/]+/commands/[^/]+/complete|installer/agent-binary|installer/custom-yara)$ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    # Same class of bug, same fix: Chrome's own background extension updater
    # fetches these two directly (Omaha-protocol GET) and cannot attach a
    # session cookie or bearer token — a hard platform constraint, not a
    # design choice (see blueprints/ai_security/routes.py's comment above
    # these two handlers). Deliberately unauthenticated app-side already;
    # without this bypass every managed browser on the fleet would silently
    # fail to install/update the extension the same way the EDR curl
    # one-liners failed above.
    location ~ ^/api/ai-security/browser-ext/(package\.crx|package/update\.xml)$ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
    location /mcp/ {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   Authorization     \$http_authorization;
        proxy_set_header   Connection        "";
        proxy_buffering    off;
        proxy_cache        off;
        proxy_read_timeout 3600s;
        chunked_transfer_encoding on;
    }
    # /api/* (excluding /api/sso/ above, which already won the longest-
    # prefix match) is the actual protected surface — real app data, gated
    # by oauth2-proxy when IAP is on. The "# cyassure-iap-gate" marker lets
    # Step 4.3c below (WIRE oauth2-proxy INTO HOST VHOST) target only THIS
    # proxy_pass line when toggling IAP on/off on a later run — without it,
    # a plain grep/sed would also match (and wrongly rewrite) the /oidc/,
    # /auth/, /api/sso/, /mcp/ bypasses above, since they're proxy_pass
    # lines to the same APP_PORT too.
    location /api/ {
        proxy_pass         http://127.0.0.1:${_UPSTREAM_PORT}; # cyassure-iap-gate
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
        proxy_set_header   Upgrade           \$http_upgrade;
        proxy_set_header   Connection        \$connection_upgrade;
        proxy_read_timeout 3600s;
    }
    # Everything else: the static SPA shell + assets. Always straight to the
    # app, never oauth2-proxy — gating the shell itself was never real
    # protection (no data lives there), and gating it broke bootstrapping
    # entirely (the login page couldn't render — see the comment block atop
    # this vhost).
    location / {
        proxy_pass         http://127.0.0.1:${APP_PORT};
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
        proxy_set_header   Upgrade           \$http_upgrade;
        proxy_set_header   Connection        \$connection_upgrade;
        proxy_read_timeout 3600s;
    }
}
VHOSTEOF
        }

        # Skip re-issuing when a valid (>30 days) prod cert already exists;
        # detect a leftover staging cert by issuer and force-renew against prod
        # when PROD is now requested; on an LE rate-limit, reuse an existing
        # (possibly expired) cert rather than failing outright. Mirrors the old
        # bare-metal installer's helper of the same name almost verbatim.
        _certbot_if_needed() {
            local primary_domain="$1"; shift
            local log_file="$1"; shift
            local -a cb_args=("$@")
            local live_cert="/etc/letsencrypt/live/${primary_domain}/fullchain.pem"

            local existing_is_staging=false
            if [[ -f "$live_cert" ]] && \
               openssl x509 -noout -issuer -in "$live_cert" 2>/dev/null | grep -qi "fake\|staging"; then
                existing_is_staging=true
            fi

            if [[ -f "$live_cert" ]] && \
               [[ "$existing_is_staging" == "false" || "$CERTBOT_ENV" == "--staging" ]] && \
               openssl x509 -checkend 2592000 -noout -in "$live_cert" 2>/dev/null; then
                success "SSL cert for ${primary_domain} already valid — skipping certbot"
                return 0
            fi

            local -a env_flags=(--keep-until-expiring)
            if [[ "$existing_is_staging" == "true" && "$CERTBOT_ENV" != "--staging" ]]; then
                warn "Existing cert for ${primary_domain} is a Let's Encrypt STAGING cert — forcing renewal against production"
                env_flags=(--force-renewal)
            fi

            # `|| true` matters here: under set -euo pipefail (active for this
            # whole script), a bare failing command not part of &&/||/if would
            # trip the ERR trap and abort the ENTIRE install — defeating this
            # function's whole point of falling back gracefully on cert failure.
            local rc=0
            certbot certonly $CERTBOT_ENV --non-interactive --agree-tos -m "$CLIENT_EMAIL" \
                "${env_flags[@]}" "${cb_args[@]}" -d "$primary_domain" \
                >"$log_file" 2>&1 || rc=$?
            [[ $rc -eq 0 ]] && { rm -f "$log_file"; return 0; }

            if grep -q "too many certificates" "$log_file" 2>/dev/null; then
                warn "Certbot hit the Let's Encrypt rate limit (5 certs/7 days for this exact domain) — tip: use CYASSURE_SETUP_ENV=staging on test runs"
                [[ -f "$live_cert" ]] && { warn "Reusing existing (possibly expired) LE cert from a previous run"; rm -f "$log_file"; return 0; }
            else
                warn "Certbot failed for ${primary_domain} — details:"
                grep -E "Error|error|WARN|failed|challenge|refused|Timeout|rate.limit|DNS|problem|detail" \
                    "$log_file" 2>/dev/null | head -10 | sed 's/^/    /'
            fi
            rm -f "$log_file"
            return 1
        }

        if [[ "$TLS_MODE" == "byo" ]]; then
            if [[ -z "${CYASSURE_SETUP_CERT_PATH:-}" || -z "${CYASSURE_SETUP_KEY_PATH:-}" ]]; then
                warn "TLS mode 'byo' selected but CYASSURE_SETUP_CERT_PATH/CYASSURE_SETUP_KEY_PATH aren't set — falling back to a self-signed cert so the app stays reachable"
                TLS_MODE="selfsigned"
            elif ! openssl x509 -checkend 0 -noout -in "$CYASSURE_SETUP_CERT_PATH" 2>/dev/null; then
                warn "Certificate at ${CYASSURE_SETUP_CERT_PATH} is invalid or already expired — falling back to a self-signed cert"
                TLS_MODE="selfsigned"
            else
                cp "$CYASSURE_SETUP_CERT_PATH" "${_CERT_DIR}/fullchain.pem"
                cp "$CYASSURE_SETUP_KEY_PATH"  "${_CERT_DIR}/privkey.pem"
                chmod 600 "${_CERT_DIR}/privkey.pem"
                _write_app_vhost "${_CERT_DIR}/fullchain.pem" "${_CERT_DIR}/privkey.pem" "real"
                success "Host vhost written for ${BASE_DOMAIN} using the supplied certificate"
            fi
        fi

        if [[ "$TLS_MODE" == "http01" || "$TLS_MODE" == "dns01" ]]; then
            command -v certbot >/dev/null 2>&1 || apt-get install -y -qq certbot python3-certbot-nginx 2>/dev/null || true
            _CERT_OK=false
            _CB_LOG="/tmp/certbot-${BASE_DOMAIN}-$$.log"

            if [[ "$TLS_MODE" == "dns01" ]]; then
                dpkg -s python3-certbot-dns-cloudflare >/dev/null 2>&1 || apt-get install -y -qq python3-certbot-dns-cloudflare 2>/dev/null || true
                if [[ -z "${CYASSURE_SETUP_DNS_API_TOKEN:-}" ]]; then
                    warn "TLS mode 'dns01' selected but CYASSURE_SETUP_DNS_API_TOKEN isn't set — cannot request a certificate this way"
                else
                    mkdir -p /etc/letsencrypt
                    cat > /etc/letsencrypt/cloudflare.ini << CFINIEOF
dns_cloudflare_api_token = ${CYASSURE_SETUP_DNS_API_TOKEN}
CFINIEOF
                    chmod 600 /etc/letsencrypt/cloudflare.ini
                    _certbot_if_needed "$BASE_DOMAIN" "$_CB_LOG" \
                        --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini \
                        --dns-cloudflare-propagation-seconds 30 \
                        && _CERT_OK=true
                fi
            else
                # http01: needs a plain-HTTP stub reachable on :80 for the ACME challenge
                cat > "$_APP_VHOST" << STUBEOF
server {
    listen 80; listen [::]:80;
    server_name ${BASE_DOMAIN};
    location /.well-known/acme-challenge/ { root /var/www/html; }
    location / { return 200 "cyassure setup in progress"; add_header Content-Type text/plain; }
}
STUBEOF
                ln -sf "$_APP_VHOST" "/etc/nginx/sites-enabled/cyassure-modules" 2>/dev/null || true
                rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
                if nginx -t 2>/dev/null; then
                    systemctl reload nginx 2>/dev/null || systemctl start nginx 2>/dev/null || true
                    sleep 3
                    curl -s --max-time 5 "http://127.0.0.1/.well-known/acme-challenge/test" -o /dev/null \
                        || warn "nginx not responding on port 80 for the ACME challenge — is a firewall or CDN blocking direct :80 access to this host? HTTP-01 will likely fail (consider --tls-mode=dns01 instead)"
                    _certbot_if_needed "$BASE_DOMAIN" "$_CB_LOG" \
                        --webroot -w /var/www/html \
                        && _CERT_OK=true
                else
                    error "nginx config invalid before certbot could run — check: nginx -t"
                fi
            fi

            if [[ "$_CERT_OK" == "true" && -f "/etc/letsencrypt/live/${BASE_DOMAIN}/fullchain.pem" ]]; then
                _write_app_vhost "/etc/letsencrypt/live/${BASE_DOMAIN}/fullchain.pem" \
                                  "/etc/letsencrypt/live/${BASE_DOMAIN}/privkey.pem" "real"
                success "Let's Encrypt cert ready for ${BASE_DOMAIN} (${TLS_MODE})"
            else
                warn "Could not obtain a Let's Encrypt certificate for ${BASE_DOMAIN} — falling back to a self-signed cert so the app stays reachable. Re-run cyassure-setup.sh --update once this is fixed."
                TLS_MODE="selfsigned"
            fi
        fi

        if [[ "$TLS_MODE" == "selfsigned" ]]; then
            mkdir -p "${_CERT_DIR}/selfsigned"
            if openssl req -x509 -nodes -newkey rsa:2048 \
                -keyout "${_CERT_DIR}/selfsigned/privkey.pem" \
                -out    "${_CERT_DIR}/selfsigned/fullchain.pem" \
                -days 90 \
                -subj "/CN=${BASE_DOMAIN}/O=CyAssure/C=US" \
                -addext "subjectAltName=DNS:${BASE_DOMAIN}" \
                2>/dev/null; then
                _write_app_vhost "${_CERT_DIR}/selfsigned/fullchain.pem" "${_CERT_DIR}/selfsigned/privkey.pem" "selfsigned"
                warn "Self-signed cert installed for ${BASE_DOMAIN} — browsers will show a security warning until a real cert is issued (re-run with --tls-mode=http01, dns01, or byo once ready)"
            else
                error "Self-signed cert generation failed for ${BASE_DOMAIN} — host vhost NOT created, app remains unreachable at https://${BASE_DOMAIN}"
            fi
        fi

        if [[ -f "$_APP_VHOST" ]]; then
            ln -sf "$_APP_VHOST" "/etc/nginx/sites-enabled/cyassure-modules" 2>/dev/null || true
            rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
            if nginx -t 2>/dev/null; then
                if systemctl reload nginx 2>/dev/null || systemctl start nginx 2>/dev/null; then
                    success "nginx reloaded with a vhost for ${BASE_DOMAIN} → 127.0.0.1:${_UPSTREAM_PORT}"
                else
                    warn "nginx config for ${BASE_DOMAIN} is valid but reload/start failed — check: systemctl status nginx"
                    ERRORS+=("nginx reload failed after host vhost/TLS provisioning")
                fi
            else
                error "nginx config invalid after writing the ${BASE_DOMAIN} vhost — check: nginx -t"
                ERRORS+=("host vhost/TLS provisioning failed nginx -t")
            fi
        fi
    fi
fi

# ── Step 4.3c: Wire oauth2-proxy into the host vhost (whole-app gate) ────────
# The oauth2-proxy container above has always started (best-effort) whenever
# its secrets exist in .env — for every customer, unconditionally, since
# those secrets are themselves generated unconditionally the same run (see
# "Add IAP oauth2-proxy secrets if missing" above). But nothing has ever
# actually routed traffic through the container: found live, root@CY360-DEV,
# 2026-08-23, tracing why CySOAR access supposedly required "IAP Gateway" —
# cy-proxy was running and correctly OIDC-configured, but the host vhost's
# proxy_pass still pointed straight at the frontend container, so oauth2-proxy
# gated nothing. That gap exists on every install, not just this one. Runs
# unconditionally here — same gate as the container start above (secrets
# present) — no separate opt-in: this is universal for every customer, not a
# manual per-server setting, and gets re-applied on every --update/--full run
# so a server that drifts (a vhost hand-edited back, e.g.) self-heals. The
# actual customer-facing update path (Settings > Update/Upgrade, most
# customers' only update mechanism) never invokes this script at all — see
# updater/server.py's matching _wire_iap_gateway_vhost(), called from every
# /update and /upgrade, which is the same logic ported to run there instead
# via nsenter, so BOTH paths cover this regardless of which one a given
# server actually uses.
#
# Domain-driven throughout, no hardcoded vhost filename or domain. The vhost
# this was found against happened to be hand-named "cy360" — Certbot's naming
# isn't a guaranteed convention across installs, so this searches
# sites-enabled for whichever server block's server_name actually matches
# $BASE_DOMAIN instead of assuming a filename.
if [[ -n "$OAUTH2PROXY_SECRET" && -n "$OAUTH2PROXY_COOKIE_SECRET" ]]; then
    step_header "WIRE oauth2-proxy INTO HOST VHOST"
    _iap_vhost=""
    for _f in /etc/nginx/sites-enabled/*; do
        [[ -f "$_f" ]] || continue
        if grep -qE "server_name[[:space:]]+([^;]*[[:space:]])?${BASE_DOMAIN}([[:space:]]|;)" "$_f" 2>/dev/null; then
            _iap_vhost="$_f"
            break
        fi
    done

    if [[ -z "$_iap_vhost" ]]; then
        info "No nginx vhost found in /etc/nginx/sites-enabled/ with server_name ${BASE_DOMAIN} — the oauth2-proxy container is running but not wired into any traffic path. If you're using something other than host nginx to terminate TLS (Cloudflare Tunnel, another LB, etc.), point IT at 127.0.0.1:4180 instead of 127.0.0.1:${APP_PORT} manually — see DOCKER_DEPLOYMENT.md."
    else
        _iap_vhost_real=$(readlink -f "$_iap_vhost" 2>/dev/null || echo "$_iap_vhost")
        # -E + [[:space:]]+ rather than a literal single space: the "HOST VHOST
        # + TLS PROVISIONING" step above aligns proxy_pass with the other
        # proxy_set_header lines using multiple spaces, not one — a literal-
        # space grep here missed that vhost entirely and fell through to the
        # "doesn't match expected pattern" warning below even though it WAS
        # already correctly wired to 4180. Confirmed live during the --tls-mode
        # dns01 fresh-install test, 2026-08-23.
        #
        # A vhost this script generated has SEVERAL proxy_pass lines pointing
        # at APP_PORT (the /oidc/, /auth/, /api/sso/, /mcp/,
        # /api/edr/installer/..., and /api/ai-security/browser-ext/...
        # bypasses — see "HOST VHOST + TLS PROVISIONING" above) plus exactly ONE marked
        # "# cyassure-iap-gate" (the /api/ block, the only one that should
        # ever toggle to 4180). A plain grep/sed here would match — and
        # wrongly rewrite — the bypasses too. When that marker exists
        # anywhere in the file, require it in both the match and the
        # rewrite; a hand-written/legacy vhost with no marker at all keeps
        # the original whole-file behavior (that vhost only ever has one
        # catch-all proxy_pass to begin with).
        if grep -q "# cyassure-iap-gate" "$_iap_vhost_real" 2>/dev/null; then
            _gate_match='[[:space:]]*#[[:space:]]*cyassure-iap-gate'
            _gate_lit=' # cyassure-iap-gate'
        else
            _gate_match=''
            _gate_lit=''
        fi
        if grep -qE "proxy_pass[[:space:]]+http://127.0.0.1:4180;${_gate_match}" "$_iap_vhost_real" 2>/dev/null; then
            info "${_iap_vhost_real}: already wired through oauth2-proxy — no change needed"
        elif grep -qE "proxy_pass[[:space:]]+http://127.0.0.1:${APP_PORT};${_gate_match}" "$_iap_vhost_real" 2>/dev/null; then
            cp "$_iap_vhost_real" "${_iap_vhost_real}.pre-iap-gateway.bak"
            sed -i -E "s#proxy_pass[[:space:]]+http://127.0.0.1:${APP_PORT};${_gate_match}#proxy_pass http://127.0.0.1:4180;${_gate_lit}#" "$_iap_vhost_real"
            if nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null; then
                success "${_iap_vhost_real}: wired through oauth2-proxy (127.0.0.1:4180) — backup at ${_iap_vhost_real}.pre-iap-gateway.bak"
            else
                warn "${_iap_vhost_real}: nginx -t/reload failed after wiring oauth2-proxy — reverting"
                cp "${_iap_vhost_real}.pre-iap-gateway.bak" "$_iap_vhost_real"
                nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null
                ERRORS+=("IAP Gateway vhost wiring failed — reverted, app traffic unaffected")
            fi
        else
            warn "${_iap_vhost_real}: found a vhost matching server_name ${BASE_DOMAIN} but its proxy_pass doesn't match the expected http://127.0.0.1:${APP_PORT} pattern — not touching it automatically to avoid corrupting a custom config. Point it at http://127.0.0.1:4180 manually to enable IAP Gateway."
        fi

        # ── Inject the CyEDR agent-bypass location block if missing (idempotent) ──
        # A vhost provisioned before 2026-08-25 (this fix) never got this block at
        # all — see "HOST VHOST + TLS PROVISIONING" above's CYEDR-AGENT-BYPASS
        # comment for the full incident. Runs regardless of which branch above
        # fired (already-wired / just-wired / unrecognized-pattern) — this is
        # orthogonal to whether IAP was just toggled on this run, it only needs
        # a vhost to have been found. Same marker + insertion pattern as the
        # /edr-packages/ injection below, and mirrored in updater/server.py's
        # _wire_iap_gateway_vhost() (called on every /update and /upgrade) so an
        # already-provisioned instance gets this fixed via the portal's Update
        # button too, not just a fresh `cyassure-setup.sh --update` SSH run.
        if ! grep -q "CYEDR-AGENT-BYPASS" "$_iap_vhost_real" 2>/dev/null; then
            # Heredoc deliberately NOT 'quoted' — ${APP_PORT} below needs this
            # script's own shell substitution. \$host/\$remote_addr/etc. are
            # backslash-escaped so bash leaves them as literal $-prefixed text
            # for Python to write into the nginx config verbatim (nginx's OWN
            # variables, not this script's) — same technique the main vhost
            # heredoc above already uses throughout.
            python3 - "$_iap_vhost_real" << EDR_BYPASS_NGINX_PY
import sys
path = sys.argv[1]
with open(path) as f:
    text = f.read()

block = (
    "    # CYEDR-AGENT-BYPASS — every endpoint an enrolled agent (or a\n"
    "    # not-yet-enrolled one, for self-enroll) calls on its own: heartbeat,\n"
    "    # telemetry, FIM/SCA/tamper reporting, response-command polling,\n"
    "    # self-enroll, self-update binary download. All Bearer/deploy-token\n"
    "    # authenticated at the Flask layer, never a browser session — gating\n"
    "    # these behind oauth2-proxy makes them unreachable (a headless agent\n"
    "    # can't complete an OIDC login), not more secure. Added 2026-08-25 —\n"
    "    # see cyassure-setup.sh's matching block for the full incident.\n"
    "    location ~ ^/api/edr/(agents/self-enroll|agents/[^/]+/heartbeat|telemetry|logs|inventory|fim/events|fim/baseline|sca/results|tamper-events|response/[^/]+/pending|response/[^/]+/commands/[^/]+/complete|installer/agent-binary|installer/custom-yara)\$ {\n"
    "        proxy_pass         http://127.0.0.1:${APP_PORT};\n"
    "        proxy_http_version 1.1;\n"
    "        proxy_set_header   Host              \$host;\n"
    "        proxy_set_header   X-Real-IP         \$remote_addr;\n"
    "        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;\n"
    "        proxy_set_header   X-Forwarded-Proto https;\n"
    "    }\n"
)

anchor = "    location /api/ {"
if anchor in text:
    idx = text.find(anchor)
    text = text[:idx] + block + text[idx:]
    with open(path, "w") as f:
        f.write(text)
    print("nginx: CYEDR-AGENT-BYPASS location block injected")
else:
    print("nginx: 'location /api/ {' anchor not found — CYEDR-AGENT-BYPASS block NOT injected, check this vhost manually")
EDR_BYPASS_NGINX_PY
            nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null && \
                success "nginx: CyEDR agent-bypass location block added and reloaded" || \
                warn "nginx reload failed after CyEDR agent-bypass injection — check: nginx -t"
        else
            success "nginx: CyEDR agent-bypass location already configured"
        fi
    fi
fi

# ── Remove duplicate CORS headers from cyasm nginx block (added before v1.0.286) ──
# Flask's global after_request hook is the single CORS authority. nginx was also
# adding CORS headers on the cyasm vhost, producing duplicates that caused the
# browser to reject every /auth/local response with "Network error".
_NGINX_MOD="/etc/nginx/sites-available/cyassure-modules"
if [[ -f "$_NGINX_MOD" ]] && grep -q 'cors_origin\|Access-Control-Allow-Origin' "$_NGINX_MOD" 2>/dev/null; then
    sed -i '/set \$cors_origin/d' "$_NGINX_MOD" || true
    sed -i '/if.*http_origin.*cors_origin/d' "$_NGINX_MOD" || true
    sed -i '/add_header Access-Control-Allow-Origin/d' "$_NGINX_MOD" || true
    sed -i '/add_header Access-Control-Allow-Credentials/d' "$_NGINX_MOD" || true
    sed -i '/add_header Access-Control-Allow-Methods/d' "$_NGINX_MOD" || true
    sed -i '/add_header Access-Control-Allow-Headers.*CyAssure/d' "$_NGINX_MOD" || true
    nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null && \
        success "nginx cyasm: duplicate CORS headers removed" || \
        warn "nginx reload failed after CORS patch — check: nginx -t"
    fi

    # ── Remove OPTIONS intercept from cyasm nginx block (added before v1.0.295) ──
    # The Flask app.py blanket handler (/auth/<path>) returns 204 + full CORS
    # headers for every OPTIONS preflight. The nginx-level `if ($request_method
    # = OPTIONS) { return 204; }` was intercepting those requests before Flask
    # saw them and returning 204 with NO Access-Control-* headers, causing the
    # browser to reject every /auth/local CORS preflight → "Network error".
    if [[ -f "$_NGINX_MOD" ]] && grep -q 'request_method = OPTIONS.*return 204' "$_NGINX_MOD" 2>/dev/null; then
        sed -i '/if (\$request_method = OPTIONS) { return 204; }/d' "$_NGINX_MOD" || true
        sed -i '/if ($request_method = OPTIONS) { return 204; }/d' "$_NGINX_MOD" || true
        nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null && \
            success "nginx cyasm: OPTIONS intercept removed — Flask handles CORS preflight" || \
            warn "nginx reload failed after OPTIONS patch — check: nginx -t"
    fi

    # ── Inject /edr-packages/ nginx location if missing (idempotent) ────────────
    # Serves pre-built CyEDR agent binaries (.deb/.rpm/.msi/.pkg + standalone exe).
    # Built by agent/packages/build-edr-packages.sh; stored in the edr/ subdirectory.
    if [[ -f "$_NGINX_MOD" ]] && ! grep -q '/edr-packages/' "$_NGINX_MOD" 2>/dev/null; then
        python3 - "$_NGINX_MOD" << 'EDR_PKG_NGINX_PY'
import sys, re
path = sys.argv[1]
with open(path) as f:
    text = f.read()

block = (
    "    # ── CyEDR agent package distribution — served directly by nginx ──\n"
    "    location /edr-packages/ {\n"
    "        alias /var/lib/cyassure-agent-packages/edr/;\n"
    "        autoindex off;\n"
    "        add_header Content-Disposition \"attachment\" always;\n"
    "        add_header X-Content-Type-Options \"nosniff\" always;\n"
    "        add_header Cache-Control \"no-store, must-revalidate\" always;\n"
    "    }\n"
)

anchor = "    location /     { try_files"
if "/edr-packages/" not in text and anchor in text:
    idx = text.find(anchor)
    text = text[:idx] + block + text[idx:]
    with open(path, "w") as f:
        f.write(text)
    print("nginx cy360: /edr-packages/ location block injected")
else:
    print("nginx cy360: /edr-packages/ already present or anchor not found")
EDR_PKG_NGINX_PY
        nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null && \
            success "nginx: /edr-packages/ location block added and reloaded" || \
            warn "nginx reload failed after edr-packages injection — check: nginx -t"
    else
        [[ -f "$_NGINX_MOD" ]] && success "nginx: /edr-packages/ location already configured"
    fi

    # ── Ensure sites-enabled is a symlink to sites-available ─────────────────────
    # On servers where sites-enabled/cyassure-modules is a hardcopy file (not a
    # symlink), all nginx migration edits above are invisible to nginx because it
    # reads sites-enabled directly. Force-recreate the symlink so sites-enabled
    # always reflects sites-available. This is idempotent — ln -sf is safe to
    # repeat and the full-install step also runs this same command.
    if [[ -f "/etc/nginx/sites-available/cyassure-modules" ]]; then
        _SE="/etc/nginx/sites-enabled/cyassure-modules"
        if [[ ! -L "$_SE" ]]; then
            ln -sf /etc/nginx/sites-available/cyassure-modules "$_SE" 2>/dev/null && \
                info "nginx: sites-enabled replaced with symlink to sites-available" || true
        fi
    fi

# ── Steps 11-14: Portal deploy / backend package / DB migrations / systemd —
# DEPRECATED, now Docker services ─────────────────────────────────────────────
# The Flask backend, the cysiemstack-engine, and the portal used to be
# deployed here as native systemd services (cyassure-backend.service,
# cysiemstack-engine.service) fed by a pip-installed wheel and a rsync'd
# portal/dist/. All of that is now `docker compose up -d` (docker-compose.yml:
# backend, cysiemstack-engine, frontend services; DB schema/migrations run
# automatically at container startup via cy_comp/models.py's ensure_tables()
# and cysiemstack's own init — see backend/Dockerfile, backend/Dockerfile.engine,
# portal/Dockerfile). See DOCKER_DEPLOYMENT.md.
#
# KNOWN GAP left by this removal (not fixed here, needs separate follow-up):
# the license-watchdog enforcement (systemd timer that stopped
# cyassure-backend/cysiemstack-engine on expiry) lived in this block and is
# removed with it — license_validator.py itself is still staged to
# /opt/cyassure/license_validator.py above, but nothing currently calls it on
# a schedule or gates container startup on it for a Docker deployment. A
# real replacement (an APScheduler job inside the Flask container, or a
# small sidecar that runs `docker compose stop` via the mounted docker
# socket) needs its own design pass, not a mechanical port.
#
# PORTAL_DIR ("/var/www/cyassure360", the old rsync-deployed host path) was
# removed 2026-07-27 along with the branding/domain-injection/RBAC-file steps
# that were its only readers — see the "Steps 20-22" removal comment below.
#
# The old /tmp/cyassure-config staging copy (of the now-deleted CYSIEM-Config/
# directory) was removed 2026-07-27 along with CYSIEM-Config/ itself — Sysmon
# staging below now reads directly from agent/assets/sysmon/ in the bundle.
#
# The bare-metal native-Kafka+ClickHouse CyDataLake install that used to run
# here (Step 14.5, referencing a now-nonexistent `cyassure-backend` systemd
# service) was removed 2026-08-09 — CyDataLake is Docker-native and
# unconditional now, see the "DOCKER APPLICATION" step. PYTHON_BIN/SITE_PKG,
# which existed only to feed that step's ingest-worker systemd unit, were
# removed with it.
step_header "PORTAL / CONFIG STAGING (legacy paths still read by later steps)"

# ── Steps 15-16: nginx vhosts + SSL certificates — RESTORED 2026-08-23 ───────
# The old per-module (cy360, cyasm) nginx vhosts are gone for good — the
# frontend container's own nginx (portal/nginx.conf) now does all same-origin
# static SPA + /api /auth /oidc /mcp proxying, so only ONE host vhost is
# needed as a TLS-terminating reverse proxy in front of it (or oauth2-proxy).
# That single vhost + its certificate (Let's Encrypt HTTP-01/DNS-01,
# customer-supplied, or self-signed) is now provisioned by the "HOST VHOST +
# TLS PROVISIONING" step, right after the IAP Gateway (oauth2-proxy) step
# above — see --tls-mode. This was a real, disclosed gap on every fresh
# install between the Docker pivot and 2026-08-23: the app was reachable on
# 127.0.0.1 only, never from BASE_DOMAIN, until an admin wired up a reverse
# proxy by hand.

# ── Step 18: GeoIP enrichment + CyEDR Sysmon config staging ──────────────────
# Runs unconditionally — GeoIP feeds the correlation engine's alert enrichment
# and Sysmon config is served to CyEDR's Windows installer; neither depends on
# a locally-installed SIEM.

# geoip2's own host-python3 import check was removed 2026-07-27 — it checked
# the HOST's system Python (referencing a "STEP 12: INSTALLING
# CYASSURE-BACKEND PACKAGE" step that no longer exists post-Docker-pivot) for
# a package that's only ever imported inside the backend/cysiemstack-engine
# containers (backend/requirements.txt pins it; normaliser.py:22 is the only
# reader). The host having or not having geoip2 was never relevant.

# ── GeoLite2-City.mmdb download (always refreshed — MaxMind updates monthly) ──
GEOIP_DIR="/opt/cyassure/geoip"
mkdir -p "$GEOIP_DIR"
GEOLITE_DB="$GEOIP_DIR/GeoLite2-City.mmdb"
_MMKEY="$(grep "^MAXMIND_KEY=" /opt/cyassure/.env 2>/dev/null | cut -d= -f2)"
if [[ -n "$_MMKEY" ]]; then
    info "Downloading/refreshing GeoLite2-City.mmdb..."
    GEOURL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=${_MMKEY}&suffix=tar.gz"
    TMP_GEO=$(mktemp /tmp/geolite2_XXXXXX.tar.gz)
    curl -sL "$GEOURL" -o "$TMP_GEO" \
        && tar -xzf "$TMP_GEO" -C "$GEOIP_DIR" --strip-components=1 --wildcards "*.mmdb" 2>/dev/null || true
    find "$GEOIP_DIR" -name "*.mmdb" ! -name "GeoLite2-City.mmdb" -exec mv {} "$GEOLITE_DB" \; 2>/dev/null || true
    rm -f "$TMP_GEO"
    if [[ -f "$GEOLITE_DB" ]]; then
        success "GeoLite2-City.mmdb downloaded/refreshed"
        # Install monthly cron to keep the DB current (MaxMind releases a new DB every month)
        cat > /etc/cron.monthly/cyassure-geoip-refresh << 'GEOCRON'
#!/bin/bash
# Refresh GeoLite2-City.mmdb — MaxMind releases an updated DB monthly.
MMKEY="$(grep "^MAXMIND_KEY=" /opt/cyassure/.env 2>/dev/null | cut -d= -f2)"
[[ -z "$MMKEY" ]] && exit 0
GEOIP_DIR="/opt/cyassure/geoip"
GEOLITE_DB="$GEOIP_DIR/GeoLite2-City.mmdb"
TMP=$(mktemp /tmp/geolite2_XXXXXX.tar.gz)
curl -sL "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=${MMKEY}&suffix=tar.gz" -o "$TMP" \
    && tar -xzf "$TMP" -C "$GEOIP_DIR" --strip-components=1 --wildcards "*.mmdb" 2>/dev/null || true
find "$GEOIP_DIR" -name "*.mmdb" ! -name "GeoLite2-City.mmdb" -exec mv {} "$GEOLITE_DB" \; 2>/dev/null || true
rm -f "$TMP"
# KNOWN GAP (flagged 2026-07-27, not fixed): this used to `systemctl restart
# cyassure-siem` so the correlation engine would reload the refreshed DB from
# disk (normaliser.py opens it once at import time and caches the reader).
# That systemd service no longer exists — this cron currently refreshes the
# .mmdb file on disk but nothing restarts the cysiemstack-engine container to
# pick it up. A real fix needs either a docker socket + `docker compose
# restart cysiemstack-engine` (requires knowing the compose project's
# location, which this script does not track) or an in-app reload signal —
# not invented here.
GEOCRON
        chmod +x /etc/cron.monthly/cyassure-geoip-refresh
        success "Monthly GeoIP refresh cron installed → /etc/cron.monthly/cyassure-geoip-refresh"
    else
        warn "GeoLite2 download failed — GeoIP enrichment disabled until next refresh"
    fi
else
    warn "MAXMIND_KEY not set — GeoLite2 DB skipped (GeoIP enrichment disabled)"
fi

# ── CyEDR: stage Sysmon config for platform download endpoint ────────────
# cyassure_sysmon_config.xml is served by the Flask backend at:
#   GET /api/edr/installer/sysmon-config
# cyedr-install.ps1 downloads it from there during Windows endpoint enrollment.
_SYSMON_PKG="/opt/cyassure/sysmon"
if [[ -f "$BUNDLE_DIR/agent/assets/sysmon/cyassure_sysmon_config.xml" ]]; then
    mkdir -p "$_SYSMON_PKG"
    cp "$BUNDLE_DIR/agent/assets/sysmon/cyassure_sysmon_config.xml" "$_SYSMON_PKG/"
    success "cyassure_sysmon_config.xml staged to $_SYSMON_PKG (served via /api/edr/installer/sysmon-config)"
fi

info "Post-install manual steps:"
info "  1. GeoIP DB is refreshed automatically every month (MAXMIND_KEY is pre-configured)"
info "  2. Deploy CyEDR on endpoints:"
info "       Linux/macOS: curl -fsSL https://<platform>/cyedr-install.sh | sudo bash -s -- --token <TOKEN> --platform <URL>"
info "       Windows:     .\\cyedr-install.ps1 -Token <TOKEN> -Platform <URL>"
info "  3. Audit policy for Domain Controllers: run scripts/cyedr-install.ps1 or"
info "     copy /opt/cyassure/sysmon/apply_audit_policy.ps1 to the DC and run as Domain Admin"


# ── Steps 20-22 (branding, portal domain injection, RBAC file staging) ───────
# DEPRECATED — removed 2026-07-27, found fully dead during a host-vs-Docker
# audit, independent of the "DOWNLOAD RELEASE BUNDLE" fix above:
#   - Branding (cylogo) targeted /usr/local/lib/python3.12/dist-packages/
#     cy_asm/modules/cylogo — a bare-metal wheel-install path. Nothing
#     pip-installs cyassure-backend into the host's system Python anymore,
#     so this path never existed post-Docker-pivot; every run just warned
#     "not found — skipping" for all 5 branding scripts.
#   - Portal domain injection wrote into $PORTAL_DIR/index.html, where
#     PORTAL_DIR="/var/www/cyassure360" — the old rsync-deployed host path.
#     The portal is a Docker image now (portal/Dockerfile); there is no
#     host-side index.html to inject into.
#   - rbac.json/rbac.default.json staging to /opt/cyassure/: grepped the
#     entire backend for readers of either file — none exist. RBAC is 100%
#     DB-driven (see backend/blueprints/rbac/manager.py's _bootstrap_admin /
#     _bootstrap_roles, direct SQL INSERT ON CONFLICT DO NOTHING). This was
#     dead code regardless of whether the bundle download ever succeeded.
#   - config.json write also targeted the dead $PORTAL_DIR.
# KNOWN GAP: if per-customer domain/branding customization of the portal is
# still a wanted feature, it needs a real Docker-native design (e.g. env
# vars baked into the frontend container at build or start time) — not
# reintroduced as a mechanical port of this bare-metal code.
#
# Ensure log directory and auth log exist with correct permissions
mkdir -p /var/log/cyassure && touch /var/log/cyassure/auth.log
chmod 644 /var/log/cyassure/auth.log

# ── Step 22b: CyEDR Package Repository ───────────────────────────────────────
# Stages CyEDR agent/tray binaries from the release bundle. Runs on both fresh
# installs and updates. Packages are stored at
# /var/lib/cyassure-agent-packages/ — directly accessible by NGINX (www-data, 755).
# Keeping packages outside /opt/cyassure/ (which is root-only 700) avoids NGINX 403.
step_header "AGENT PACKAGE REPOSITORY"

_AGENT_PKG_DIR="/var/lib/cyassure-agent-packages"
mkdir -p "$_AGENT_PKG_DIR"
chmod 755 "$_AGENT_PKG_DIR"
chown www-data:www-data "$_AGENT_PKG_DIR" 2>/dev/null || true

_bundle_pkgs="${BUNDLE_DIR:-/tmp/cyassure-release}/agent-packages"

# ── Seed Linux CyEDR agent + tray binaries from the host-assets bundle ──────
# Built automatically by CI (.github/workflows/deploy.yml's build-and-publish
# job — Linux only, built inline in that same job) and bundled into
# cy360-host-assets-*.tar.gz, same mechanism as cy360-agent-* above. This is
# what lets a customer paste a single install link copied from the Cy360
# portal — /api/edr/installer/agent-bundle and /tray-bundle can always serve
# a real Linux binary with no manual build step by devops or the customer.
# Filenames are OS/arch-keyed only (no version suffix — see routes.py's
# installer_agent_bundle/installer_tray_bundle _map), so this is a plain
# overwrite-on-update copy, not the versioned rename cy360-agent-* needs
# above.
#
# macOS and Windows do NOT land here — see the next step below, which stages
# them separately. (This comment used to claim they were "bundled here" the
# same way; found false 2026-08-25 — build-edr-macos and the on-demand-only
# build-edr-windows are separate CI jobs, neither a `needs:` dependency of
# the job that builds this tarball, so their binaries can't be baked into it
# at that job's run time — Windows in particular may not even exist yet for
# this tag when this tarball was built, if dispatched later. Until the next
# step was added, nothing anywhere ever staged those two platforms onto a
# live instance at all: a live install/update would correctly report the
# new agent_version in its heartbeat (that's just a baked text file, always
# current) while every macOS/Windows install or self-update attempt 404'd
# indefinitely, with no error surfaced anywhere an operator would see it.
_bundle_edr="${_bundle_pkgs}/edr"
if [[ -d "$_bundle_edr" ]]; then
    # Matches routes.py's _EDR_PKG_DIR = "/var/lib/cyassure-agent-packages/edr"
    _edr_dest="${_AGENT_PKG_DIR}/edr"
    mkdir -p "$_edr_dest"
    _edr_seeded=0
    for _epkg in "${_bundle_edr}"/cyedr-agent-* "${_bundle_edr}"/cyedr-tray-*; do
        [[ -f "$_epkg" ]] || continue
        _ebn=$(basename "$_epkg")
        cp "$_epkg" "${_edr_dest}/${_ebn}"
        chmod 755 "${_edr_dest}/${_ebn}"
        chown www-data:www-data "${_edr_dest}/${_ebn}" 2>/dev/null || true
        _edr_seeded=$((_edr_seeded+1))
    done
    if [[ $_edr_seeded -gt 0 ]]; then
        success "Linux CyEDR agent/tray binaries staged from host-assets bundle: ${_edr_seeded} file(s) → ${_edr_dest}"
    else
        warn "Host-assets bundle has no Linux CyEDR agent/tray binaries (build-and-publish's inline Linux build likely failed this release) — there is no fallback anymore (Python-mode installer removed 2026-08-25): Linux EDR installs will hard-fail until the next successful release, or run agent/packages/build-edr-packages.sh manually to stage them now"
    fi
else
    warn "No agent-packages/edr/ in host-assets bundle — Linux CyEDR binary quick-install unavailable until the next release; run agent/packages/build-edr-packages.sh manually to stage them now"
fi

# ── Seed macOS/Windows CyEDR binaries directly from release assets ──────────
# Uploaded as flat, individually-named release assets by their own CI jobs
# (build-edr-macos / build-edr-windows — see the comment above for why they
# can't ride in the host-assets tarball) rather than a bundle this script
# extracts, so this step looks each expected filename up directly in the
# release's own asset list (routes.py's installer_agent_bundle/
# installer_tray_bundle _map has the authoritative names) and downloads
# whichever ones exist. Missing ones (most commonly Windows, if
# build-edr-windows hasn't been dispatched yet for this tag — see
# git-push.sh's header) are reported, not treated as an error: re-running
# this script (--update) after a later on-demand dispatch is exactly how
# those get picked up.
if [[ -n "$_RELEASE_JSON" ]]; then
    _edr_dest="${_AGENT_PKG_DIR}/edr"
    mkdir -p "$_edr_dest"
    _macwin_seeded=0
    _macwin_missing=0
    for _macwin_asset in \
        cyedr-agent-macos-arm64 cyedr-agent-macos-intel64 \
        cyedr-tray-macos-arm64  cyedr-tray-macos-intel64 \
        cyedr-agent-windows-x64.exe cyedr-tray-windows-x64.exe; do
        _asset_url=$(echo "$_RELEASE_JSON" | \
            jq -r --arg n "$_macwin_asset" '.assets[] | select(.name == $n) | .url' | head -1)
        if [[ -z "$_asset_url" || "$_asset_url" == "null" ]]; then
            _macwin_missing=$((_macwin_missing+1))
            continue
        fi
        # Asset API URL, not browser_download_url — same reasoning as the
        # host-assets tarball download above (required for a private repo;
        # the direct download URL 404s without the API + auth header).
        if curl -fsSL \
            -H "Authorization: Bearer ${GH_TOKEN}" \
            -H "Accept: application/octet-stream" \
            "$_asset_url" \
            -o "${_edr_dest}/${_macwin_asset}"; then
            chmod 755 "${_edr_dest}/${_macwin_asset}"
            chown www-data:www-data "${_edr_dest}/${_macwin_asset}" 2>/dev/null || true
            _macwin_seeded=$((_macwin_seeded+1))
        else
            warn "Failed to download ${_macwin_asset} from release ${CYASSURE_VERSION}"
        fi
    done
    if [[ $_macwin_seeded -gt 0 ]]; then
        success "macOS/Windows CyEDR binaries staged from release assets: ${_macwin_seeded} file(s) → ${_edr_dest}"
    fi
    if [[ $_macwin_missing -gt 0 ]]; then
        warn "${_macwin_missing} macOS/Windows CyEDR binary asset(s) not in release ${CYASSURE_VERSION} yet — expected if build-edr-windows hasn't been dispatched for this tag (gh workflow run deploy.yml -f windows_tag=${CYASSURE_VERSION} --repo cyassure/cy360, then re-run this script with --update), or a build-edr-macos leg failed. Affected platform(s) will hard-fail install/self-update until staged."
    fi
elif [[ -n "${_HA_BASE:-}" ]]; then
    # Public-mirror equivalent of the block above — used whenever no
    # GH_TOKEN was supplied (see the "DOWNLOAD RELEASE BUNDLE" step's
    # 2026-08-26 note). build-edr-macos/build-edr-windows now mirror their
    # binaries to the same host-assets/<tag>/agent-packages/edr/ directory
    # on the public repo, so this is a plain unauthenticated curl per file
    # instead of a GitHub Releases API asset lookup.
    _edr_dest="${_AGENT_PKG_DIR}/edr"
    mkdir -p "$_edr_dest"
    _macwin_seeded=0
    _macwin_missing=0
    for _macwin_asset in \
        cyedr-agent-macos-arm64 cyedr-agent-macos-intel64 \
        cyedr-tray-macos-arm64  cyedr-tray-macos-intel64 \
        cyedr-agent-windows-x64.exe cyedr-tray-windows-x64.exe; do
        if curl -fsSL "${_HA_BASE}/agent-packages/edr/${_macwin_asset}" -o "${_edr_dest}/${_macwin_asset}" 2>/dev/null; then
            chmod 755 "${_edr_dest}/${_macwin_asset}"
            chown www-data:www-data "${_edr_dest}/${_macwin_asset}" 2>/dev/null || true
            _macwin_seeded=$((_macwin_seeded+1))
        else
            rm -f "${_edr_dest}/${_macwin_asset}"
            _macwin_missing=$((_macwin_missing+1))
        fi
    done
    if [[ $_macwin_seeded -gt 0 ]]; then
        success "macOS/Windows CyEDR binaries staged from public mirror: ${_macwin_seeded} file(s) → ${_edr_dest}"
    fi
    if [[ $_macwin_missing -gt 0 ]]; then
        warn "${_macwin_missing} macOS/Windows CyEDR binary asset(s) not on the public mirror yet for ${CYASSURE_VERSION} — expected if build-edr-windows hasn't been dispatched for this tag, or a build-edr-macos leg failed/hasn't synced yet. Re-run with --update once it's published, or pass --token <PAT> for the private release."
    fi
else
    warn "Skipping macOS/Windows CyEDR binary staging — no release metadata available this run (see the host-assets bundle warning above)"
fi

# ── Step 23: Cron jobs ────────────────────────────────────────────────────────
step_header "CRON JOBS"

# NOTE: All cron schedules (docker-maintenance, ASM wordlist, ASM scan) are
# now managed by the CyAssure 360 Scheduler tab in System Settings.
# The portal's /api/system/schedules endpoint writes cron entries directly.
# No cron jobs are auto-provisioned during setup any longer.
info "Cron schedule management delegated to System Settings → Scheduler tab"

# ── Step 23b: Firewall (UFW) ──────────────────────────────────────────────────
# Strategy: all public traffic flows through nginx (80/443).  Internal services
# (Flask 5252, SIEM engine 8100, PostgreSQL 5433, Redis 6379,
# oauth2-proxy 4180, CySOAR 1880) bind to loopback only — no UFW
# rules needed for them.  CyMind on Server B reaches CyAssure via port 80
# (nginx proxy), so no extra firewall holes are required.
if [[ "$SKIP_UFW" == "true" ]]; then
    info "SKIP_UFW set (--skip-ufw) — leaving the host firewall untouched"
else

command -v ufw >/dev/null 2>&1 || apt-get install -y -qq ufw 2>/dev/null

# Set defaults (idempotent)
ufw default deny incoming  >/dev/null 2>&1 || true
ufw default allow outgoing >/dev/null 2>&1 || true

# Allow public-facing ports
# NOTE: port 22 is opened temporarily here; Step 26 (SSH hardening) moves SSH
# to port 2026 and removes this rule at the very end of setup — unless
# --skip-ssh-harden was passed, in which case 22 simply stays open.
ufw allow 22/tcp   comment "SSH (temp — moved to 2026 by Step 26)" >/dev/null 2>&1 || true
ufw allow 80/tcp   comment "HTTP (nginx)"   >/dev/null 2>&1 || true
ufw allow 443/tcp  comment "HTTPS (nginx)"  >/dev/null 2>&1 || true

# Remove any legacy rules that expose internal services directly
for _p in 5252 8100 5433 6379 5601 4180 4433 1880 11434 6333 1514 1515; do
    ufw delete allow ${_p}/tcp >/dev/null 2>&1 || true
    ufw delete allow ${_p}     >/dev/null 2>&1 || true
done

echo "y" | ufw enable >/dev/null 2>&1 || ufw --force enable >/dev/null 2>&1 || true
success "UFW: ports 22 (temp), 80, 443 open — all other ports blocked externally"
info    "Internal services (Flask 5252, engine 8100, Redis, PG) bind to loopback only"
if [[ "$SKIP_SSH_HARDEN" == "true" ]]; then
    info "SSH stays on port 22 (--skip-ssh-harden set)"
else
    info "SSH will be moved from port 22 → 2026 in Step 26 (last step)"
fi

fi # SKIP_UFW

# ── Step 24: Health checks ────────────────────────────────────────────────────
step_header "HEALTH CHECKS"

# DEPRECATED as bare-metal checks: this used to probe 127.0.0.1 ports,
# `systemctl is-active` on cyassure-backend/cysiemstack-engine/postgresql/
# redis-server/nginx, and an nginx config file — none of which exist anymore
# now that those run as Docker services (see Steps 11-16 above). Leaving the
# old checks in place would just report false "DOWN"/"inactive" failures on
# every run. Real health status: `docker compose ps` (each service's
# HEALTHCHECK is defined in docker-compose.yml) — this step only checks what
# genuinely still runs on the host.
echo ""; info "── Host-level services (Docker-hosted app is checked via 'docker compose ps') ──"
_port_up 1880 && success "CySOAR          :1880 UP" || info "CySOAR          :1880 not running (optional, install via portal)"
command -v docker >/dev/null 2>&1 \
    && success "Docker: $(docker --version)" \
    || warn    "Docker not found on this host — required to run the app stack"

# ── Step 25: Cleanup ──────────────────────────────────────────────────────────
step_header "CLEANUP"

# CRITICAL: only ever rm -rf $BUNDLE_DIR when THIS script created it as
# throwaway /tmp scratch space (_BUNDLE_IS_TEMP, set right after the
# `mkdir -p "$BUNDLE_DIR"` download step above). When running from a local
# bundle instead (manifest.json found next to the script — see "DOWNLOAD
# RELEASE BUNDLE" above), $BUNDLE_DIR is set to $_SCRIPT_DIR, i.e. wherever
# this script happens to be sitting. The Setup Wizard's own generated
# hardening command — and the documented manual alternative in
# DOCKER_DEPLOYMENT.md — both `cd` into the actual app install directory and
# extract the host-assets bundle (manifest.json + this script) directly into
# it, then run the script from there. Before this guard, an unconditional
# `rm -rf "$BUNDLE_DIR"` here meant this exact, intended, documented flow
# silently deleted the customer's entire install directory — docker-compose.yml,
# .env, everything — as its very last step. Confirmed as the real cause of a
# live incident 2026-07-30: a server's ~/socpilot directory vanished right
# after this exact command pattern was used, leaving its containers running
# but orphaned with no directory left to manage them from.
if [[ "$_BUNDLE_IS_TEMP" == "true" ]]; then
    rm -rf "$BUNDLE_DIR" /tmp/cyassure-release.tar.gz
    success "Staging files removed"
else
    rm -f /tmp/cyassure-release.tar.gz 2>/dev/null || true
    info "Bundle ran in place (local bundle) — leaving ${BUNDLE_DIR:-the current directory} untouched, not deleting your install directory"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""; divider
echo -e "\n  ${BOLD}${WHITE}CyAssure 360 — ${MODE^^} Complete${NC}\n"
divider; echo ""
echo -e "  ${CYAN}Version        ${NC}  ${BUNDLE_VERSION}"
if [[ "$MODE" == "full" ]]; then
    echo -e "  ${CYAN}Portal + API   ${NC}  https://${BASE_DOMAIN}  (single origin — see portal/nginx.conf)"
fi
echo ""
echo -e "  ${BOLD}App stack      :${NC}  docker compose ps   (backend/engine/frontend/db/redis)"
echo -e "  ${BOLD}App logs       :${NC}  docker compose logs -f backend  (or cysiemstack-engine / frontend)"
echo -e "  ${BOLD}Main env       :${NC}  ./.env  (docker-compose.yml, not /opt/cyassure/.env)"
echo -e "  ${BOLD}nginx config   :${NC}  /etc/nginx/sites-available/cyassure-modules  (IAP gateway only)"
echo ""

if [[ "$MODE" == "full" ]]; then
    echo -e "  ${BOLD}Admin API key  :${NC}  ${WHITE}${ADMIN_API_KEY}${NC}"
    echo -e "  ${BOLD}CySOAR secret  :${NC}  ${WHITE}${CYSOAR_OIDC_SECRET}${NC}"
    echo ""
fi

echo -e "  ${BOLD}${YELLOW}Next steps:${NC}"
echo -e "  ${DIM}1. Verify alerts flowing: docker compose exec redis redis-cli llen cysiemstack:alerts:raw${NC}"
echo -e "  ${DIM}   (CyEDR/CyCollector/connectors feed this queue — check their bridge logs)${NC}"
echo -e "  ${DIM}2. Check engine log: tail -f /opt/cyassure/engine.log${NC}"
echo -e "  ${DIM}3. Security MCP bridge available at http://127.0.0.1:8100/mcp/sse (inside cysiemstack-engine)${NC}"
echo -e "  ${DIM}4. Install CySOAR or CyMISP via portal${NC}"
echo -e "  ${DIM}5. To update: sudo bash cyassure-setup.sh --update${NC}"
echo -e "  ${DIM}6. CyMind integration: install CyMind on Server B, then set CyMind URL in${NC}"
echo -e "  ${DIM}   System Settings → CyMind — nginx /cymind/ proxy is injected automatically${NC}"
echo -e "  ${DIM}   Or pass CYMIND_SERVER_IP=<ip> to this script to wire it up at install time${NC}"
echo -e "  ${DIM}7. SSH is now on port ${_SSH_PORT:-2026} — reconnect: ssh -p ${_SSH_PORT:-2026} user@<server>${NC}"
echo -e "  ${DIM}   Open port ${_SSH_PORT:-2026} in your Cloud Provider firewall/security group${NC}"
echo ""

# Save summary file
cat > /root/cyassure-setup-summary.txt << SUMEOF
CyAssure 360 Setup Summary v7.1
Generated : $(date)
Version   : ${BUNDLE_VERSION}
Mode      : ${MODE}
═══════════════════════════════════
Client : ${CLIENT_NAME}
Domain : ${BASE_DOMAIN}
Email  : ${CLIENT_EMAIL:-n/a}

URLs:
  Portal + API (single origin): https://${BASE_DOMAIN}

App stack (Docker Compose — see DOCKER_DEPLOYMENT.md):
  All services : docker compose ps
  Logs         : docker compose logs -f <backend|cysiemstack-engine|frontend|db|redis>
  Main env     : ./.env  (docker-compose.yml)

Paths (still host-side — IAP gateway / EDR staging, not the app itself):
  nginx config : /etc/nginx/sites-available/cyassure-modules  (IAP gateway only)
  EDR packages : /var/lib/cyassure-agent-packages

Next steps:
  1. Verify alerts flowing: docker compose exec redis redis-cli llen cysiemstack:alerts:raw
     (CyEDR/CyCollector/connectors feed this queue — check their bridge logs)
  2. Check engine log: tail -f /opt/cyassure/engine.log
  3. Security MCP bridge: http://127.0.0.1:8100/mcp/sse (inside cysiemstack-engine)
  4. Install CySOAR or CyMISP via portal
  5. Update: sudo bash cyassure-setup.sh --update
  6. SSH is on port ${_SSH_PORT:-2026} — reconnect: ssh -p ${_SSH_PORT:-2026} user@<server>
     Open port ${_SSH_PORT:-2026} in your Cloud Provider firewall before disconnecting.
SUMEOF

success "Summary saved → /root/cyassure-setup-summary.txt"

if [[ ${#ERRORS[@]} -gt 0 ]]; then
    echo ""
    warn "${#ERRORS[@]} item(s) need attention:"
    for e in "${ERRORS[@]}"; do echo -e "  ${YELLOW}⚠${NC} $e"; done
fi

echo ""; divider
echo -e "  ${DIM}Re-run anytime: sudo bash cyassure-setup.sh${NC}"
echo -e "  ${DIM}Update only:    sudo bash cyassure-setup.sh --update${NC}"
echo ""

# ── Step 26: SSH Hardening — runs last to avoid dropping current session ──────
step_header "SSH HARDENING"

if [[ "$SKIP_SSH_HARDEN" == "true" ]]; then
    info "SKIP_SSH_HARDEN set (--skip-ssh-harden) — leaving SSH on its current port"
else

_SSH_PORT="${SSH_PORT:-2026}"

# Check if already on the target port — skip if so
_current_ssh_port=$(ss -tlnp 2>/dev/null | grep -oP '(?<=:)\d+(?=\s)' | grep -E "^(22|${_SSH_PORT})$" | head -1 || echo "22")
if [[ "$_current_ssh_port" == "$_SSH_PORT" ]]; then
    success "SSH already on port ${_SSH_PORT} — skipping hardening"
else
    echo ""
    warn "Moving SSH from port 22 → ${_SSH_PORT}."
    warn "Your CURRENT session will remain active through the transition."
    warn "After this completes, reconnect on port ${_SSH_PORT}."
    warn "IMPORTANT: Also open port ${_SSH_PORT} in your Cloud Provider firewall/security group."
    echo ""

    # 1. Open new port in UFW BEFORE touching SSH (avoids any lockout window)
    ufw allow ${_SSH_PORT}/tcp comment "SSH (hardened)" >/dev/null 2>&1 || true
    ufw --force reload >/dev/null 2>&1 || true
    success "UFW: port ${_SSH_PORT} opened"

    # 2. Update /etc/ssh/sshd_config (handles commented, uncommented, and missing Port lines)
    if grep -qE "^#?Port 22$" /etc/ssh/sshd_config 2>/dev/null; then
        sed -i "s/^#*Port 22$/Port ${_SSH_PORT}/" /etc/ssh/sshd_config
    elif grep -q "^Port " /etc/ssh/sshd_config 2>/dev/null; then
        sed -i "s/^Port .*/Port ${_SSH_PORT}/" /etc/ssh/sshd_config
    else
        echo "Port ${_SSH_PORT}" >> /etc/ssh/sshd_config
    fi
    success "sshd_config updated → Port ${_SSH_PORT}"

    # 3. Ubuntu 24.04+ systemd socket activation override
    mkdir -p /etc/systemd/system/ssh.socket.d/
    cat > /etc/systemd/system/ssh.socket.d/listen.conf << SSHDEOF
[Socket]
ListenStream=
ListenStream=0.0.0.0:${_SSH_PORT}
ListenStream=[::]:${_SSH_PORT}
SSHDEOF
    success "ssh.socket.d/listen.conf written"

    # 4. Apply — daemon-reload first, then restart socket + service
    systemctl daemon-reload
    systemctl restart ssh.socket 2>/dev/null || true
    systemctl restart ssh        2>/dev/null || true
    sleep 2

    # 5. Verify SSH is now up on the new port before removing old rule
    if ss -tlnp 2>/dev/null | grep -q ":${_SSH_PORT} "; then
        # Remove old port 22 UFW rule now that SSH is confirmed on new port
        ufw delete allow 22/tcp >/dev/null 2>&1 || true
        ufw delete allow 22     >/dev/null 2>&1 || true
        ufw --force reload      >/dev/null 2>&1 || true
        success "SSH hardened — listening on port ${_SSH_PORT}, port 22 closed"
    else
        warn "SSH did not come up on port ${_SSH_PORT} — port 22 rule kept as fallback"
        warn "Check: systemctl status ssh && journalctl -u ssh -n 20"
        ERRORS+=("SSH hardening: port ${_SSH_PORT} not confirmed — manual check required")
    fi

    echo ""
    echo -e "  ${BOLD}${YELLOW}⚠  SSH CONNECTION NOTICE  ⚠${NC}"
    echo -e "  ${YELLOW}Reconnect using: ssh -p ${_SSH_PORT} user@<server>${NC}"
    echo -e "  ${YELLOW}Open port ${_SSH_PORT} in your Cloud Provider firewall/security group NOW.${NC}"
    echo ""
fi

fi # SKIP_SSH_HARDEN