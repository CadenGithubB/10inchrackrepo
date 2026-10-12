# ABS print order: U6 Pro riser + injector holsters

Upload the three STLs and order them together in the same ABS colour so they match. Units are millimetres, at 100% scale. Each part is already in print orientation and needs no supports.

| File | Qty | Size (mm) | Orientation |
|---|---|---|---|
| 01-AP-riser-PRINT-1.stl | 1 | 205 × 205 × 21 | Flat, ribs and tabs up |
| 02-injector-holster-LEFT-PRINT-1.stl | 1 | 89 × 67 × 98 | Standing on its shelf end |
| 03-injector-holster-RIGHT-PRINT-1.stl | 1 | 89 × 67 × 98 | Standing on its shelf end |

The left and right holsters are mirror images, so order one of each. They're L-shaped: the ear bolts to the back face of a rear rail and the injector sits inside the rack. The left one goes on the left rail as seen from the front.

**Before ordering the holsters:** they wrap round the rear rail, so they're sized for a rail about 20 mm deep with its inner edge about 10 mm from the hole centre. Measure the real rail first, and if it's different, change `rail_depth` and `rail_inner` in `injector_holster.scad` and re-export the holsters.

Suggested settings: ABS, 0.2 mm layers, 3–4 walls, 15–20% infill.

Every STL is a closed mesh: each edge belongs to exactly two triangles.

## Hardware (not printed)

- **AP riser:** 4 × M4 countersunk bolts about 40 mm long, and 4 × M4 nuts (nylon-insert).
- **AP riser fan:** one 120 × 25 mm fan with the standard 105 mm hole spacing. A 5 V USB fan is the easy option.
- **Holsters:** 2 rack screws each (10-32 or M5, from the rack kit).
