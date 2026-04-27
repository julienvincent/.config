#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")" && pwd)"

MARKER="${XDG_STATE_HOME:-$HOME/.local/state}/restic-backup/last-run"
BACKUP_SCRIPT="$SCRIPT_DIR/backup.sh"
TODAY="$(date +%F)"

mkdir -p "$(dirname "$MARKER")"

# Already executed successfully today.
if [[ -r "$MARKER" && "$(cat "$MARKER")" == "$TODAY" ]]; then
  echo "Already run for today! ($TODAY)"
  exit 0
fi

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
  echo "Backup requested!"

  if "$BACKUP_SCRIPT"; then
    echo "Backup succeeded"
    printf '%s\n' "$TODAY" > "$MARKER"

    notify-send \
      --app-name="Restic Backup" \
      "Backup Complete" \
      "Successfully ran your daily backup"
  else
    status=$?

    echo "Backup failed"
    notify-send \
      --app-name="Restic Backup" \
      --urgency=critical \
      "Backup Failed" \
      "Backup exited with status $status"
  fi
fi
