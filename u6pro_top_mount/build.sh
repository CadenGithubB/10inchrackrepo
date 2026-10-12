#!/usr/bin/env bash
# Regenerate the riser STL (print orientation: flat, ribs and tabs up) and preview images.
set -euo pipefail
cd "$(dirname "$0")"
SCAD=u6pro_riser.scad
OPENSCAD=${OPENSCAD:-openscad}
mkdir -p stl images
echo "STL  riser"
"$OPENSCAD" -q -D 'part="riser"' -o stl/riser.stl "$SCAD"
img() { # name, camera, extra -D args...
  local name=$1 cam=$2; shift 2
  echo "PNG  $name"
  "$OPENSCAD" -q "$@" -o "images/$name.png" --imgsize=1600,1000 --viewall --autocenter \
    --camera="$cam" --colorscheme=Tomorrow "$SCAD"
}
img assembly   0,0,0,78,0,20,0
img riser      0,0,0,55,0,30,0   -D show_devices=false
img section    0,0,0,90,0,0,0    --projection=o
