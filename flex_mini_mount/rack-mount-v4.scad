/*
 * V4 base: UniFi Flex Mini 2.5G + U-PoE-AT, 10-inch rack.
 * mm; installed X across, Y rearward, Z upward. PETG prototype.
 * Rounded front bezel, device positions, and front hoods match V3.
 * Separate keyed rear frame uses two M3 × 10, 90-degree countersunk screws
 * inserted from underneath into two standard M3 nuts held IN THE FRAME.
 * Screw heads sit flush with the underside. Three blind pockets locate keys.
 *
 * Default: base only, front down, 254 × 44 × 116 mm. Coupon: 254 × 44 × 20.
 * Review the small sideways screw holes and countersinks in your slicer.
 * A 256 mm bed leaves 1 mm per side: check usable area and brim placement.
 * Verify rack-hole column spacing (assumed 236.5 mm), case/port clearance,
 * and printed fit. Set print_orientation=false for an installed view.
 * Reference bodies are optional preview geometry and do not export.
 * Internal part="collision_check" should produce empty geometry.
 */

/* [Output] */
part = "onepiece"; // [onepiece,fitcoupon]
print_orientation = true;
show_device_envelopes = false;

/* [Rack face — verify your rack] */
panel_width = 254;
panel_height = 44;
panel_thickness = 4;
rack_hole_edge = 8.75;
rack_hole_z = [6.125, 37.875];
rack_slot_width = 10;
rack_slot_height = 7;

/* [Tray and outside walls] */
tray_left = 23;
tray_right = 231;
tray_front = 3;
tray_rear = 116;
floor_thickness = 4;
left_wall_thickness = 3;
right_wall_thickness = 2;
outer_wall_height = 14;
divider_left = 150;
divider_right = 157;
divider_height = 32;
guide_rear = 104.0;
gusset_front_height = 36;
gusset_rear = 55;
fit_coupon_depth = 20;

/* [Device envelopes and front capture] */
switch_size = [117.1, 90, 21.2];
switch_position = [29.45, 4.8, 4];
injector_size = [62, 93, 35];
injector_position = [162, 4.8, 4];
switch_front_stop_overlap = 4;
injector_front_stop_overlap = 5;
// Appearance-derived bezel corner radii; not factory CAD radii.
switch_window_corner_radii = [7.2, 5];
injector_window_corner_radii = [8, 8];
switch_front_vertical_overlap = 1;
injector_front_vertical_overlap = 2;
guide_clearance = 0.6;
guide_height = 14;
hood_clearance = 0.6;
hood_thickness = 3;
hood_case_overlap = 8;
hood_rear = 17;

/* [Blind rear-frame locating pockets] */
key_pocket_centers_x = [37.45, 138.55, 170];
key_pocket_width = 8.6;
key_pocket_front = 104.0;
key_pocket_rear = 108.6;
key_pocket_bottom = 0.9;
// Matching frame keys: width8, Y104.3..108.3, bottomZ1.2 (0.3 clearance).

/* [Underside M3 countersunk screws] */
screw_centers_x = [68, 180];
screw_axis_y = 103.7;
bolt_diameter = 3.4;
countersink_diameter = 6.4; // At Z0; 90-degree cone reaches diameter3.4 at Z1.5
// Matching retainer bosses are separate geometry; reserve solid floor below.
frame_boss_width = 9;
frame_boss_front = 99.5;
frame_boss_rear = 108.3;
vent_keepout_margin = 2;

/* [Ventilation] */
vent_width = 5;
vent_length = 14;
vent_pitch = 10;
vent_y_centers = [16, 52, 93];
switch_vent_field = [35, 140];
injector_vent_field = [169, 221];

/* [Hidden] */
$fn = 48;
epsilon = 0.01;
switch_bay_left = tray_left + left_wall_thickness;
injector_bay_right = tray_right - right_wall_thickness;
switch_right = switch_position[0] + switch_size[0];
injector_right = injector_position[0] + injector_size[0];
switch_top = switch_position[2] + switch_size[2];
injector_top = injector_position[2] + injector_size[2];
switch_rear = switch_position[1] + switch_size[1];
injector_rear = injector_position[1] + injector_size[1];
switch_window_left = switch_position[0] + switch_front_stop_overlap;
switch_window_right = switch_right - switch_front_stop_overlap;
injector_window_left = injector_position[0] + injector_front_stop_overlap;
injector_window_right = injector_right - injector_front_stop_overlap;
switch_window_bottom = switch_position[2] + switch_front_vertical_overlap;
injector_window_bottom = injector_position[2] + injector_front_vertical_overlap;
switch_window_height = switch_size[2] - 2*switch_front_vertical_overlap;
injector_window_height = injector_size[2] - 2*injector_front_vertical_overlap;
switch_guide_left = switch_position[0] - guide_clearance;
switch_guide_right = switch_right + guide_clearance;
injector_guide_left = injector_position[0] - guide_clearance;
injector_guide_right = injector_right + guide_clearance;
countersink_depth = (countersink_diameter-bolt_diameter)/2;

function hood_top(body_top) = body_top + hood_clearance + hood_thickness;

assert(part == "onepiece" || part == "fitcoupon" || part == "collision_check",
       "Output part must be onepiece, fitcoupon, or collision_check.");
assert(panel_width > 0 && panel_height > 0 && panel_thickness > 0 &&
       floor_thickness > 0 && left_wall_thickness > 0 && right_wall_thickness > 0,
       "Panel, floor, and wall dimensions must be positive.");
assert(rack_slot_width >= rack_slot_height && rack_slot_height > 0 &&
       rack_hole_edge > rack_slot_width/2 &&
       rack_hole_edge < panel_width/2-rack_slot_width/2,
       "Rack slots must fit within the face.");
for (z = rack_hole_z)
    assert(z > rack_slot_height/2 && z < panel_height-rack_slot_height/2,
           "Rack slot must remain inside the panel height.");
assert(tray_front < panel_thickness && tray_rear > panel_thickness &&
       tray_left >= 0 && tray_right <= panel_width && tray_left < tray_right &&
       guide_rear > max(switch_rear, injector_rear) && guide_rear < tray_rear,
       "Tray and guide ends must fit the devices and rack face.");
assert(switch_bay_left < switch_guide_left && switch_guide_right < divider_left &&
       divider_left < divider_right && divider_right < injector_guide_left &&
       injector_guide_right < injector_bay_right,
       "Case guides must leave usable wall thickness.");
assert(guide_clearance > 0 && hood_clearance > 0 &&
       hood_case_overlap > 0 && hood_case_overlap*2 < min(switch_size[0], injector_size[0]),
       "Front capture features need clearance and a central opening.");
assert(switch_front_stop_overlap > 0 && injector_front_stop_overlap > 0 &&
       switch_window_left < switch_window_right &&
       injector_window_left < injector_window_right,
       "Front lips must leave open apertures.");
assert(switch_front_vertical_overlap >= 0 && injector_front_vertical_overlap >= 0 &&
       switch_window_height > 0 && injector_window_height > 0 &&
       min(switch_window_corner_radii) > 0 && min(injector_window_corner_radii) > 0 &&
       2*switch_window_corner_radii[0] < switch_window_right-switch_window_left &&
       2*switch_window_corner_radii[1] < switch_window_height &&
       2*injector_window_corner_radii[0] < injector_window_right-injector_window_left &&
       2*injector_window_corner_radii[1] < injector_window_height,
       "Rounded bezel profiles must leave valid apertures.");
assert(panel_height > max(switch_window_bottom+switch_window_height,
                          injector_window_bottom+injector_window_height) &&
       hood_top(switch_top) <= panel_height && hood_top(injector_top) <= panel_height &&
       divider_height <= panel_height,
       "The bezel, hoods, and divider must fit within rack height.");
assert(switch_position[1] > panel_thickness+epsilon &&
       injector_position[1] > panel_thickness+epsilon &&
       switch_position[2] >= floor_thickness && injector_position[2] >= floor_thickness,
       "Front lips and floor must not intersect either device.");
assert(hood_rear > max(switch_position[1], injector_position[1]) &&
       hood_rear < min(switch_rear, injector_rear),
       "Front hoods must overlap the front portions of both cases.");
assert(key_pocket_width > 0 && key_pocket_front < key_pocket_rear &&
       key_pocket_bottom > 0 && key_pocket_bottom < floor_thickness &&
       key_pocket_rear < tray_rear,
       "Locating pockets must remain blind and inside the tray.");
assert(bolt_diameter > 2*epsilon && countersink_diameter > bolt_diameter &&
       countersink_depth < floor_thickness && frame_boss_width > countersink_diameter &&
       frame_boss_front > max(switch_rear, injector_rear) &&
       frame_boss_front < screw_axis_y-countersink_diameter/2 &&
       frame_boss_rear > screw_axis_y+countersink_diameter/2 &&
       frame_boss_rear+vent_keepout_margin < tray_rear,
       "Flush screw seats must remain within solid floor under the frame bosses.");
for (x = key_pocket_centers_x)
    assert(x-key_pocket_width/2-vent_keepout_margin > tray_left &&
           x+key_pocket_width/2+vent_keepout_margin < tray_right,
           "Locating-pocket foundations must fit within the tray.");
for (x = screw_centers_x)
    assert(x-frame_boss_width/2-vent_keepout_margin > tray_left &&
           x+frame_boss_width/2+vent_keepout_margin < tray_right,
           "Frame-boss foundations must fit within the tray.");
assert(gusset_front_height <= panel_height && gusset_front_height > outer_wall_height &&
       gusset_rear > tray_front && gusset_rear <= tray_rear &&
       fit_coupon_depth >= hood_rear && fit_coupon_depth < tray_rear,
       "Gussets and coupon must fit the tray and include the front hoods.");
assert(vent_width > 0 && vent_length > 0 && vent_pitch > vent_width &&
       vent_keepout_margin > 0, "Vent slots need material between them.");
for (y = vent_y_centers)
    assert(y-vent_length/2 > panel_thickness && y+vent_length/2 < tray_rear,
           "Vent slots must stay inside the tray.");

module rack_slot(x, z) {
    hull()
        for (dx = [-(rack_slot_width-rack_slot_height)/2,
                     (rack_slot_width-rack_slot_height)/2])
            translate([x+dx, -epsilon, z])
                rotate([-90, 0, 0])
                    cylinder(d=rack_slot_height, h=panel_thickness+2*epsilon);
}

module shaped_window(x0, x1, z0, height, radii) {
    translate([x0, panel_thickness+epsilon, z0])
        rotate([90, 0, 0])
            linear_extrude(height=panel_thickness+2*epsilon, convexity=4)
                hull()
                    for (x = [radii[0], x1-x0-radii[0]])
                        for (z = [radii[1], height-radii[1]])
                            translate([x, z]) scale(radii) circle(r=1, $fn=96);
}

module front_panel() {
    difference() {
        cube([panel_width, panel_thickness, panel_height]);
        shaped_window(switch_window_left, switch_window_right, switch_window_bottom,
                      switch_window_height, switch_window_corner_radii);
        shaped_window(injector_window_left, injector_window_right, injector_window_bottom,
                      injector_window_height, injector_window_corner_radii);
        for (x = [rack_hole_edge, panel_width-rack_hole_edge])
            for (z = rack_hole_z) rack_slot(x, z);
    }
}

module side_gusset(x, width) {
    translate([x, 0, 0])
        multmatrix([[0,0,1,0], [1,0,0,0], [0,1,0,0], [0,0,0,1]])
            linear_extrude(height=width)
                polygon([[tray_front, outer_wall_height],
                         [tray_front, gusset_front_height],
                         [gusset_rear, outer_wall_height]]);
}

module side_guide(x0, x1) {
    translate([x0, tray_front, 0])
        cube([x1-x0, guide_rear-tray_front, guide_height]);
}

module front_capture(position, size, left_outer, right_outer) {
    body_left = position[0];
    body_right = position[0]+size[0];
    body_top = position[2]+size[2];
    left_guide = body_left-guide_clearance;
    right_guide = body_right+guide_clearance;
    top = hood_top(body_top);
    // Tall columns remain outside the reference body, above the side guides.
    translate([left_outer, tray_front, 0])
        cube([left_guide-left_outer, hood_rear-tray_front, top]);
    translate([right_guide, tray_front, 0])
        cube([right_outer-right_guide, hood_rear-tray_front, top]);
    // Two roofs capture the upper front case corners.
    translate([left_guide, tray_front, body_top+hood_clearance])
        cube([guide_clearance+hood_case_overlap, hood_rear-tray_front, hood_thickness]);
    translate([body_right-hood_case_overlap, tray_front, body_top+hood_clearance])
        cube([hood_case_overlap+guide_clearance, hood_rear-tray_front, hood_thickness]);
}

module base_blank() {
    union() {
        front_panel();
        translate([tray_left, tray_front, 0])
            cube([tray_right-tray_left, tray_rear-tray_front, floor_thickness]);
        translate([tray_left, tray_front, 0])
            cube([left_wall_thickness, tray_rear-tray_front, outer_wall_height]);
        translate([injector_bay_right, tray_front, 0])
            cube([right_wall_thickness, tray_rear-tray_front, outer_wall_height]);
        translate([divider_left, tray_front, 0])
            cube([divider_right-divider_left, guide_rear-tray_front, divider_height]);
        side_gusset(tray_left, left_wall_thickness);
        side_gusset(injector_bay_right, right_wall_thickness);
        side_guide(switch_bay_left, switch_guide_left);
        side_guide(switch_guide_right, divider_left);
        side_guide(divider_right, injector_guide_left);
        side_guide(injector_guide_right, injector_bay_right);
        front_capture(switch_position, switch_size, switch_bay_left, divider_left);
        front_capture(injector_position, injector_size, divider_right, injector_bay_right);
    }
}

// Keepouts protect the floor around the key pockets and below frame bosses.
module hardware_floor_keepouts() {
    for (x = key_pocket_centers_x)
        translate([x-key_pocket_width/2-vent_keepout_margin,
                   key_pocket_front-vent_keepout_margin, -1])
            cube([key_pocket_width+2*vent_keepout_margin,
                  key_pocket_rear-key_pocket_front+2*vent_keepout_margin, floor_thickness+2]);
    for (x = screw_centers_x)
        translate([x-frame_boss_width/2-vent_keepout_margin,
                   frame_boss_front-vent_keepout_margin, -1])
            cube([frame_boss_width+2*vent_keepout_margin,
                  frame_boss_rear-frame_boss_front+2*vent_keepout_margin, floor_thickness+2]);
}

module ventilation_slots(field) {
    for (x = [field[0] : vent_pitch : field[1]-vent_width])
        for (y = vent_y_centers)
            difference() {
                translate([x, y-vent_length/2, -epsilon])
                    cube([vent_width, vent_length, floor_thickness+2*epsilon]);
                hardware_floor_keepouts();
            }
}

module rear_frame_pockets() {
    for (x = key_pocket_centers_x)
        translate([x-key_pocket_width/2, key_pocket_front, key_pocket_bottom])
            cube([key_pocket_width, key_pocket_rear-key_pocket_front,
                  floor_thickness-key_pocket_bottom+epsilon]);
}

module countersunk_screw_holes() {
    for (x = screw_centers_x) {
        translate([x, screw_axis_y, -epsilon])
            cylinder(d=bolt_diameter, h=floor_thickness+2*epsilon);
        // Extend the 90-degree cone past each Boolean boundary while keeping
        // its exact diameters at Z0 (6.4) and Z1.5 (3.4).
        translate([x, screw_axis_y, -epsilon])
            cylinder(d1=countersink_diameter+2*epsilon,
                     d2=bolt_diameter-2*epsilon, h=countersink_depth+2*epsilon);
    }
}

module mount() {
    difference() {
        base_blank();
        ventilation_slots(switch_vent_field);
        ventilation_slots(injector_vent_field);
        rear_frame_pockets();
        countersunk_screw_holes();
    }
}

module fit_coupon() {
    intersection() {
        mount();
        translate([-epsilon, -epsilon, -epsilon])
            cube([panel_width+2*epsilon, fit_coupon_depth+epsilon,
                  panel_height+2*epsilon]);
    }
}

module device_envelopes() {
    %color([0.82, 0.85, 0.9, 0.55])
        translate(switch_position) cube(switch_size);
    %color([0.2, 0.2, 0.24, 0.55])
        translate(injector_position) cube(injector_size);
}

// Inset nominal bodies exclude the coincident floor-contact plane.
module collision_check() {
    intersection() {
        mount();
        union() {
            translate(switch_position+[epsilon, epsilon, epsilon])
                cube(switch_size-[2*epsilon, 2*epsilon, 2*epsilon]);
            translate(injector_position+[epsilon, epsilon, epsilon])
                cube(injector_size-[2*epsilon, 2*epsilon, 2*epsilon]);
        }
    }
}

module selected_part() {
    if (part == "collision_check") collision_check();
    else if (part == "fitcoupon") fit_coupon();
    else color([0.2, 0.28, 0.37]) render(convexity=10) mount();
}

module output_orientation() {
    if (!print_orientation || part == "collision_check") children();
    else translate([0, panel_height, 0]) rotate([90, 0, 0]) children();
}

output_orientation() {
    selected_part();
    if (show_device_envelopes && part != "collision_check") device_envelopes();
}
