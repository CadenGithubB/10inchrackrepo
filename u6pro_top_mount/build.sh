#!/usr/bin/env bash
# Regenerate the STLs (print orientation) and preview images.
# Needs OpenSCAD 2021.01 or newer. Set OPENSCAD to use a copy that isn't on PATH.
set -euo pipefail
cd "$(dirname "$0")"
SCAD=u6pro_top_mount.scad
OPENSCAD=${OPENSCAD:-openscad}
mkdir -p stl images

for p in base deck fit_check; do
  echo "STL  $p"
  "$OPENSCAD" -q -D "part=\"$p\"" -o "stl/$p.stl" "$SCAD" &
done
wait

img() { # name, camera, extra -D args...
  local name=$1 cam=$2; shift 2
  echo "PNG  $name"
  "$OPENSCAD" -q "$@" -o "images/$name.png" --imgsize=1600,1200 --viewall --autocenter \
    --camera="$cam" --colorscheme=Tomorrow "$SCAD"
}

img assembly   0,0,0,60,0,30,0
img exploded   0,0,0,62,0,30,0  -D explode=60
img base_top   0,0,0,0,0,0,0    -D 'part="base"' --projection=o
img deck       0,0,0,40,0,25,0  -D 'part="deck"'
img fit_check  0,0,0,45,0,20,0  -D 'part="fit_check"'
