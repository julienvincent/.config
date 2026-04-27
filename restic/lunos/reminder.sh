#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")" && pwd)"

MARKER="${XDG_STATE_HOME:-$HOME/.local/state}/restic-backup/has-run"
BACKUP_SCRIPT="$SCRIPT_DIR/backup.sh"

mkdir -p "$(dirname "$MARKER")"

# Already executed successfully before.
[[ -e "$MARKER" ]] && exit 0

action="$(
  notify-send \
    -t 10000 \
    --app-name="Restic Backup Reminder" \
    --urgency=normal \
    --action=run="Run Backup Now" \
    --wait \
    "Restic backup has not run yet" \
    "Click to run it now." || true
)"

if [[ "$action" == "run" ]]; then
  if "$BACKUP_SCRIPT"; then
    notify-send \
      --app-name="Restic Backup" \
      "Backup Complete" \
      "Successfully ran your daily backup"

    touch "$MARKER"
  else
    status=$?

    notify-send \
      --app-name="Restic Backup" \
      --urgency=critical \
      "Backup Failed" \
      "Backup exited with status $status"
  fi
fi
