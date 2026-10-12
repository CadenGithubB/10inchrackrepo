// =====================================================================
//  UniFi U6 Pro fan pedestal for the top of a 10" rack
//  (DeskPi RackMate T2, sitting on its vented acrylic top cover)
//
//  A round two-part puck the same size as the AP, with a 120 mm fan
//  inside. The fan pulls warm air up out of the rack through the top
//  cover and blows it across the back of the AP, then out sideways
//  through the gaps between the locating tabs.
//    * base  - sits on the rack top. Solid wall, open floor under the
//              fan, fan bolted to the floor with 4x M4 countersunk screws.
//    * deck  - screws onto the base with 4x M3x10 + 4x M3 nuts. Finger
//              grille over the fan, radial ribs the AP rests on (with an
//              air gap under it) and 6 tabs that keep it centred.
//
//      side view
//          ________________
//         /     U6 Pro     \           air out between the tabs
//    <-- |_|==============|_| -->      <- 12 mm gap, ribs hold the AP
//        |=====grille=======| deck
//        |   [ 120 fan ]    | base
//        +-----|    |-------+
//    ===== rack top cover =====        air in from the rack
//
//  The PoE cable comes in from the back, under the AP, through the
//  gap between two tabs. The injector lives somewhere else.
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
fan_size = 120;
fan_thick = 25;        // 25 mm standard; 15 mm slim also fits
fan_hole_pitch = 105;  // standard 120 mm fan screw spacing

/* [Rack] */
handle_gap = 239;      // measured inside gap between the rack's two top handles

/* [Fit] */
ap_clear  = 0.8;       // radial play around the AP inside the tabs
fan_clear = 0.6;       // play around the fan frame

/* [Puck] */
wall     = 3;          // base outer wall
floor_t  = 3;          // base floor (takes the countersunk fan screws)
plenum   = 4;          // space between the top of the fan and the deck
deck_t   = 4;          // deck plate
air_gap  = 12;         // AP rests this far above the deck so air can get out
rim_t    = 3.2;        // tab thickness
tab_n    = 6;          // locating tabs around the AP
tab_w    = 14;
tab_up   = 8;          // how far the tabs reach up the side of the AP
rib_n    = 12;         // radial ribs the AP rests on
rib_w    = 3;

/* [Air and cables] */
intake_d = 116;        // opening in the floor under the fan
grille_d = 116;        // grille over the fan in the deck
grille_bar = 2.4;      // grille bar width
grille_pitch = 10;     // ring spacing
fan_notch_w = 10;      // small notch at the back for the fan's USB lead
fan_notch_h = 8;

/* [Hardware] */
screw_d  = 3.4;        // M3 clearance
head_d   = 6.5;        // counterbore for M3 socket or button head
head_h   = 3.2;
nut_af   = 5.7;        // M3 nut across flats + play
nut_h    = 2.7;
boss_d   = 11;
boss_r   = 93;         // boss centre radius, clear of the fan's corners
boss_angles = [45, 135, 225, 315];
nut_depth = 6;         // nut slot sits this far below the boss top
fan_hole_d = 4.5;      // M4 clearance
fan_csk_d  = 8.6;      // M4 countersunk head
foot_d   = 21;         // optional recesses for stick-on rubber feet
foot_depth = 1;

$fn = 96;
eps = 0.01;

// ---------- derived ----------
pocket_d = ap_d + 2 * ap_clear;     // circle the tabs sit on
puck_d   = pocket_d + 2 * rim_t;    // outer diameter of base and deck
base_h   = floor_t + fan_thick + plenum;
fan_holes = [for (sx = [-1, 1], sy = [-1, 1]) [sx, sy] * fan_hole_pitch / 2];

assert(puck_d < handle_gap, str("Pedestal (", puck_d, " mm) won't fit between the handles (", handle_gap, " mm)"));
assert(boss_r - boss_d / 2 > (fan_size / 2 + fan_clear) * sqrt(2), "Screw bosses hit the fan's corners");
echo(str("Clearance to each handle ", (handle_gap - puck_d) / 2, " mm"));
echo(str("Puck diameter ", puck_d, " mm, base height ", base_h,
         " mm, AP top at ", base_h + deck_t + air_gap + ap_h, " mm above the rack top"));
echo(str("Air exit area round the AP about ",
         round(PI * pocket_d * air_gap - tab_n * tab_w * air_gap), " mm2"));

// ---------- helpers ----------
module hex(af, h) { cylinder(d = af / cos(30), h = h, $fn = 6); }

// ---------- base ----------
module base() {
    difference() {
        union() {
            // outer shell, solid wall so the fan pulls only from below
            difference() {
                cylinder(d = puck_d, h = base_h);
                translate([0, 0, floor_t]) cylinder(d = puck_d - 2 * wall, h = base_h);
            }
            // screw bosses, tied into the wall
            for (a = boss_angles) rotate(a) hull() {
                translate([boss_r, 0, 0]) cylinder(d = boss_d, h = base_h);
                translate([puck_d / 2 - wall / 2 - boss_d / 2, 0, 0]) cylinder(d = boss_d, h = base_h);
            }
            // low corner guides that locate the fan frame
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * (fan_size / 2 + fan_clear), sy * (fan_size / 2 + fan_clear), 0])
                    rotate(atan2(sy, sx)) translate([-4, -10, 0]) cube([8, 20, floor_t + 6]);
        }
        // fan pocket inside the corner guides
        translate([-(fan_size / 2 + fan_clear), -(fan_size / 2 + fan_clear), floor_t])
            cube([fan_size + 2 * fan_clear, fan_size + 2 * fan_clear, base_h]);
        // intake under the fan
        translate([0, 0, -1]) cylinder(d = intake_d, h = floor_t + 2);
        // fan screws, countersunk from below so the base sits flat
        for (p = fan_holes) translate([p[0], p[1], 0]) {
            translate([0, 0, -1]) cylinder(d = fan_hole_d, h = floor_t + 2);
            translate([0, 0, -eps]) cylinder(d1 = fan_csk_d, d2 = fan_hole_d, h = (fan_csk_d - fan_hole_d) / 2);
        }
        // deck screw holes and side-entry nut slots (open towards the middle)
        for (a = boss_angles) rotate(a) translate([boss_r, 0, 0]) {
            translate([0, 0, base_h - nut_depth - 8]) cylinder(d = screw_d - 0.5, h = 20);
            translate([0, 0, base_h - nut_depth - nut_h / 2])
                hull() { hex(nut_af, nut_h); translate([-boss_d, 0, 0]) hex(nut_af, nut_h); }
        }
        // fan lead notch at the back, open at the bottom
        translate([-fan_notch_w / 2, puck_d / 2 - wall - 2, -eps])
            cube([fan_notch_w, wall + 3, fan_notch_h]);
        // rubber foot recesses under the bosses
        for (a = boss_angles) rotate(a) translate([boss_r - 6, 0, -eps])
            cylinder(d = foot_d, h = foot_depth + eps);
    }
}

// ---------- deck ----------
module grille() {
    // concentric rings joined by spokes; what's left here gets cut out
    difference() {
        cylinder(d = grille_d, h = deck_t + 2);
        for (r = [grille_pitch : grille_pitch : grille_d / 2 - 1])
            difference() {
                cylinder(r = r + grille_bar / 2, h = deck_t + 2);
                translate([0, 0, -1]) cylinder(r = r - grille_bar / 2, h = deck_t + 4);
            }
        cylinder(r = grille_pitch - grille_bar / 2 + 0.01, h = deck_t + 2);  // solid hub
        for (a = [0 : 60 : 359]) rotate(a) translate([0, -grille_bar / 2, 0])
            cube([grille_d, grille_bar, deck_t + 2]);
    }
}

module deck() {
    tab_angles = [for (i = [0 : tab_n - 1]) i * 360 / tab_n];
    rib_angles = [for (i = [0 : rib_n - 1]) 15 + i * 360 / rib_n];
    difference() {
        union() {
            cylinder(d = puck_d, h = deck_t);
            // radial ribs: the AP rests on these, air flows out between them
            for (a = rib_angles) rotate(a)
                translate([grille_d / 2 + 2, -rib_w / 2, 0])
                    cube([pocket_d / 2 - grille_d / 2 - 2, rib_w, deck_t + air_gap]);
            // locating tabs round the edge, chamfered inside so the AP drops in
            for (a = tab_angles) rotate(a)
                intersection() {
                    difference() {
                        cylinder(d = puck_d, h = deck_t + air_gap + tab_up);
                        translate([0, 0, -1]) cylinder(d = pocket_d, h = 100);
                        translate([0, 0, deck_t + air_gap + tab_up - 1.5])
                            cylinder(d1 = pocket_d, d2 = pocket_d + 3, h = 1.5 + eps);
                    }
                    translate([0, -tab_w / 2, 0]) cube([puck_d, tab_w, 100]);
                }
        }
        // grille over the fan
        translate([0, 0, -1]) grille();
        // screws, counterbored
        for (a = boss_angles) rotate(a) translate([boss_r, 0, 0]) {
            translate([0, 0, -1]) cylinder(d = screw_d, h = deck_t + 2);
            translate([0, 0, deck_t - head_h]) cylinder(d = head_d, h = head_h + 1);
        }
    }
}

// ---------- device previews ----------
module ap() {
    color("WhiteSmoke") hull() {
        cylinder(d = ap_d, h = 1);
        translate([0, 0, ap_h - 8]) rotate_extrude() translate([ap_d / 2 - 8, 0]) circle(r = 8);
    }
}

module fan() {
    color("#3a3f45") translate([0, 0, floor_t]) difference() {
        translate([-fan_size / 2, -fan_size / 2, 0]) cube([fan_size, fan_size, fan_thick]);
        translate([0, 0, -1]) cylinder(d = fan_size - 4, h = fan_thick + 2);
        for (p = fan_holes) translate([p[0], p[1], -1]) cylinder(d = fan_hole_d, h = fan_thick + 2);
    }
    color("#55606a") translate([0, 0, floor_t]) cylinder(d = 40, h = fan_thick - 2);
}

// ---------- fit check ----------
// The outer ring of the deck with the AP tabs (AP fit), and the floor
// slice with the fan corner guides and screw holes (fan fit).
module fit_check() {
    intersection() {
        deck();
        difference() {
            cylinder(d = puck_d + 1, h = 100);
            translate([0, 0, -1]) cylinder(d = pocket_d - 12, h = 102);
        }
    }
    intersection() {
        base();
        cylinder(d = pocket_d - 20, h = floor_t + 6);
    }
}

// ---------- output ----------
if (part == "base") base();
else if (part == "deck") deck();
else if (part == "fit_check") fit_check();
else {
    color("DimGray") base();
    if (show_devices) fan();
    translate([0, 0, base_h + explode]) {
        color("SlateGray") deck();
        if (show_devices) translate([0, 0, deck_t + air_gap + explode]) ap();
    }
}
