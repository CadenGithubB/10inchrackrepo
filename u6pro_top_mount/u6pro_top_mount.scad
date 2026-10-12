// =====================================================================
//  UniFi U6 Pro + PoE injector pedestal for the top of a 10" rack
//  (DeskPi RackMate T2, sitting on its acrylic top cover)
//
//  A round two-part puck the same size as the AP:
//    * base  - sits on the rack top. Holds the U-PoE-AT injector in a
//              bay with side ribs and end stops, and has cable notches
//              front and back plus wall/floor vents.
//    * deck  - screws onto the base with 4x M3x10 + 4x M3 nuts. Its
//              underside holds the injector down; its top is a shallow
//              cradle the U6 Pro sits in. The injector's PoE port feeds
//              the AP through the hole in the middle.
//
//      side view                 top view (deck removed)
//                                        rear (+Y)
//        ____________               ___|notch|___
//       /    U6 Pro   \            /  LAN  PoE   \
//    |=[==============]=| deck    |   [========]   |
//    |   [ injector ]   | base    |   [injector]   |
//    +------------------+         |   [========]   |
//    ===== rack top =====          \___|notch|___/
//                                       front (-Y)
//
//  Coordinates: origin = centre of the puck on the rack top surface,
//  X = left/right, Y = front(-)/back(+), Z = up.
//
//  Render one part:  openscad -D 'part="base"' -o base.stl u6pro_top_mount.scad
//  Parts: assembly | base | deck | fit_check
// =====================================================================

/* [View] */
part    = "assembly";  // [assembly, base, deck, fit_check]
show_devices = true;
explode = 0;           // [0:5:80] lifts the deck and AP in the assembly preview

/* [Devices] */
ap_d   = 197;          // U6 Pro diameter (Ubiquiti spec)
ap_h   = 35;           // U6 Pro height
inj    = [62, 93, 35]; // U-PoE-AT: width (X), length (Y, ports end to power end), height
inj_corner_r = 6;      // estimated plan-view corner radius, preview only

/* [Rack] */
handle_gap = 239;      // measured inside gap between the rack's two top handles

/* [Fit] */
ap_clear  = 0.8;       // radial play around the AP in the cradle
inj_clear = 0.6;       // play around the injector on each side and above it

/* [Puck] */
wall     = 3;          // base outer wall
floor_t  = 2.4;        // base floor
deck_t   = 5;          // deck plate
rim_h    = 7;          // cradle rim height above the deck
rim_t    = 3.2;        // cradle rim thickness
// injector bay position: ports end faces +Y (rear); keeps room for plugs at both ends
inj_y    = -2;         // centre of the injector along Y

/* [Injector bay] */
rib_t    = 2.4;        // side rib thickness
rib_h    = 22;         // side rib height above the floor
stop_t   = 3;          // end stop thickness
stop_h   = 5;          // end stops stay below the RJ45 and C6 sockets

/* [Cables and vents] */
center_hole_d = 50;    // PoE patch cable up to the AP, wide enough to pass a plug
notch_w  = 30;         // cable notches at front and rear, open at the bottom
notch_h  = 14;
vent_w   = 4;
vent_h   = 20;

/* [Hardware] */
screw_d  = 3.4;        // M3 clearance
head_d   = 6.5;        // counterbore for M3 socket or button head
head_h   = 3.2;
nut_af   = 5.7;        // M3 nut across flats + play
nut_h    = 2.7;
boss_d   = 11;
boss_r   = 91;         // boss centre radius
boss_angles = [45, 135, 225, 315];
nut_depth = 6;         // nut slot sits this far below the boss top
foot_d   = 21;         // optional recesses for stick-on rubber feet
foot_depth = 1;

$fn = 96;
eps = 0.01;

// ---------- derived ----------
pocket_d = ap_d + 2 * ap_clear;     // cradle inner diameter
puck_d   = pocket_d + 2 * rim_t;    // outer diameter of base and deck
base_h   = floor_t + inj[2] + inj_clear;  // deck underside rests here
bay_w    = inj[0] + 2 * inj_clear;
bay_l    = inj[1] + 2 * inj_clear;
bay_y0   = inj_y - bay_l / 2;
bay_y1   = inj_y + bay_l / 2;

assert(puck_d < handle_gap, str("Pedestal (", puck_d, " mm) won't fit between the handles (", handle_gap, " mm)"));
echo(str("Clearance to each handle ", (handle_gap - puck_d) / 2, " mm"));
echo(str("Puck diameter ", puck_d, " mm, base height ", base_h,
         " mm, AP top at ", base_h + deck_t + ap_h, " mm above the rack top"));

// ---------- helpers ----------
module rounded_box(size, r) {
    hull() for (x = [r, size[0] - r], y = [r, size[1] - r])
        translate([x, y, 0]) cylinder(r = r, h = size[2]);
}

module hex(af, h) { cylinder(d = af / cos(30), h = h, $fn = 6); }

// ---------- base ----------
module base() {
    difference() {
        union() {
            // outer shell
            difference() {
                cylinder(d = puck_d, h = base_h);
                translate([0, 0, floor_t]) cylinder(d = puck_d - 2 * wall, h = base_h);
            }
            // screw bosses, tied into the wall
            for (a = boss_angles) rotate(a) hull() {
                translate([boss_r, 0, 0]) cylinder(d = boss_d, h = base_h);
                translate([puck_d / 2 - wall / 2 - boss_d / 2, 0, 0]) cylinder(d = boss_d, h = base_h);
            }
            // injector side ribs
            for (s = [-1, 1])
                translate([s > 0 ? bay_w / 2 : -bay_w / 2 - rib_t, bay_y0 - stop_t, 0])
                    cube([rib_t, bay_l + 2 * stop_t, floor_t + rib_h]);
            // low end stops
            for (y = [bay_y0 - stop_t, bay_y1])
                translate([-bay_w / 2 - rib_t, y, 0])
                    cube([bay_w + 2 * rib_t, stop_t, floor_t + stop_h]);
        }
        // screw holes and side-entry nut slots (open towards the middle)
        for (a = boss_angles) rotate(a) translate([boss_r, 0, 0]) {
            translate([0, 0, base_h - nut_depth - 8]) cylinder(d = screw_d - 0.5, h = 20);
            translate([0, 0, base_h - nut_depth - nut_h / 2])
                hull() { hex(nut_af, nut_h); translate([-boss_d, 0, 0]) hex(nut_af, nut_h); }
        }
        // cable notches, front and rear
        for (s = [-1, 1])
            translate([-notch_w / 2, s > 0 ? puck_d / 2 - wall - 2 : -puck_d / 2 - 1, -eps])
                cube([notch_w, wall + 3, notch_h]);
        // wall vents
        for (a = [0 : 15 : 359])
            if (min([for (b = concat(boss_angles, [90, 270])) abs(((a - b + 540) % 360) - 180)]) > 14)
                rotate(a) translate([puck_d / 2 - wall - 1, -vent_w / 2, floor_t + 6])
                    cube([wall + 2, vent_w, vent_h]);
        // floor vents under the injector and to its sides
        for (x = [-80 : 10 : 80], y = [-60 : 30 : 60])
            if (norm([x, y]) < puck_d / 2 - 22 && abs(abs(x) - (bay_w / 2 + rib_t / 2)) > 5)
                translate([x - vent_w / 2, y - 11, -eps]) cube([vent_w, 22, floor_t + 2 * eps]);
        // rubber foot recesses under the bosses
        for (a = boss_angles) rotate(a) translate([boss_r - 12, 0, -eps])
            cylinder(d = foot_d, h = foot_depth + eps);
    }
}

// ---------- deck ----------
module deck() {
    difference() {
        union() {
            cylinder(d = puck_d, h = deck_t);
            // cradle rim, chamfered inside so the AP drops in
            difference() {
                cylinder(d = puck_d, h = deck_t + rim_h);
                translate([0, 0, deck_t - eps]) cylinder(d = pocket_d, h = rim_h + 1);
                translate([0, 0, deck_t + rim_h - 1.5])
                    cylinder(d1 = pocket_d, d2 = pocket_d + 3, h = 1.5 + eps);
            }
        }
        // cable hole to the AP's port
        translate([0, 0, -1]) cylinder(d = center_hole_d, h = deck_t + 2);
        // screws, counterbored so the heads sit below the AP
        for (a = boss_angles) rotate(a) translate([boss_r, 0, 0]) {
            translate([0, 0, -1]) cylinder(d = screw_d, h = deck_t + 2);
            translate([0, 0, deck_t - head_h]) cylinder(d = head_d, h = head_h + rim_h + 1);
        }
        // radial vent slots under the AP, kept off the injector's top
        for (a = [0 : 15 : 359])
            if (min([for (b = boss_angles) abs(((a - b + 540) % 360) - 180)]) > 10)
                rotate(a) hull() for (r = [62, 80])
                    translate([r, 0, -1]) cylinder(d = vent_w, h = deck_t + 2, $fn = 24);
    }
}

// ---------- device previews ----------
module ap() {
    color("WhiteSmoke") hull() {
        cylinder(d = ap_d, h = 1);
        translate([0, 0, ap_h - 8]) rotate_extrude() translate([ap_d / 2 - 8, 0]) circle(r = 8);
    }
}

module injector() {
    color("Gainsboro") translate([-inj[0] / 2, inj_y - inj[1] / 2, floor_t])
        rounded_box(inj, inj_corner_r);
}

// ---------- fit check ----------
// A thin slice of the cradle rim (AP fit) with a short slice of the
// injector bay inside it (injector fit). About 25 g; fits a 256 mm bed.
module fit_check() {
    difference() {
        union() {
            cylinder(d = puck_d, h = 1.2);
            cylinder(d = puck_d, h = 1.2 + 6);
        }
        translate([0, 0, 1.2]) cylinder(d = pocket_d, h = 10);
        translate([0, 0, -1]) cylinder(d = pocket_d - 16, h = 5);
    }
    intersection() {
        base();
        translate([-60, bay_y0 - stop_t - 1, 0]) cube([120, bay_l + 2 * stop_t + 2, floor_t + 8]);
    }
}

// ---------- output ----------
if (part == "base") base();
else if (part == "deck") deck();
else if (part == "fit_check") fit_check();
else {
    color("DimGray") base();
    if (show_devices) injector();
    translate([0, 0, base_h + explode]) {
        color("SlateGray") deck();
        if (show_devices) translate([0, 0, deck_t + explode]) ap();
    }
}
