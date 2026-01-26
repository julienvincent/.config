#!/usr/bin/sh
set -euo pipefail

# needs: jq
name="$(
  hyprctl -j monitors \
  | jq -r '.[] | select(.focused==true) | .specialWorkspace.name'
)"

# name is usually like "special:magic" or "" if none.
if [[ -n "${name}" ]]; then
  short="${name#special:}"
  # If it was just "special:" or "special", fall back to toggling the default special
  if [[ -z "${short}" || "${short}" == "special" ]]; then
    hyprctl dispatch togglespecialworkspace
  else
    hyprctl dispatch togglespecialworkspace "${short}"
  fi
fi

hyprctl dispatch workspace "$1"
