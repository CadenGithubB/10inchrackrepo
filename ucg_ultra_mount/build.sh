#!/usr/bin/env bash
# Export the UCG Ultra mount STLs (print orientation: front down) and preview images.
set -euo pipefail
cd "$(dirname "$0")"
"$(git rev-parse --show-toplevel 2>/dev/null || echo ..)/tools/install-colors.sh"
SCAD=ucg-ultra-mount.scad
OPENSCAD=${OPENSCAD:-openscad}
mkdir -p images
echo "STL  main mount";  "$OPENSCAD" -q -o 01-ucg-ultra-mount-PRINT-1.stl "$SCAD"
echo "STL  fit coupon";  "$OPENSCAD" -q -D 'part="fitcoupon"' -o fit-coupon-front-20mm.stl "$SCAD"
img() { local name=$1 cam=$2; shift 2; echo "PNG  $name"
  "$OPENSCAD" -q "$@" -o "images/$name.png" --imgsize=1600,1000 --viewall --autocenter --camera="$cam" --colorscheme="Rack Grey" "$SCAD"; }
img mount   0,0,0,60,0,200,0  -D print_orientation=false -D show_device_envelope=true
img front   0,0,0,90,0,0,0    -D print_orientation=false --projection=o
