#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 <target-directory> [--force]" >&2
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 2
fi

target=$1
force=false

if [[ $# -eq 2 ]]; then
  if [[ $2 != "--force" ]]; then
    usage
    exit 2
  fi
  force=true
fi

skill_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
assets_dir="$skill_root/assets"
asset_names=(
  "SystemCanvasPrimitives.tsx"
  "system-canvas.css"
)

for asset_name in "${asset_names[@]}"; do
  destination="$target/$asset_name"
  if [[ -e $destination && $force != true ]]; then
    echo "Refusing to overwrite $destination. Re-run with --force if intentional." >&2
    exit 1
  fi
done

mkdir -p "$target"

for asset_name in "${asset_names[@]}"; do
  destination="$target/$asset_name"
  cp "$assets_dir/$asset_name" "$destination"
  printf '%s\n' "$destination"
done
