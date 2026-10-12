/*
 * 1U mount for a UniFi Cloud Gateway Ultra (UCG-Ultra), 10-inch rack.
 * Same design language as the Flex Mini 2.5G mount (flex_mini_mount/):
 * flat 4 mm faceplate with the same ear slots, a rounded bezel window
 * that overlaps the gateway's front edge, front hoods over its top corners,
 * side guides, a vented tray and gussets. Meant for black ABS like the
 * other parts.
 *
 * Right of the gateway are three keystone cut-outs, so cables can come
 * out the front (standard snap-in keystone jacks; the faceplate is thinned
 * to 2 mm round each one so they clip in).
 *
 * The gateway goes in from the back: tip its front under the hoods, push
 * it against the bezel and lower the back onto the tray. Low stops at the
 * two back corners keep it from sliding back; its rear ports stay clear.
 * Two zip-tie slots let you strap it down if you want.
 *
 * mm; installed X across, Y rearward, Z upward.
 * Default output: front down (print orientation), 254 x 44 x 142 mm.
 * part = "fitcoupon" gives the front 20 mm to test the bezel, hoods and
 * keystones first.
 */

/* [Output] */
part = "onepiece"; // [onepiece,fitcoupon]
print_orientation = true;
show_device_envelope = false;

/* [Rack face - same as the Flex Mini mount] */
panel_width = 254;
panel_height = 44;
panel_thickness = 4;
rack_hole_edge = 8.75;
rack_hole_z = [6.125, 37.875];
rack_slot_width = 10;
rack_slot_height = 7;

/* [Gateway] */
ucg_size = [141.8, 127.6, 30];      // UCG-Ultra W x D x H (Ubiquiti spec)
foot_h = 4;                         // the gateway sits on corner feet this high,
                                    // leaving an air gap under it
ucg_position = [26.6, 4.8, 4 + foot_h];  // front-left-bottom corner
// front-edge rounding seen through the bezel (estimated from photos)
window_corner_radii = [12, 11];
front_stop_overlap = 4;             // bezel overlaps the face this much at the sides
front_vertical_overlap = 2;

/* [Tray] */
tray_left = 23;
tray_right = 231;
tray_front = 3;
floor_thickness = 4;
wall_thickness = 3;
outer_wall_height = 14;
guide_clearance = 0.6;
guide_height = 14;
hood_clearance = 0.6;
hood_thickness = 3;
hood_case_overlap = 8;
hood_rear = 17;
gusset_front_height = 36;
gusset_rear = 55;
rear_stop = [10, 6, 14];            // back-corner stops: W x D x H above the floor
fit_coupon_depth = 20;

/* [Keystones] */
keystone_x = [182, 200, 218];       // centres
keystone_z = 22;                    // centre height
keystone_cut = [14.9, 19.4];        // standard keystone panel cut-out
keystone_panel = 2;                 // face thickness the clips need
keystone_relief = [19, 26];         // thinned area behind each cut-out
keystone_bay_depth = 34;            // clear space kept behind the keystones

/* [Feet, side vents and fan] */
foot = [14, 14];                    // corner feet, X x Y
side_vent = [22, 7];                // windows in the side walls under the gateway: length x height
side_vent_y = [30, 62, 94];         // window starts along the depth
fan_size = 80;                      // optional fan hung under the tray (80 mm; 15 mm slim fits)
fan_hole_pitch = 71.5;              // 80 mm fan hole spacing
fan_center = [91.5, 60];            // nudged left so a 15 mm fan clears the Flex Mini retaining frame below
fan_opening_d = 76;
fan_bolt_d = 4.5;
fan_csk_d = 8.6;

/* [Ventilation and straps] */
vent_width = 5;
vent_length = 14;
vent_pitch = 10;
vent_y_centers = [22, 58, 94];
zip_slot = [3.5, 5];                // zip-tie slot W x L
zip_y = 112;

/* [Hidden] */
$fn = 48;
epsilon = 0.01;
ucg_right = ucg_position[0] + ucg_size[0];
ucg_top = ucg_position[2] + ucg_size[2];
ucg_rear = ucg_position[1] + ucg_size[1];
tray_rear = ucg_rear + rear_stop[1] + 3;
window_left = ucg_position[0] + front_stop_overlap;
window_right = ucg_right - front_stop_overlap;
window_bottom = ucg_position[2] + front_vertical_overlap;
window_height = ucg_size[2] - 2 * front_vertical_overlap;
guide_left = ucg_position[0] - guide_clearance;
guide_right = ucg_right + guide_clearance;
divider_left = guide_right;                  // wall between gateway and keystones
divider_right = divider_left + wall_thickness;
hood_top = ucg_top + hood_clearance + hood_thickness;

assert(guide_left > tray_left + wall_thickness - epsilon, "Gateway bay must fit inside the left wall");
assert(hood_top <= panel_height, "Hoods must fit inside 1U");
assert(keystone_x[0] - keystone_relief[0] / 2 > divider_right, "Keystones must clear the gateway bay");
assert(keystone_x[2] + keystone_relief[0] / 2 < tray_right, "Keystones must fit inside the tray");
echo(str("Print size ", panel_width, " x ", panel_height, " x ", tray_rear, " mm (front down)"));

module rack_slot(x, z) {
    hull()
        for (dx = [-(rack_slot_width - rack_slot_height) / 2, (rack_slot_width - rack_slot_height) / 2])
            translate([x + dx, -epsilon, z]) rotate([-90, 0, 0])
                cylinder(d = rack_slot_height, h = panel_thickness + 2 * epsilon);
}

module shaped_window(x0, x1, z0, height, radii) {
    translate([x0, panel_thickness + epsilon, z0]) rotate([90, 0, 0])
        linear_extrude(height = panel_thickness + 2 * epsilon, convexity = 4)
            hull() for (x = [radii[0], x1 - x0 - radii[0]], z = [radii[1], height - radii[1]])
                translate([x, z]) scale(radii) circle(r = 1, $fn = 96);
}

module keystone_cuts() {
    for (x = keystone_x) {
        // through cut-out
        translate([x - keystone_cut[0] / 2, -epsilon, keystone_z - keystone_cut[1] / 2])
            cube([keystone_cut[0], panel_thickness + 2 * epsilon, keystone_cut[1]]);
        // thin the face behind it so the keystone clips can grip
        translate([x - keystone_relief[0] / 2, keystone_panel, keystone_z - keystone_relief[1] / 2])
            cube([keystone_relief[0], panel_thickness, keystone_relief[1]]);
    }
}

module front_panel() {
    difference() {
        cube([panel_width, panel_thickness, panel_height]);
        shaped_window(window_left, window_right, window_bottom, window_height, window_corner_radii);
        keystone_cuts();
        for (x = [rack_hole_edge, panel_width - rack_hole_edge], z = rack_hole_z) rack_slot(x, z);
    }
}

module side_gusset(x, width) {
    translate([x, 0, 0])
        multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
            linear_extrude(height = width)
                polygon([[tray_front, outer_wall_height], [tray_front, gusset_front_height], [gusset_rear, outer_wall_height]]);
}

module front_capture() {
    // tall columns either side of the gateway, and roofs over its top front corners
    translate([tray_left, tray_front, 0]) cube([guide_left - tray_left, hood_rear - tray_front, hood_top]);
    translate([guide_right, tray_front, 0]) cube([divider_right - guide_right, hood_rear - tray_front, hood_top]);
    translate([guide_left, tray_front, ucg_top + hood_clearance])
        cube([guide_clearance + hood_case_overlap, hood_rear - tray_front, hood_thickness]);
    translate([ucg_right - hood_case_overlap, tray_front, ucg_top + hood_clearance])
        cube([hood_case_overlap + guide_clearance, hood_rear - tray_front, hood_thickness]);
}

module base_blank() {
    union() {
        front_panel();
        // tray floor
        translate([tray_left, tray_front, 0]) cube([tray_right - tray_left, tray_rear - tray_front, floor_thickness]);
        // outside walls
        translate([tray_left, tray_front, 0]) cube([wall_thickness, tray_rear - tray_front, outer_wall_height]);
        translate([tray_right - wall_thickness, tray_front, 0]) cube([wall_thickness, tray_rear - tray_front, outer_wall_height]);
        side_gusset(tray_left, wall_thickness);
        side_gusset(tray_right - wall_thickness, wall_thickness);
        // side guides along the gateway
        translate([tray_left + wall_thickness, tray_front, 0]) cube([guide_left - tray_left - wall_thickness, ucg_rear - tray_front, guide_height]);
        translate([guide_right, tray_front, 0]) cube([divider_right - guide_right, ucg_rear - tray_front, guide_height]);
        // divider up the keystone side, full height at the front for stiffness
        translate([divider_left, tray_front, 0]) cube([wall_thickness, keystone_bay_depth, panel_height - 6]);
        front_capture();
        // corner feet the gateway sits on
        for (x = [ucg_position[0], ucg_right - foot[0]], y = [ucg_position[1], ucg_rear - foot[1]])
            translate([x, y, 0]) cube([foot[0], foot[1], floor_thickness + foot_h]);
        // low stops behind the gateway's two back corners
        for (x = [ucg_position[0], ucg_right - rear_stop[0]])
            translate([x, ucg_rear + guide_clearance, 0]) cube([rear_stop[0], rear_stop[1], floor_thickness + rear_stop[2]]);
    }
}

fan_holes = [for (sx = [-1, 1], sy = [-1, 1]) fan_center + [sx, sy] * fan_hole_pitch / 2];

module vents() {
    // floor slots, kept off the feet and the fan's screw corners
    for (x = [ucg_position[0] + 8 : vent_pitch : ucg_right - 8 - vent_width], y = vent_y_centers)
        if (norm([x + vent_width / 2, y] - fan_center) > fan_opening_d / 2 + 3 &&
            min([for (h = fan_holes) norm([x + vent_width / 2, y] - h)]) > 10 &&
            (x > ucg_position[0] + foot[0] + 1 && x + vent_width < ucg_right - foot[0] - 1 ||
             (y - vent_length / 2 > ucg_position[1] + foot[1] + 1 && y + vent_length / 2 < ucg_rear - foot[1] - 1)))
            translate([x, y - vent_length / 2, -epsilon]) cube([vent_width, vent_length, floor_thickness + 2 * epsilon]);
    // round opening over the fan
    translate([fan_center[0], fan_center[1], -epsilon]) cylinder(d = fan_opening_d, h = floor_thickness + 2 * epsilon, $fn = 96);
    // fan screws, countersunk from the top so the heads sit flush under the gateway
    for (h = fan_holes) translate([h[0], h[1], 0]) {
        translate([0, 0, -epsilon]) cylinder(d = fan_bolt_d, h = floor_thickness + 2 * epsilon);
        translate([0, 0, floor_thickness - (fan_csk_d - fan_bolt_d) / 2]) cylinder(d1 = fan_bolt_d, d2 = fan_csk_d, h = (fan_csk_d - fan_bolt_d) / 2 + epsilon);
    }
    // windows in the side walls, under the gateway, so air can get out sideways
    for (y = side_vent_y, x = [tray_left - epsilon, guide_right - epsilon])
        translate([x, y, floor_thickness + 0.5]) cube([wall_thickness + 2 * epsilon, side_vent[0], side_vent[1]]);
}

module zip_slots() {
    // a pair either side of the gateway; thread a zip tie over the top
    for (x = [tray_left + wall_thickness + 0.2, guide_right + 0.2])
        translate([x - 0.2 + (x < ucg_position[0] ? 0 : 0), zip_y, -epsilon])
            cube([zip_slot[0] - 1, zip_slot[1], floor_thickness + 2 * epsilon]);
}

module mount() {
    difference() {
        base_blank();
        vents();
        zip_slots();
    }
}

module fit_coupon() {
    intersection() {
        mount();
        translate([-epsilon, -epsilon, -epsilon]) cube([panel_width + 2 * epsilon, fit_coupon_depth + epsilon, panel_height + 2 * epsilon]);
    }
}

module device_envelope() {
    %color([0.9, 0.9, 0.92, 0.5]) translate(ucg_position) cube(ucg_size);
}

module output_orientation() {
    if (!print_orientation) children();
    else translate([0, panel_height, 0]) rotate([90, 0, 0]) children();
}

output_orientation() {
    if (part == "fitcoupon") fit_coupon();
    else color([0.2, 0.2, 0.22]) render(convexity = 10) mount();
    if (show_device_envelope) device_envelope();
}
