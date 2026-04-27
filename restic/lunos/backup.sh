#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")" && pwd)"

source "$SCRIPT_DIR/auth.sh"

restic backup \
  --files-from "$SCRIPT_DIR/config/paths" \
  --exclude-file "$SCRIPT_DIR/config/exclude" \
  --one-file-system \
  --read-concurrency $(nproc) \
  --verbose \
  "$@"
