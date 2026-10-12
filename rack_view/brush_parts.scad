// Visual stand-in for a Tecmojo 0.5U cable-management brush panel (bought).
// A black half-height plate with rack ears and a long slot filled with
// two rows of bristles that meet in the middle, so cables can be pushed
// through anywhere along it. A couple of cables are drawn going through.
// Rack coordinates: X across (0 = centre), Y rearward from the back face
// of the rack ears, Z up from the bottom of the half-U.
which = "panel";   // [panel, brush, cables]
$fn = 24;
U = 44.45;
h = U / 2 - 0.4;
t = 2;
slot = [204, 12];          // the brush opening
strand = [0.7, 6, 0.7];    // bristle tuft: width, depth (front to back), thickness
pitch = 1.5;               // tuft spacing along the slot
cable_x = [-55, -40, 62];  // where the drawn cables pass through

module panel() {
    difference() {
        union() {
            translate([-127, -t, 0]) cube([254, t, h]);
            // folded lip along the top and bottom, behind the face
            for (z = [0, h - t]) translate([-112, -t, z]) cube([224, 12, t]);
        }
        // the slot, with rounded ends
        translate([0, 1, h / 2]) rotate([90, 0, 0])
            hull() for (s = [-1, 1]) translate([s * (slot[0] - slot[1]) / 2, 0, 0]) cylinder(d = slot[1], h = t + 2);
        for (s = [-1, 1]) translate([s * 118.25, 1, h / 2]) rotate([90, 0, 0])
            hull() for (dx = [-3, 3]) translate([dx, 0, 0]) cylinder(d = 6.6, h = t + 2);
    }
}

// Bristles: a dense comb of tufts from the top edge and another from the
// bottom edge, each reaching just past the middle so they overlap. Tufts
// are left out where a cable pushes through.
module brush() {
    half = slot[1] / 2;
    for (x = [-(slot[0] / 2 - half) : pitch : slot[0] / 2 - half])
        if (min([for (c = cable_x) abs(x - c)]) > 4)
            for (s = [-1, 1]) {
                // top row hangs down, bottom row stands up, staggered by half a pitch
                xx = x + (s > 0 ? 0 : pitch / 2);
                len = half + 0.8;
                translate([xx - strand[0] / 2, -t - 0.6, s > 0 ? h / 2 + half - len : h / 2 - half])
                    cube([strand[0], strand[1], len]);
            }
}

// cables pushed through the brush, running back into the rack
module cables() {
    for (i = [0 : len(cable_x) - 1]) {
        x = cable_x[i];
        hull() { translate([x, -14, h / 2 + 18]) sphere(d = 6); translate([x, -10, h / 2 + 6]) sphere(d = 6); }
        hull() { translate([x, -10, h / 2 + 6]) sphere(d = 6); translate([x, 6, h / 2]) sphere(d = 6); }
        hull() { translate([x, 6, h / 2]) sphere(d = 6); translate([x, 60 + i * 15, h / 2 - 4]) sphere(d = 6); }
    }
}

if (which == "panel") panel();
if (which == "brush") brush();
if (which == "cables") cables();
