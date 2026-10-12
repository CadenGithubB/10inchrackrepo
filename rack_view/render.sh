#!/usr/bin/env bash
# Render the README pictures from scene.scad. Run ./build.sh first so stl/ is current.
set -euo pipefail
cd "$(dirname "$0")"
OPENSCAD=${OPENSCAD:-openscad}
mkdir -p images
# Mac shelf parts for each layout
for c in m1 m4 m1_m4; do
  for w in seps studio minis; do
    "$OPENSCAD" -q -D "which=\"$w\"" -D "config=\"$c\"" -D '$fn=48' --export-format=binstl -o "stl/mac_${w}_$c.stl" mac_parts.scad &
  done
done
wait
r() { # out, camera (tx,ty,tz,rx,ry,rz,dist), extra args...
  local out=$1 cam=$2; shift 2
  echo "PNG  $out"
  "$OPENSCAD" -q "$@" -o "$out" --imgsize=1600,1200 --camera="$cam" --colorscheme=Tomorrow scene.scad
}
SHELF=0,100,156   # middle of the Mac shelf
# whole rack
r images/rack_front34.png  0,120,300,68,0,-32,1900
r images/rack_rear34.png   0,120,300,68,0,150,1900
r images/rack_top.png      0,128,560,52,0,-25,720
r images/rack_holsters.png 0,240,470,70,0,165,700
# the Mac shelf in the rack (pictures for the main README)
r ../images/rack_m1.png        $SHELF,64,0,-28,1150 -D 'config="m1"'
r ../images/rack_m4.png        $SHELF,64,0,-28,1150 -D 'config="m4"'
r ../images/rack_rear_m4.png   $SHELF,60,0,150,1150 -D 'config="m4"'
for c in m1 m4 m1_m4; do
  r "../images/rack_front_$c.png" $SHELF,90,0,0,1150 -D "config=\"$c\"" --projection=o
done
