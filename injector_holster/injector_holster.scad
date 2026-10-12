// =====================================================================
//  L-shaped PoE injector holster for the rear rails of a 10" rack
//  (DeskPi RackMate T2). Holds a U-PoE-AT standing on end inside the
//  rack, just in front of a rear rail, either end up.
//
//  The holster wraps round the rail like an L:
//    * an EAR on the back (outside) face of the rail takes two rack
//      screws, 1U apart,
//    * a side wall runs forward past the rail's inner edge,
//    * the SLEEVE sits inside the rack, in front of the rail, holding the
//      injector with its broad face towards the back of the rack.
//  Side walls and front lips (like the Flex Mini mount's hoods) stop the
//  injector falling forward or sideways; a shelf on 5 mm ledges carries
//  it. The shelf window is wide enough for the power plug or both RJ45
//  plugs, so it can go in either end down.
//
//      top view, right-hand rail (rack front is down the page)
//
//                          ear  ==o==   <- screw from behind
//                          |   [rail]
//               ___________|   [    ]
//              |  sleeve   |   [____]
//              |  [ inj ]  |
//              |_lip___lip_|
//
//  Coordinates (right-hand holster): origin at the rail hole centre on
//  the rail's back face. X = across the rack (+ outwards, towards the
//  side panel), Y = towards the back of the rack, Z = up.
//  Parts: assembly | right | left
// =====================================================================

/* [View] */
part = "assembly";   // [assembly, right, left]
show_device = true;

/* [Injector] */
inj = [62, 35, 93];  // U-PoE-AT on end: width (X), thickness (Y), length (Z)
clear = 0.6;

/* [Rail - VERIFY ON THE REAL RACK] */
U = 44.45;
rail_depth = 20;       // front-to-back thickness of the rear rail / post
rail_inner = 10.25;    // rail hole centre to the rail's inner (rack-centre) edge
rail_outer = 9.25;     // how far the ear reaches outwards past the hole
rail_clear = 0.5;      // play round the rail
screw_d = 6.6;         // same as the front rack ears: fits M6, M5 and 10-32
slot_len = 3.4;        // horizontal slots, 10 mm wide overall, like the front rack ears
hole_gap_u = 1;        // screws this many U apart (same hole in each U, so any pair works)

/* [Holster] */
plate_t = 4;           // ear thickness and the sleeve's back wall
wall = 3;
side_t = 5;            // the side wall that wraps round the rail (carries the load)
lip = 6;               // front lips overlap the injector face this much
lip_t = 2.5;
shelf_t = 4;
top_lip_h = 8;         // short lips at the top too, so it can't tip out
corner_r = 7;          // vertical corners of the cavity, following the injector's rounded edges
bottom_ch = 4;         // 45-degree chamfer where the shelf meets the walls
win_r = 5;             // rounded corners on the shelf window
ledge = 5;             // shelf ledge the injector rests on, each side
power_win = [inj[0] + 2 * clear - 2 * ledge, inj[1] + 2 * clear - 6];

$fn = 48;

cav = [inj[0] + 2 * clear, inj[1] + 2 * clear, inj[2] + clear];
plate_h = shelf_t + cav[2];
sleeve_w = wall + cav[0] + wall;
sleeve_d = plate_t + cav[1] + lip_t;
hole_z0 = plate_h / 2 - hole_gap_u * U / 2;   // the two screws, centred
x_in = -(rail_inner + rail_clear);            // inner face of the wrap-round wall
y_front = -(rail_depth + rail_clear);         // just in front of the rail
echo(str("Holster ", sleeve_w + side_t + rail_inner + rail_outer, " W x ",
         sleeve_d - y_front + plate_t, " D x ", plate_h, " H mm; screws ", hole_gap_u * U, " mm apart"));

module rrect(w, d, r, h) {
    hull() for (x = [r, w - r], y = [r, d - r]) translate([x, y, 0]) cylinder(r = r, h = h);
}

// The sleeve, built with its back wall on y = 0 and opening towards +y,
// x = 0 .. sleeve_w. Placed later, mirrored so it opens towards the rack front.
module sleeve() {
    difference() {
        union() {
            cube([sleeve_w, plate_t, plate_h]);                                   // back wall
            for (x = [0, wall + cav[0]]) translate([x, 0, 0]) cube([wall, sleeve_d, plate_h]);  // side walls
            translate([wall, plate_t, 0]) cube([cav[0], cav[1], plate_h]);       // fill, cavity cut back out
            cube([sleeve_w, sleeve_d, shelf_t]);                                  // shelf
            for (x = [wall, wall + cav[0] - lip])                                 // side lips
                translate([x, plate_t + cav[1], 0]) cube([lip, lip_t, plate_h]);
            translate([wall, plate_t + cav[1], 0]) cube([cav[0], lip_t, shelf_t + 10]);              // bottom lip
            translate([wall, plate_t + cav[1], plate_h - top_lip_h]) cube([cav[0], lip_t, top_lip_h]); // top lip
        }
        // cavity: rounded vertical corners, chamfered into the shelf
        translate([wall, plate_t, 0]) hull() {
            translate([0, 0, shelf_t + bottom_ch]) rrect(cav[0], cav[1], corner_r, cav[2] + 1);
            translate([bottom_ch, bottom_ch, shelf_t]) rrect(cav[0] - 2 * bottom_ch, cav[1] - 2 * bottom_ch, max(corner_r - bottom_ch, 1), 0.01);
        }
        // shelf window
        translate([wall + (cav[0] - power_win[0]) / 2, plate_t + (cav[1] - power_win[1]) / 2, -1])
            rrect(power_win[0], power_win[1], win_r, shelf_t + 2);
        // vents in the back wall
        for (z = [shelf_t + 12 : 14 : plate_h - 16])
            translate([wall + 10, -1, z]) cube([cav[0] - 20, plate_t + 2, 6]);
    }
}

module place_sleeve() {
    // sleeve's outer side wall flush with the wrap-round wall, back wall
    // just in front of the rail, opening towards the rack front
    translate([x_in - sleeve_w, y_front, 0]) mirror([0, 1, 0]) children();
}

module holster_right() {
    difference() {
        union() {
            place_sleeve() sleeve();
            // wrap-round wall along the rail's inner edge
            translate([x_in - side_t, y_front - plate_t, 0]) cube([side_t, -y_front + 2 * plate_t, plate_h]);
            // ear on the back face of the rail
            translate([x_in - side_t, 0, 0]) cube([side_t - x_in + rail_outer, plate_t, plate_h]);
        }
        // screw slots through the ear
        for (k = [0, 1]) translate([0, plate_t + 1, hole_z0 + k * hole_gap_u * U]) rotate([90, 0, 0])
            hull() for (dx = [-slot_len / 2, slot_len / 2]) translate([dx, 0, 0]) cylinder(d = screw_d, h = plate_t + 2);
    }
}

module holster(side = "right") {
    if (side == "right") holster_right();
    else mirror([1, 0, 0]) holster_right();
}

module injector(side = "right") {
    module inj_right() place_sleeve() {
        color("Gainsboro") translate([wall + clear, plate_t + clear, shelf_t]) cube(inj);
        color("#2b3036") for (dx = [inj[0] / 2 - 12, inj[0] / 2 + 12])
            translate([wall + clear + dx - 7, plate_t + clear + inj[1] / 2 - 6, shelf_t + inj[2] - 0.5]) cube([14, 12, 1]);
    }
    if (side == "right") inj_right(); else mirror([1, 0, 0]) inj_right();
}

module rail_stub() {   // preview only
    color("#1b1e21", 0.6) translate([-rail_inner, -rail_depth, -10]) cube([rail_inner + rail_outer + 2, rail_depth, plate_h + 20]);
}

// print orientation: standing on the shelf as shown, no supports
// (only the top front lip bridges across)
if (part == "right") holster("right");
else if (part == "left") holster("left");
else {
    color("#2f3337") holster("right");
    rail_stub();
    if (show_device) injector("right");
    translate([-220, 0, 0]) {
        color("#2f3337") holster("left");
        mirror([1, 0, 0]) rail_stub();
        if (show_device) injector("left");
    }
}
