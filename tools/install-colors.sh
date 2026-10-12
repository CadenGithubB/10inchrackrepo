#!/usr/bin/env bash
# Install the "Rack Grey" OpenSCAD colour scheme the renders use (macOS and Linux user folders).
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)/openscad-colors/rack-grey.json"
for d in "$HOME/Library/Application Support/OpenSCAD/color-schemes/render" "$HOME/.local/share/OpenSCAD/color-schemes/render"; do
  case "$d" in "$HOME/Library"*) [ "$(uname)" = Darwin ] || continue ;; *) [ "$(uname)" = Darwin ] && continue ;; esac
  mkdir -p "$d" && cmp -s "$src" "$d/rack-grey.json" || cp "$src" "$d/rack-grey.json"
done
