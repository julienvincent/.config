#!/usr/bin/env bash
set -euo pipefail

export RESTIC_REPOSITORY="rest:https://restic.julienvincent.io/lunos"
export RESTIC_PASSWORD_COMMAND="op read op://Personal/nuuevmud5eco3uhht2iiwnc3ie/password"

restic backup \
  --files-from "./paths" \
  --exclude-file "./exclude" \
  --one-file-system \
  --read-concurrency $(nproc) \
  --verbose \
  "$@"

restic forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 6 \
  --prune
