#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")" && pwd)"

source "$SCRIPT_DIR/auth.sh"

restic forget \
  --keep-hourly 48 \
  --keep-daily 7 \
  --keep-weekly 8 \
  --keep-monthly 12 \
  --keep-yearly 2 \
  --group-by=host \
  --prune \
  "$@"
