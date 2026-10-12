# Injector holster for the rear rails

An L-shaped holster that holds a U-PoE-AT PoE injector standing on end **inside** the rack, just in front of a rear rail. Its **ear** bolts to the back (outside) face of the rail with two rack screws, 1U apart. A side wall wraps round the rail's inner edge and carries the sleeve forward, into the rack.

The injector slides into the sleeve from the top, and either end can go down. Side walls and front lips keep it from falling forward or sideways. A shelf carries it on 5 mm ledges. The inside corners are rounded (7 mm) to follow the injector's rounded edges, and a 4 mm chamfer where the shelf meets the walls cups its bottom edges. The shelf window is about 53 × 30 mm, big enough for the power plug or both RJ45 plugs. For cooling, the back wall has two columns of vent slots and both side walls have a column each, all 5 mm tall at 9 mm spacing. Together with the open front between the lips and the open top, air can get at all sides of the injector.

The left and right versions are mirror images. The left holster goes on the left rail and the right one on the right, as seen from the front of the rack.

![Holsters with injectors, on a stand-in rail](images/front.png)
![Empty holsters](images/empty.png)

## Parts

| File | Size (mm) | Notes |
|---|---|---|
| [`stl/holster_right.stl`](stl/holster_right.stl) | 89 × 67 × 98 | For the right rear rail. |
| [`stl/holster_left.stl`](stl/holster_left.stl) | 89 × 67 × 98 | Mirror image, for the left rear rail. |

Both print standing on the shelf end, as they are in the STL, with no supports. Only the short lip across the top front bridges.

Hardware: 2 rack screws per holster, put in from behind through the ear. The slots match the front rack ears: 6.6 × 10 mm, running sideways, so they fit M6, M5 and 10-32 screws. The rack kit's 10-32 screws should work.

## Fit (check on the real rack)

- **Rail size:** the wrap-round assumes a rear rail about **20 mm deep** front to back (`rail_depth`), with its inner edge about **10 mm from the hole centre** (`rail_inner`). Both come from my stand-in rack, not a measurement. Measure the real rail and change these two numbers before printing. The holster has 0.5 mm of play round the rail.
- **Injector:** 62 × 35 × 93 mm with 0.6 mm of play ([datasheet](https://dl.ui.com/ds/u-poe-at_ds.pdf)). The UACC-PoE+-2.5G is the same size.
- **Space inside the rack:** the sleeve reaches about 43 mm forward of the rail's front face and about 80 mm in from the rail hole. Gear at the same height needs to end at least 45 mm short of the rear rails. The UCG Ultra and Flex Mini mounts are only 116–135 mm deep, so they leave plenty of room. The Mac shelf is 201.5 mm deep, so don't put a holster at its height.

## Editing

Everything is in [`injector_holster.scad`](injector_holster.scad). The settings you're most likely to change are `rail_depth`, `rail_inner`, `rail_outer`, `clear`, `screw_d`, `hole_gap_u`, `lip` and `power_win`. Run `./build.sh` to rebuild.
