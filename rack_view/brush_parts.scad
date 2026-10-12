// Visual stand-in for a Tecmojo 0.5U cable-management brush panel (bought).
// Rack coordinates: X across (0 = centre), Y rearward from the back face
// of the rack ears, Z up from the bottom of the half-U.
which = "panel";   // [panel, brush]
$fn = 24;
U = 44.45;
h = U / 2 - 0.4;
t = 2;
slot = [200, 9];
module panel() {
    difference() {
        union() {
            translate([-127, -t, 0]) cube([254, t, h]);
            // folded lip along the bottom, behind the face
            translate([-110, -t, 0]) cube([220, 14, t]);
        }
        translate([-slot[0] / 2, -t - 1, (h - slot[1]) / 2]) cube([slot[0], t + 2, slot[1]]);
        for (s = [-1, 1]) translate([s * 118.25, 1, h / 2]) rotate([90, 0, 0])
            hull() for (dx = [-3, 3]) translate([dx, 0, 0]) cylinder(d = 6.6, h = t + 2);
    }
}
// two rows of bristles meeting in the middle of the slot
module brush() {
    for (s = [-1, 1]) translate([-slot[0] / 2, -t - 0.2, h / 2 + (s > 0 ? 0.3 : -slot[1] / 2 - 0.3)])
        cube([slot[0], t + 4, slot[1] / 2]);
}
if (which == "panel") panel();
if (which == "brush") brush();
