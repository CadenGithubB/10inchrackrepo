/*
 * V4 keyed rear retaining frame — Flex Mini 2.5G + U-PoE-AT rack mount.
 * Units: millimeters. Installed axes: X across, Y rearward, Z upward.
 * Use ONLY with the matching V4 slotted base; this is not a V3 drop-in part.
 *
 * PRINT: default output places the common rear face on the print bed.
 * Nominal print bounds: 154.55 X x 42.4 Y x 22.9 Z mm.
 * All retaining fingers grow from that rear face. No separate rear feet or
 * external joining lip are present. Export one copy of this entire frame.
 *
 * ASSEMBLY: insert two standard M3 nuts into the frame's front-loading slots.
 * Slide both devices against the front bezel and lower the frame's three
 * locating tabs into the matching tray slots. Install two M3 x 10, 90-degree
 * countersunk screws from underneath the matching V4 base into the nuts.
 * The flush screw heads preserve the rack height. Do not substitute a loose
 * friction fit for the screws: they lock the frame against lifting. The tabs
 * locate the frame and resist sideways movement. Underside access is needed.
 *
 * The switch stop is 3 mm forward of the injector stop, accounting for their
 * nominal 90 mm and 93 mm depths. Their top retaining surfaces differ by
 * 13.8 mm, accounting for their nominal 21.2 mm and 35 mm body heights.
 * Clearance behind and above each nominal case is 0.6 mm. The injector's
 * retainer remains on its left rear edge to leave the right rear IEC socket
 * region open. Check the actual case, connector and cable boot clearances.
 *
 * PROTOTYPE: nominal dimensions and geometry have not been physically tested.
 * This revision simplifies print orientation; it does not guarantee a lower
 * service quote. Use a fit check before ordering a final service print.
 */

/* [Output] */
print_orientation = true;

/* [Nominal device envelopes — synchronized with the V4 base] */
switch_size = [117.1, 90, 21.2];
switch_position = [29.45, 4.8, 4];
injector_size = [62, 93, 35];
injector_position = [162, 4.8, 4];
case_clearance = 0.6;

/* [Frame] */
rear_plane = 108.3;
upright_bottom = 4;
roof_thickness = 4;
roof_forward_overlap = 10;
switch_upright_x = [31.45, 132.55];
switch_upright_width = 12;
injector_upright_x = 162;
injector_upright_width = 24;
crossmember_front = 104.3;
crossmember_bottom = 7.8;
crossmember_top = 14.2;

/* [Locating tabs] */
tab_centers_x = [37.45, 138.55, 170];
tab_width = 8;
tab_front = 104.3;
tab_bottom = 1.2;
tab_top = 4.4;

/* [Two underside-access M3 locks] */
lock_centers_x = [68, 180];
lock_y = 103.7;
lock_diameter = 3.4;
lock_boss_width = 9;
lock_boss_front = 99.5;
lock_boss_bottom = 4;
lock_boss_top = 14.2;
nut_slot_width = 5.8; // Across X; captures nominal 5.5 mm nut flats
nut_slot_front = 97.9; // Opens through the injector upright's Y98.4 front
nut_slot_rear = 107.1; // Leaves a 1.2 mm wall at the common rear face
nut_slot_bottom = 7;
nut_slot_top = 9.6;

/* [Hidden] */
$fn = 48;
epsilon = 0.01;
frame_left = switch_upright_x[0];
frame_right = injector_upright_x + injector_upright_width;
switch_stop_y = switch_position[1] + switch_size[1] + case_clearance;
injector_stop_y = injector_position[1] + injector_size[1] + case_clearance;
switch_roof_bottom = switch_position[2] + switch_size[2] + case_clearance;
injector_roof_bottom = injector_position[2] + injector_size[2] + case_clearance;
switch_roof_top = switch_roof_bottom + roof_thickness;
injector_roof_top = injector_roof_bottom + roof_thickness;
frontmost_y = min(switch_stop_y, injector_stop_y) - roof_forward_overlap;
switch_window_x_inset = 3;
switch_window_bottom = 14;
switch_window_top = 21.8;
injector_window_x_inset = 4;
injector_window_bottom = 16;
injector_window_top = 36;

assert(case_clearance > 0 && roof_thickness > 0 &&
       roof_forward_overlap > case_clearance,
       "Positive clearance and positive roof overlap are required.");
assert(switch_stop_y < injector_stop_y && injector_stop_y < rear_plane &&
       switch_roof_bottom < injector_roof_bottom && injector_roof_top <= 44,
       "Both stop depths and capture heights must fit inside 1U.");
assert(crossmember_front < rear_plane && crossmember_bottom < crossmember_top &&
       crossmember_bottom >= upright_bottom &&
       crossmember_top < switch_roof_bottom,
       "The lower connecting member must remain below the capture roofs.");
assert(tab_width > 0 && tab_front < rear_plane &&
       tab_bottom >= 0 && tab_bottom < upright_bottom && tab_top > upright_bottom,
       "Locating tabs must extend into the tray and overlap the uprights.");
assert(switch_window_x_inset > 0 &&
       2*switch_window_x_inset < switch_upright_width &&
       switch_window_bottom > upright_bottom &&
       switch_window_top < switch_roof_bottom &&
       injector_window_x_inset > 0 &&
       2*injector_window_x_inset < injector_upright_width &&
       injector_window_bottom > upright_bottom &&
       injector_window_top < injector_roof_bottom,
       "Lightening windows must preserve solid frame edges.");
assert(lock_diameter > 0 &&
       lock_boss_front < crossmember_front && lock_boss_front < lock_y &&
       lock_y-lock_diameter/sqrt(2) > lock_boss_front &&
       lock_y+lock_diameter/2 < rear_plane &&
       lock_boss_bottom == upright_bottom && lock_boss_top >= crossmember_top,
       "Vertical lock holes and their teardrop tips must fit the bosses.");
assert(nut_slot_width > 5.5 && nut_slot_width < 5.5/cos(30) &&
       nut_slot_width < lock_boss_width &&
       nut_slot_front < min(lock_boss_front, injector_stop_y) &&
       nut_slot_rear < rear_plane &&
       nut_slot_bottom > lock_boss_bottom &&
       nut_slot_top < lock_boss_top && nut_slot_top-nut_slot_bottom >= 2.4 &&
       lock_y+5.5/sqrt(3) < nut_slot_rear &&
       lock_y-5.5/sqrt(3) > lock_boss_front,
       "Front-loading nut slots must fit standard M3 nuts and retain their flats.");
for (x = lock_centers_x)
    assert(x-lock_boss_width/2 > frame_left &&
           x+lock_boss_width/2 < frame_right,
           "Lock bosses must stay within the frame span.");
for (i = [0:2]) {
    u_x = i < 2 ? switch_upright_x[i] : injector_upright_x;
    u_width = i < 2 ? switch_upright_width : injector_upright_width;
    assert(tab_centers_x[i]-tab_width/2 >= u_x &&
           tab_centers_x[i]+tab_width/2 <= u_x+u_width,
           "Each locating tab must be attached beneath an upright.");
}

module upright(x, width, stop_y, roof_bottom) {
    // Both prisms terminate at the common rear printing plane.
    translate([x, stop_y, upright_bottom])
        cube([width, rear_plane-stop_y,
              roof_bottom+roof_thickness-upright_bottom]);
    translate([x, stop_y-roof_forward_overlap, roof_bottom])
        cube([width, rear_plane-stop_y+roof_forward_overlap, roof_thickness]);
}

module frame_blank() {
    union() {
        for (x = switch_upright_x)
            upright(x, switch_upright_width, switch_stop_y, switch_roof_bottom);
        upright(injector_upright_x, injector_upright_width,
                injector_stop_y, injector_roof_bottom);
        translate([frame_left, crossmember_front, crossmember_bottom])
            cube([frame_right-frame_left, rear_plane-crossmember_front,
                  crossmember_top-crossmember_bottom]);
        for (x = tab_centers_x)
            translate([x-tab_width/2, tab_front, tab_bottom])
                cube([tab_width, rear_plane-tab_front, tab_top-tab_bottom]);
        for (x = lock_centers_x)
            translate([x-lock_boss_width/2, lock_boss_front, lock_boss_bottom])
                cube([lock_boss_width, rear_plane-lock_boss_front,
                      lock_boss_top-lock_boss_bottom]);
    }
}

module lightening_windows() {
    for (x = switch_upright_x)
        translate([x+switch_window_x_inset, frontmost_y-epsilon,
                   switch_window_bottom])
            cube([switch_upright_width-2*switch_window_x_inset,
                  rear_plane-frontmost_y+2*epsilon,
                  switch_window_top-switch_window_bottom]);
    translate([injector_upright_x+injector_window_x_inset,
               frontmost_y-epsilon, injector_window_bottom])
        cube([injector_upright_width-2*injector_window_x_inset,
              rear_plane-frontmost_y+2*epsilon,
              injector_window_top-injector_window_bottom]);
}

module nut_slots() {
    for (x = lock_centers_x)
        translate([x-nut_slot_width/2, nut_slot_front, nut_slot_bottom])
            cube([nut_slot_width, nut_slot_rear-nut_slot_front,
                  nut_slot_top-nut_slot_bottom]);
}

// The circular screw clearance has a 45-degree apex toward the front (-Y).
// This points upward in the rear-face-down print orientation.
module front_pointing_teardrop(diameter) {
    radius = diameter/2;
    tangent = radius/sqrt(2);
    union() {
        circle(r=radius);
        polygon([[-tangent, -tangent], [tangent, -tangent],
                 [0, -radius*sqrt(2)]]);
    }
}

module lock_holes() {
    for (x = lock_centers_x)
        translate([x, lock_y, lock_boss_bottom-epsilon])
            linear_extrude(height=lock_boss_top-lock_boss_bottom+2*epsilon)
                front_pointing_teardrop(lock_diameter);
}

module retaining_frame() {
    difference() {
        frame_blank();
        lightening_windows();
        nut_slots();
        lock_holes();
    }
}

/*
 * PRINTABILITY INVARIANT
 * Before subtraction, every occupied XZ column is a single Y interval ending
 * at rear_plane. Lightening windows remove whole columns. The front-loading
 * nut slots trim the forward ends of columns, leaving their roofs supported
 * from the common rear printing face. Roof fingers and tabs have a direct
 * path to the print bed, without a suspended start.
 *
 * The vertical screw holes are horizontal during printing. Their forward
 * teardrop apex closes at 45 degrees, avoiding a flat bridge across each bore.
 * These bores mean the complete layer footprints are not strictly nested;
 * their small closing walls use the 45-degree slope instead. This geometric
 * assessment does not substitute for a slicer/process review or a fit test.
 */
if (print_orientation)
    translate([-frame_left, -tab_bottom, rear_plane])
        rotate([-90, 0, 0]) retaining_frame();
else
    retaining_frame();
