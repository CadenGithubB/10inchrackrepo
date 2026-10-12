#!/usr/bin/env bash
# Rebuild the whole-rack viewer: exports every part in its rack position,
# then embeds them in viewer.html. The Flex Mini parts are read from
# ~/Documents/ChatGPT/10 in rack/v4-slot-retainer (see flex_parts.scad).
set -euo pipefail
cd "$(dirname "$0")"
OPENSCAD=${OPENSCAD:-openscad}
mkdir -p stl
for w in frame seps fan studio minis; do "$OPENSCAD" -q -D "which=\"$w\"" -D 'config="m1"' -D '$fn=48' --export-format=binstl -o "stl/mac_$w.stl" mac_parts.scad & done
for w in base frame switch inj; do "$OPENSCAD" -q -D "which=\"$w\"" --export-format=binstl -o "stl/flex_$w.stl" flex_parts.scad & done
for w in body tabs fan ap; do "$OPENSCAD" -q -D "which=\"$w\"" --export-format=binstl -o "stl/ped_$w.stl" ped_parts.scad & done
for w in mount device cables keystones; do "$OPENSCAD" -q -D "which=\"$w\"" --export-format=binstl -o "stl/ucg_$w.stl" ucg_parts.scad & done
for w in rack cover sides; do "$OPENSCAD" -q -D "which=\"$w\"" --export-format=binstl -o "stl/rack_$w.stl" rack.scad & done
wait
python3 - <<'PY'
import base64, glob, os
t = open('viewer_template.html').read()
blocks = [f'<script id="stl-{os.path.basename(f)[:-4]}" type="text/plain">{base64.b64encode(open(f, "rb").read()).decode()}</script>'
          for f in sorted(glob.glob('stl/*.stl'))]
open('viewer.html', 'w').write(t.replace('__DATA__', '\n'.join(blocks)))
PY
echo "viewer.html rebuilt"
