// =====================================================================
//  UniFi U6 Pro low riser for the top of a 10" rack
//  (DeskPi RackMate T2, on its vented acrylic top cover)
//
//  A flat ring the AP rests on, 10 mm above the cover. A 120 mm fan is
//  bolted UNDER the cover, inside the rack, blowing up through the
//  cover's vents. The same 4 M4 bolts go down through this ring, the
//  acrylic and the fan's corner holes, so one set of bolts holds both.
//  Air comes up through the open middle, hits the back of the AP and
//  leaves sideways between the ribs and tabs.
//
//      side view
//           ________________
//          /     U6 Pro     \
//    <--  |_|==============|_|  -->   10 mm air gap, ribs hold the AP
//    =====[ring]=====[ring]=====      acrylic top cover
//             [ 120 fan ]             inside the rack, blowing up
//
//  The PoE cable comes in from the front, between two ribs.
//  Coordinates: origin = centre on the top surface of the cover,
//  X = left/right, Y = front(-)/back(+), Z = up.
//
//  Parts: assembly | riser | tabs (preview colour only) | fan | ap
// =====================================================================

/* [View] */
part = "assembly";      // [assembly, riser, tabs, fan, ap]
show_devices = true;

/* [Devices] */
ap_d   = 197;           // U6 Pro diameter (Ubiquiti spec)
ap_h   = 35;
fan_size = 120;
fan_thick = 25;         // 15 for a slim fan if the space under the cover is tight
fan_hole_pitch = 105;
cover_t = 3;            // acrylic top cover thickness (estimate; preview only)

/* [Rack] */
handle_gap = 239;       // measured inside gap between the rack's two top handles

/* [Riser] */
ap_clear = 0.8;         // radial play around the AP inside the tabs
plate_t  = 3;           // height of the web that sits on the cover
outer_w  = 8;           // outer ring width (under the tabs)
inner_w  = 4;           // inner ring width (round the open middle)
pad_d    = 14;          // bolt pads
inner_set = true;       // add the second set of bolt holes nearer the middle
inner_pitch = 71.5;     // 80 mm fan hole spacing
solid_plate = false;    // true = the old solid ring plate
air_gap  = 10;          // AP rests this far above the ring
open_d   = 118;         // open middle over the fan
rim_t    = 3.2;         // tab thickness
tab_n    = 6;
tab_w    = 14;
tab_up   = 8;           // how far the tabs reach up the side of the AP
rib_w    = 4;
rib_step = 30;          // a rib every 30 degrees ...
cable_gap_a = -1;       // ... except at this angle (-1 = none; the cable fits between ribs)

/* [Hardware] */
bolt_d   = 4.5;         // M4 clearance
csk_d    = 8.6;         // M4 countersunk head

$fn = 96;
eps = 0.01;

pocket_d = ap_d + 2 * ap_clear;
ring_d   = pocket_d + 2 * rim_t;
fan_holes = [for (sx = [-1, 1], sy = [-1, 1]) [sx, sy] * fan_hole_pitch / 2];
// second, inner set: an 80 mm fan's 71.5 mm square, turned 45 degrees so the
// holes land at different spots on the cover than the outer set
inner_r = inner_pitch / sqrt(2);
inner_holes = inner_set ? [for (a = [0 : 90 : 270]) inner_r * [cos(a), sin(a)]] : [];
all_holes = concat(fan_holes, inner_holes);
tab_angles = [for (i = [0 : tab_n - 1]) i * 360 / tab_n];
rib_angles = [for (a = [0 : rib_step : 359]) if (a != cable_gap_a) a];

assert(ring_d < handle_gap, "Riser won't fit between the handles");
echo(str("Ring ", ring_d, " mm across; AP top ", plate_t + air_gap + ap_h,
         " mm above the cover; bolt length about ", plate_t + cover_t + fan_thick + 4, " mm + nut"));

module annulus(d_out, d_in, h) {
    difference() { cylinder(d = d_out, h = h); translate([0, 0, -1]) cylinder(d = d_in, h = h + 2); }
}

// Open web on the cover: an outer ring, an inner ring and the ribs,
// with pads and short spokes for the 4 bolts. Everything between is
// open, so the cover's vents under the ring can breathe too.
module ring_plate() {
    if (solid_plate) annulus(ring_d, open_d, plate_t);
    else {
        annulus(ring_d, ring_d - 2 * outer_w, plate_t);
        annulus(open_d + 2 * inner_w, open_d, plate_t);
        // inner pads, each tied out to the inner ring
        for (p = inner_holes) {
            translate([p[0], p[1], 0]) cylinder(d = pad_d, h = plate_t);
            rotate(atan2(p[1], p[0])) translate([inner_r, -rib_w / 2, 0]) cube([open_d / 2 + inner_w / 2 - inner_r, rib_w, plate_t]);
        }
        for (p = fan_holes) {
            translate([p[0], p[1], 0]) cylinder(d = pad_d, h = plate_t);
            // spoke from the inner ring out through the pad to the outer ring
            a = atan2(p[1], p[0]);
            rotate(a) translate([open_d / 2, -rib_w / 2, 0]) cube([ring_d / 2 - outer_w / 2 - open_d / 2, rib_w, plate_t]);
        }
    }
}

module ribs() {
    for (a = rib_angles) rotate(a)
        translate([open_d / 2 - 1, -rib_w / 2, 0])
            cube([pocket_d / 2 - open_d / 2 + 1, rib_w, plate_t + air_gap]);
}

module tabs() {
    for (a = tab_angles) rotate(a)
        intersection() {
            difference() {
                cylinder(d = ring_d, h = plate_t + air_gap + tab_up);
                translate([0, 0, -1]) cylinder(d = pocket_d, h = 100);
                translate([0, 0, plate_t + air_gap + tab_up - 1.5])
                    cylinder(d1 = pocket_d, d2 = pocket_d + 3, h = 1.5 + eps);
            }
            translate([0, -tab_w / 2, plate_t - eps]) cube([ring_d, tab_w, 100]);
        }
}

module bolt_holes() {
    for (p = all_holes) translate([p[0], p[1], 0]) {
        translate([0, 0, -1]) cylinder(d = bolt_d, h = plate_t + 2);
        csk = (csk_d - bolt_d) / 2;
        translate([0, 0, plate_t - csk]) cylinder(d1 = bolt_d, d2 = csk_d, h = csk + eps);
    }
}

module riser() {
    difference() {
        union() { ring_plate(); ribs(); tabs(); }
        bolt_holes();
    }
}

module fan() {
    // hangs under the cover
    translate([0, 0, -cover_t - fan_thick]) {
        color("#3a3f45") difference() {
            translate([-fan_size / 2, -fan_size / 2, 0]) cube([fan_size, fan_size, fan_thick]);
            translate([0, 0, -1]) cylinder(d = fan_size - 4, h = fan_thick + 2);
            for (p = fan_holes) translate([p[0], p[1], -1]) cylinder(d = bolt_d, h = fan_thick + 2);
        }
        color("#55606a") cylinder(d = 40, h = fan_thick - 2);
    }
}

// U6 Pro, from Ubiquiti's photos: a flat back with a short straight band
// round the edge, and a smooth dome on the front that is 35 mm thick in
// the middle. The status LED is a ring about 72 mm across on the dome.
ap_band = 6;           // straight band at the back edge
led_d = 72;
function ap_dome_z(r) = ap_band + (ap_h - ap_band) * sqrt(max(0, 1 - pow(r / (ap_d / 2), 2)));

module ap_body() {
    translate([0, 0, plate_t + air_gap]) rotate_extrude($fn = 128) polygon(concat(
        [[0, 0], [ap_d / 2 - 1, 0], [ap_d / 2, 1], [ap_d / 2, ap_band]],
        [for (a = [3 : 3 : 90]) [ap_d / 2 * cos(a), ap_band + (ap_h - ap_band) * sin(a)]],
        [[0, ap_h]]));
}
module ap_led() {
    translate([0, 0, plate_t + air_gap + ap_dome_z(led_d / 2) - 0.6])
        rotate_extrude($fn = 128) translate([led_d / 2, 0]) scale([1.6, 0.8]) circle(r = 1.2, $fn = 16);
}
module ap() {
    color("WhiteSmoke") ap_body();
    color("#8fc4ff") ap_led();
}

if (part == "riser") riser();
else if (part == "tabs") difference() { tabs(); bolt_holes(); }
else if (part == "fan") fan();
else if (part == "ap") ap();
else {
    color("#2f3337") difference() { union() { ring_plate(); ribs(); } bolt_holes(); }
    color("#2f3337") tabs();
    color("#30353a", 0.6) translate([-115, -115, -cover_t]) cube([230, 230, cover_t]);
    if (show_devices) { fan(); ap(); }
}
