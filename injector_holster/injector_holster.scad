// =====================================================================
//  Vertical PoE injector holster for the rear rails of a 10" rack
//  (DeskPi RackMate T2). Holds a U-PoE-AT standing on end, ports up,
//  power socket down, just in front of a rear rail.
//
//  A flat plate bolts to the inside (front-facing) face of a rear rail
//  with two rack screws, 1U apart. A sleeve on the plate holds the
//  injector with its broad face against the plate:
//    * side walls and front lips (like the Flex Mini mount's hoods)
//      stop it falling forward or sideways,
//    * a bottom shelf with a window for the C6 power plug carries it,
//    * the top is open for the RJ45 plugs.
//  Slide the injector in from the top. Left and right are mirror
//  images, so both sides of the rack can match.
//
//      view from the front of the rack (right-hand holster)
//                 ports up
//              |  [====]  |  ||   <- rear rail
//              |  [    ]  |==o|      rack screw
//              |  [inj ]  |  ||
//              |  [    ]  |==o|      rack screw, 1U lower
//              |__[====]__|  ||
//                 power down
//
//  Coordinates: X = across the rack (+ towards the right rail),
//  Y = towards the front of the rack (0 = rail face), Z = up
//  (0 = bottom of the holster).
//  Parts: assembly | right | left
// =====================================================================

/* [View] */
part = "assembly";   // [assembly, right, left]
show_device = true;

/* [Injector] */
inj = [62, 35, 93];  // U-PoE-AT on end: width (X), thickness (Y), length (Z)
clear = 0.6;

/* [Rail] */
U = 44.45;
hole_inset = 9.25;     // rail hole centre in from the plate's outer edge
screw_d = 5.2;         // 10-32 / M5 clearance (M6: 6.6)
slot_len = 6;          // vertical slots, so the plate lines up with any hole pair
hole_gap_u = 1;        // screws this many U apart (same hole in each U, so any pair works)

/* [Holster] */
plate_t = 4;
wall = 3;
lip = 6;               // front lips overlap the injector face this much
lip_t = 2.5;
shelf_t = 4;
top_lip_h = 8;         // short lips at the top too, so it can't tip out
power_win = [34, 14];  // window in the shelf for the C6 plug (width, depth)

$fn = 48;

cav = [inj[0] + 2 * clear, inj[1] + 2 * clear, inj[2] + clear];
// plate: covers the sleeve plus a strip over the rail with the screw slots
strip_w = 2 * hole_inset;
plate_w = wall + cav[0] + wall + strip_w;
plate_h = shelf_t + cav[2];
hole_z0 = plate_h / 2 - hole_gap_u * U / 2;   // the two screws, centred
echo(str("Holster ", plate_w, " W x ", plate_t + cav[1] + lip_t, " D x ", plate_h,
         " H mm; screws ", hole_gap_u * U, " mm apart"));

module slot(x, z) {
    translate([x, plate_t + 1, z]) rotate([90, 0, 0])
        hull() for (dz = [-slot_len / 2, slot_len / 2]) translate([0, dz, 0]) cylinder(d = screw_d, h = plate_t + 2);
}

// right-hand holster: rail strip on the +X side
module holster_right() {
    x_cav = wall;                          // cavity starts after the left wall
    x_strip = wall + cav[0] + wall;        // rail strip
    difference() {
        union() {
            // back plate against the rail face
            cube([plate_w, plate_t, plate_h]);
            // side walls
            for (x = [0, wall + cav[0]])
                translate([x, 0, 0]) cube([wall, plate_t + cav[1] + lip_t, plate_h]);
            // bottom shelf
            cube([wall + cav[0] + wall, plate_t + cav[1] + lip_t, shelf_t]);
            // full-height front lips down both sides
            for (x = [wall, wall + cav[0] - lip])
                translate([x, plate_t + cav[1], 0]) cube([lip, lip_t, plate_h]);
            // short lips across the bottom and top of the front face
            translate([wall, plate_t + cav[1], 0]) cube([cav[0], lip_t, shelf_t + 10]);
            translate([wall, plate_t + cav[1], plate_h - top_lip_h]) cube([cav[0], lip_t, top_lip_h]);
            // gusset tying the rail strip to the sleeve
            translate([x_strip - 0.01, 0, 0]) cube([strip_w, plate_t + 3, plate_h]);
        }
        // injector cavity
        translate([x_cav, plate_t, shelf_t]) cube([cav[0], cav[1], cav[2] + 1]);
        // power plug window in the shelf, under the C6 socket
        translate([x_cav + (cav[0] - power_win[0]) / 2, plate_t + (cav[1] - power_win[1]) / 2, -1])
            cube([power_win[0], power_win[1], shelf_t + 2]);
        // screw slots in the rail strip
        for (k = [0, 1]) slot(x_strip + strip_w / 2, hole_z0 + k * hole_gap_u * U);
        // vents in the back plate behind the injector
        for (z = [shelf_t + 12 : 14 : plate_h - 16])
            translate([x_cav + 10, -1, z]) cube([cav[0] - 20, plate_t + 2, 6]);
    }
}

module holster(side = "right") {
    if (side == "right") holster_right();
    else translate([plate_w, 0, 0]) mirror([1, 0, 0]) holster_right();
}

module injector(side = "right") {
    x = side == "right" ? wall + clear : strip_w + wall + clear;
    color("Gainsboro") translate([x, plate_t + clear, shelf_t]) cube(inj);
    // RJ45 ports on the top end
    color("#2b3036") for (dx = [inj[0] / 2 - 12, inj[0] / 2 + 12])
        translate([x + dx - 7, plate_t + clear + inj[1] / 2 - 6, shelf_t + inj[2] - 0.5]) cube([14, 12, 1]);
}

// print orientation: standing on the shelf as shown, no supports
// (only the top front lip bridges across)
if (part == "right") holster("right");
else if (part == "left") holster("left");
else {
    color("#2f3337") holster("right");
    if (show_device) injector("right");
    translate([-plate_w - 40, 0, 0]) {
        color("#2f3337") holster("left");
        if (show_device) injector("left");
    }
}
