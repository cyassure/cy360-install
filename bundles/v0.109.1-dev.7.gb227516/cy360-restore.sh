#!/usr/bin/env bash
# cy360-restore.sh — restore a whole CyAssure 360 server from a backup set.
#
# Run as root on the Docker host, from the Cy360 install folder (the one with
# docker-compose.yml and .env). Works on the same server or a new one:
#
#   New server: install Cy360 first with cyassure-setup.sh (same or newer
#   version), then run this. The fresh install's database passwords are kept;
#   everything else — settings, users, tenants, licence, keys, certificates,
#   the database and CyDataLake — comes from the backup.
#
# Usage:
#   sudo ./cy360-restore.sh --set cy360-20261122T020000Z-scheduled --key /root/recovery-key.txt
#   sudo ./cy360-restore.sh --set <id> --key <file> --from-offsite   # download from S3 first
#   sudo ./cy360-restore.sh --set <id> --key <file> --skip clickhouse
#   sudo ./cy360-restore.sh --list [--offsite]
#   sudo ./cy360-restore.sh --set <id> --key <file> --drill           # prove a restore, change nothing
#
# A set copied in by hand goes in /opt/cyassure/backups/<set id>/ (unpack the
# .tar the portal's Download gives you there). For --from-offsite on a new
# server, export the bucket settings first (the stored ones are encrypted
# with a key that is itself inside the backup):
#   export BACKUP_S3_BUCKET=… BACKUP_S3_ACCESS_KEY_ID=… BACKUP_S3_SECRET_ACCESS_KEY=…
#   export BACKUP_S3_ENDPOINT_URL=… BACKUP_S3_REGION=… BACKUP_S3_PREFIX=…   # as needed
set -euo pipefail

SET_ID=""; KEY=""; FROM_OFFSITE=0; SKIP=""; FORCE=0; YES=0; LIST=0; OFFSITE_LIST=0; DRILL=0
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEEP_RUNNING="db redis clickhouse redpanda updater"

die() { echo "ERROR: $*" >&2; exit 1; }
say() { echo "[cy360-restore] $*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --set) SET_ID="$2"; shift 2 ;;
    --key) KEY="$2"; shift 2 ;;
    --from-offsite) FROM_OFFSITE=1; shift ;;
    --skip) SKIP="$2"; shift 2 ;;
    --force) FORCE=1; shift ;;
    --yes|-y) YES=1; shift ;;
    --list) LIST=1; shift ;;
    --offsite) OFFSITE_LIST=1; shift ;;
    --drill) DRILL=1; shift ;;
    --project-dir) PROJECT_DIR="$2"; shift 2 ;;
    -h|--help) sed -n '2,27p' "$0"; exit 0 ;;
    *) die "unknown option $1 (see --help)" ;;
  esac
done

[ "$(id -u)" = "0" ] || die "run as root (sudo)"
cd "$PROJECT_DIR"
[ -f docker-compose.yml ] || die "no docker-compose.yml in $PROJECT_DIR (use --project-dir)"
[ -f .env ] || die "no .env in $PROJECT_DIR — install Cy360 first with cyassure-setup.sh"
docker compose version >/dev/null 2>&1 || die "docker compose is not available"

S3_ENV=()
for v in BACKUP_S3_BUCKET BACKUP_S3_ACCESS_KEY_ID BACKUP_S3_SECRET_ACCESS_KEY BACKUP_S3_ENDPOINT_URL \
         BACKUP_S3_REGION BACKUP_S3_PREFIX BACKUP_S3_USE_PATH_STYLE; do
  [ -n "${!v:-}" ] && S3_ENV+=(-e "$v")
done

run_cli() {
  docker compose run --rm --no-deps -T -e CY360_SKIP_MIGRATE=1 "${S3_ENV[@]}" backend \
    python3 -m blueprints.backup.cli "$@"
}

say "starting the data stores"
docker compose up -d db redis
if grep -q '^CYDATALAKE_ENABLED=true' .env 2>/dev/null; then docker compose up -d clickhouse || true; fi
for _ in $(seq 1 60); do
  docker compose exec -T db pg_isready -q >/dev/null 2>&1 && break
  sleep 2
done

if [ "$LIST" = "1" ]; then
  if [ "$OFFSITE_LIST" = "1" ]; then run_cli list --offsite; else run_cli list; fi
  exit 0
fi

[ -n "$SET_ID" ] || die "--set is required"
[[ "$SET_ID" =~ ^cy360-[0-9]{8}T[0-9]{6}Z-[a-z-]+$ ]] || die "not a backup set id: $SET_ID"
[ -n "$KEY" ] && [ -f "$KEY" ] || die "--key must point to the recovery private key file"
grep -q 'AGE-SECRET-KEY-1' "$KEY" || die "$KEY does not contain an age private key (AGE-SECRET-KEY-1…)"

WORK=/opt/cyassure/backups/.work
mkdir -p "$WORK"; chmod 700 "$WORK"; chown 999:999 /opt/cyassure/backups "$WORK" 2>/dev/null || true
KEYCOPY="$WORK/restore-$$.key"
install -m 400 -o 999 -g 999 "$KEY" "$KEYCOPY"
trap 'shred -u "$KEYCOPY" 2>/dev/null || rm -f "$KEYCOPY"' EXIT

if [ "$FROM_OFFSITE" = "1" ]; then
  say "downloading $SET_ID from the offsite store"
  run_cli fetch --set "$SET_ID"
fi
[ -f "/opt/cyassure/backups/$SET_ID/manifest.json" ] || die "set $SET_ID is not in /opt/cyassure/backups (use --from-offsite or copy it there)"

if [ "$DRILL" = "1" ]; then
  say "restore drill: decrypting everything and restoring the database into a scratch database"
  run_cli verify --set "$SET_ID" --mode drill --identity-file "$KEYCOPY" --actor "host:$(hostname)"
  exit $?
fi

if [ "$YES" != "1" ]; then
  echo
  echo "This REPLACES this server's settings, database and CyDataLake with backup $SET_ID."
  echo "Everything recorded here since that backup will be lost."
  read -r -p "Type RESTORE to continue: " answer
  [ "$answer" = "RESTORE" ] || die "cancelled"
fi

SERVICES=$(docker compose config --services)
STOP=""
for s in $SERVICES; do
  case " $KEEP_RUNNING " in *" $s "*) ;; *) STOP="$STOP $s" ;; esac
done
say "stopping application services:$STOP"
# shellcheck disable=SC2086
docker compose stop $STOP

ARGS=(restore --set "$SET_ID" --identity-file "$KEYCOPY" --yes --actor "host:$(hostname)")
[ -n "$SKIP" ] && ARGS+=(--skip "$SKIP")
[ "$FORCE" = "1" ] && ARGS+=(--force)
set +e
run_cli "${ARGS[@]}"
RC=$?
set -e

say "starting Cy360 (schema checks run on the first start and can take a few minutes)"
docker compose up -d
if [ "$RC" != "0" ]; then
  die "restore failed (see the output above and /var/log/cyassure/backup.log). The services were started again."
fi
for _ in $(seq 1 90); do
  if docker compose exec -T backend curl -sf http://localhost:5252/health >/dev/null 2>&1; then
    say "restore complete and the backend is healthy."
    say "Sign in, check users, tenants, incidents and integrations, then record the result."
    exit 0
  fi
  sleep 5
done
say "restore finished but the backend is not healthy yet: docker compose logs backend"
exit 1
