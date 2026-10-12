#!/usr/bin/env bash
# Regenerate the holster STLs (print orientation: standing on the shelf) and preview images.
set -euo pipefail
cd "$(dirname "$0")"
"$(git rev-parse --show-toplevel 2>/dev/null || echo .)/tools/install-colors.sh"
SCAD=injector_holster.scad
OPENSCAD=${OPENSCAD:-openscad}
mkdir -p stl images
for p in right left; do
  echo "STL  $p"
  "$OPENSCAD" -q -D "part=\"$p\"" -o "stl/holster_$p.stl" "$SCAD" &
done
wait
img() { local name=$1 cam=$2; shift 2; echo "PNG  $name"
  "$OPENSCAD" -q "$@" -o "images/$name.png" --imgsize=1600,1000 --viewall --autocenter --camera="$cam" --colorscheme="Rack Grey" "$SCAD"; }
img front  0,0,0,70,0,160,0
img empty  0,0,0,60,0,200,0  -D show_device=false
