# V4 rack mount with slotted retaining frame

Order **one of each of the two STL files**, in millimeters at 100% scale.
Use these as a matching pair. This frame does not fit the older V3 base.
The OpenSCAD sources are included for editing; no Blender model is involved.

| File | Quantity | Supplied print dimensions |
|---|---:|---:|
| 01-main-mount-PRINT-1.stl | 1 | 254 × 44 × 116 mm |
| 02-retaining-frame-PRINT-1.stl | 1 | 154.55 × 42.4 × 22.9 mm |

The assembled envelope is 254 mm wide × 116 mm deep × 44 mm high.
The front mounting-hole columns assume 236.5 mm spacing; verify your rack.
A nominal 256 mm printer bed leaves only 1 mm on each side of the faceplate.

## What changed

Three downward tabs seat in blind slots in the tray. Two flush underside
screws clamp the frame to the tray and prevent it lifting out. The previous
rear feet and projecting crossbar are gone; the frame ends at Y108.3, inside
the tray's Y116 rear edge. The front bezel and front case captures are unchanged.

The frame is one functional part and remains connected after assembly.
Do not order any of the old separate clips, and do not cut the connecting member.

## Device positions and capture

Coordinates below are in millimeters, measured from the outer front face
of the rack panel (Y0) and the bottom of the tray (Z0).

| Device | Body W × D × H | Body rear | Rear stop | Body top | Roof underside |
|---|---|---:|---:|---:|---:|
| USW-Flex-2.5G-5 | 117.1 × 90 × 21.2 | 94.8 | 95.4 | 25.2 | 25.8 |
| U-PoE-AT | 62 × 93 × 35 | 97.8 | 98.4 | 39.0 | 39.6 |

Both bodies start at Y4.8 and rest on the Z4 floor. The injector stop is
3 mm farther back and its roof 13.8 mm higher. Each case has 0.6 mm nominal
clearance behind and above it. Each rear roof overlaps its nominal case by
9.4 mm. Two fingers capture the switch; one wider finger captures the left
rear edge of the injector, leaving the right rear connector region open.

This is positive capture with clearance, not a zero-play friction clamp.
The front bezel ends at Y4, so total fore/aft case clearance between the
front and rear stops is nominally 1.4 mm. The locating tabs have 0.3 mm
clearance per side and underneath. Printed tolerances add to these values.
If needed after a fit check, thin compressible pads can take up remaining
case play without forcing the devices against the retaining roofs.

Official nominal dimensions:
- Switch: https://techspecs.ui.com/unifi/switching/usw-flex-2-5g-5
- Injector: https://dl.ui.com/ds/u-poe-at_ds.pdf

The corner profiles are appearance-based estimates, not manufacturer CAD.
Verify actual ports, plug boots, rounded case corners, rack spacing and fit
before buying a final service print.

## Hardware and assembly

- Two M3 × 10 mm machine screws, **90-degree countersunk/flat heads**.
  Length includes the head. Check that head diameter fits the 6.4 mm seats;
  a nominal 6 mm head is used in the digital clearance check.
- Two ordinary M3 hex nuts, nominal 5.5 mm across flats × 2.4 mm thick.
  Do not substitute thicker locknuts without checking the nut pockets.

1. Slide one nut into each front-opening pocket in the retaining frame.
   Orient the nut flats parallel to the slot sides. Align their holes with
   the frame holes; the slot walls prevent rotation during tightening.
2. Insert the devices from the rear under their front capture roofs.
3. Lower the frame vertically with its three tabs aligned to the tray slots.
   Its shoulders and the two screw bosses seat on the tray floor.
4. Insert the screws from underneath into the captive nuts. Tighten gently
   until the frame seats; avoid crushing the plastic or forcing case contact.
   Check that both heads sit flush or slightly recessed below the tray.
5. Mount the assembly in the rack and confirm retention during cable use.
   Remove the assembly from the rack if underside access is needed later.

The screws sit at X68 and X180, both Y103.7. They lock the frame; the three
keys carry locating loads through the tray slots. Remove both screws to
lift the complete frame and release either device.

## Print orientation and cost

The tray is supplied front-face-down. The frame is supplied flat-rear-face-down.
Its retaining fingers grow directly from the print bed, its nut pockets open
toward the top of the print, and its screw bores use 45-degree teardrop closures.
It is designed to avoid support beneath the retaining fingers in this orientation.

Ask the provider to review the process and orientation. The base has small
sideways screw holes/countersinks and three blind-pocket closing bridges
(8.6 mm wide over a 3.1 mm recess) that need slicer review. No physical print,
strength test or fit test has been performed. Use a structural print profile
suitable for a cantilevered rack tray, rather than choosing infill on price alone.

This change simplifies FDM geometry; **a lower quote is not confirmed**.
Compared with the old single bar, the new frame's print height is 22.9 mm
instead of 38.6 mm, but its solid CAD volume is 18.122 cm³ instead of
15.641 cm³ (about 16% more). Powder-bed services such as SLS do not need
the FDM support structures, so this orientation change may not save money there.
Compare the total quote for both matching parts, including shipping.

## Validation included

Both final STLs were compiled with OpenSCAD 2026.10.08 / Manifold and checked
as single, closed, consistently wound meshes with no degenerate triangles.
Checks of the exported STLs found no interference with nominal device bodies,
between the base and frame at installed position or sampled vertical insertion
heights (1, 5 and 11 mm), or with nominal screw/nut envelopes. Intentional
floor-contact surfaces are excluded from the base/frame intersection check.
Mesh dimensions, source hashes and exported retaining planes are recorded in
mesh-validation.json. These checks do not establish physical fit or load capacity.

assembly-check.scad is a preview/check scene that imports the two final STLs.
It is not a third part to order. Set print_orientation=false in either source
to inspect its installed coordinates in OpenSCAD.
