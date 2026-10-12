# U6 Pro top mount

A round pedestal that sits on top of the DeskPi RackMate T2 (on its acrylic top cover). It holds a UniFi U6 Pro on top and its U-PoE-AT injector hidden inside.

![Assembly](images/assembly.png)
![Exploded](images/exploded.png)

## Parts

| File | Qty | Size (mm) | Notes |
|---|---|---|---|
| [`stl/base.stl`](stl/base.stl) | 1 | Ø205 × 38 | Prints floor-down. No supports. |
| [`stl/deck.stl`](stl/deck.stl) | 1 | Ø205 × 12 | Prints flat with the cradle rim up. No supports. |
| [`stl/fit_check.stl`](stl/fit_check.stl) | 1 | Ø205 × 10 | Optional. A thin slice of the AP cradle and the injector bay, to check the fit before the full print. |

Hardware: 4 × M3×10 screws and 4 × M3 nuts. Stick-on rubber feet are optional; the spare anti-slip pads from the rack kit work. There are 21 mm recesses for them under the base.

## How it goes together

1. Slide an M3 nut into the side slot of each of the four posts in the base. The slots open towards the middle.
2. Set the injector in its bay with its RJ45 ports facing the rear notch (+Y) and the power socket facing the front.
3. Plug in the LAN cable and run it out the rear notch. Plug in the power cord and run it along the inside wall to whichever notch suits your outlet. The notches are open at the bottom, so cables go in without passing the plugs through.
4. Plug a short patch cable (about 20–30 cm) into the injector's PoE port and feed it up through the centre hole of the deck.
5. Screw the deck down. The deck holds the injector down from above; the side ribs and low end stops keep it from sliding when you plug in cables.
6. Plug the patch cable into the U6 Pro and set the AP in the cradle.

![Base from above](images/base_top.png)

## Fit and dimensions

- **U6 Pro:** Ø197 × 35 mm ([Ubiquiti spec](https://techspecs.ui.com/unifi/wifi/u6-pro)). The cradle is 198.6 mm across, so there's 0.8 mm of play all round. The rim is 7 mm tall.
- **U-PoE-AT:** 93 × 62 × 35 mm ([datasheet](https://dl.ui.com/ds/u-poe-at_ds.pdf)). The bay has 0.6 mm of play on each side and above. The UACC-PoE+-2.5G has the same published size.
- The pedestal is 205 mm across and 38 mm tall. The top of the AP ends up 78 mm above the rack top, which clears the 33 mm handles.
- **Check before printing:** the gap between the rack's two top handles must be at least 205 mm. I couldn't find a drawing of the RackMate T2's top, so this is not confirmed.
- **Not confirmed:** where the U6 Pro's Ethernet port sits on its back. The 50 mm centre hole assumes the port is in the middle, like the ceiling mount. If it's off-centre, change `center_hole_d` or move the hole.
- The AP sits in the cradle under its own weight (580 g). It isn't locked in. If you want it locked, measure the hole spacing on the steel mount plate that came with the AP and add bosses for it to the deck.

## Printing

Same material advice as the shelf: ABS or ASA (PETG is fine too). Use 0.2 mm layers, 3–4 walls and 15–20% infill. Each part is 205 mm across, so any bed of 210 mm or more works.

## Editing

Everything is in [`u6pro_top_mount.scad`](u6pro_top_mount.scad). The useful knobs are `ap_clear`, `inj_clear`, `rim_h`, `center_hole_d`, `notch_w` and `inj` (for a different injector). Run `./build.sh` to rebuild the STLs and images.
