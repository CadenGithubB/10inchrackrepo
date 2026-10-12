# Injector holster for the rear rails

Holds a U-PoE-AT PoE injector standing on end just in front of a rear rail, either way up: ports up with the power socket down, or the reverse. A flat plate bolts to the inside face of the rail with two rack screws, 1U apart. The injector slides in from the top. Side walls and front lips keep it from falling forward or sideways, and a shelf carries it on 5 mm ledges. The inside corners are rounded (7 mm) to follow the injector's rounded edges, and a 4 mm chamfer where the shelf meets the walls cups its rounded bottom edges, so it sits snug with no square corners to knock against. The window in the shelf is almost full width, about 53 × 30 mm, so the power plug or both RJ45 plugs can pass through it. The left and right versions are mirror images, so the two sides of the rack can match.

![Holsters with injectors](images/front.png)
![Empty holsters](images/empty.png)

## Parts

| File | Size (mm) | Notes |
|---|---|---|
| [`stl/holster_right.stl`](stl/holster_right.stl) | 88 × 43 × 98 | For the right rear rail (seen from the front). |
| [`stl/holster_left.stl`](stl/holster_left.stl) | 88 × 43 × 98 | Mirror image, for the left rear rail. |

Both print standing on the shelf end, as they are in the STL, with no supports. Only the short lip across the top front bridges.

Hardware: 2 rack screws per holster. The slots are 5.2 mm wide, which fits 10-32 or M5, and the rack kit's 10-32 screws should work. For M6, set `screw_d = 6.6`. The slots are 6 mm long vertically, so the holster can line up with any pair of holes 1U apart.

## Fit

- **Injector:** 62 × 35 × 93 mm with 0.6 mm of play ([datasheet](https://dl.ui.com/ds/u-poe-at_ds.pdf)). The UACC-PoE+-2.5G is the same size.
- **Footprint:** each holster sticks 43 mm forward from the rail face and reaches about 79 mm in from the rail hole. Gear in the same U's needs to end 45 mm or more short of the rear rails. The UCG Ultra and Flex Mini mounts are only 116–135 mm deep, so they leave plenty of room. The Mac shelf is 201.5 mm deep, so don't put a holster at its height.
- **Rear rail:** not measured yet. The plate assumes the rear rails have holes on a face that points into the rack, like the front rails.

## Editing

Everything is in [`injector_holster.scad`](injector_holster.scad). The most useful settings are `clear`, `screw_d`, `hole_gap_u`, `lip` and `power_win`. Run `./build.sh` to rebuild.
