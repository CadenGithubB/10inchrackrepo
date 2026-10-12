// Visual stand-in for the ElecVoztile 10" 1U PDU (8 outlets, 125 V 15 A):
// a square aluminium bar with ears, a red rocker switch on the front
// and 8 short pigtails out of the back, ending in NEMA 5-15R sockets.
// Sizes are read off the product photos, not measured. Not a printable part.
// Rack coordinates: X across (0 = centre), Y rearward from the back face
// of the rack ears, Z up from the bottom of the U.
which = "body";    // [body, front, pigtails, sockets]
$fn = 24;

U = 44.45;
bar = [222, 44, 40];      // body W x D x H (square-ish extrusion)
ear = [16, 3, 44];        // each ear, outside the bar
n = 8;
cord_d = 7;
cord_len = 100;           // pigtail length, 4 in
sock = [27, 34, 30];      // moulded 5-15R socket end, W x L x H
z0 = 2;                   // bar bottom above the bottom of the U

module ears() {
    for (s = [-1, 1]) translate([s > 0 ? bar[0] / 2 : -bar[0] / 2 - ear[0], -ear[1], 0])
        difference() {
            cube([ear[0], ear[1], ear[2]]);
            // three horizontal slots, like the photo
            for (z = [7, 22, 37]) translate([ear[0] / 2, ear[1] + 1, z]) rotate([90, 0, 0])
                hull() for (dx = [-3, 3]) translate([dx, 0, 0]) cylinder(d = 5, h = ear[1] + 2);
        }
}

module bar_body() {
    translate([-bar[0] / 2, 0, z0]) cube(bar);
    // end caps, slightly proud
    for (s = [-1, 1]) translate([s > 0 ? bar[0] / 2 - 2 : -bar[0] / 2 - 1, -0.5, z0 - 0.5]) cube([3, bar[1] + 1, bar[2] + 1]);
}

module front_bits() {
    // red rocker switch at the right
    translate([bar[0] / 2 - 40, -2.5, z0 + 11]) cube([11, 2.5, 18]);
}

// grommets along the back face, alternating high and low like the photo
function gx(i) = -bar[0] / 2 + 18 + i * (bar[0] - 36) / (n - 1);
function gz(i) = z0 + (i % 2 == 0 ? 28 : 12);
// low cords hang a bit shorter so the sockets sit in two staggered rows
function glen(i) = i % 2 == 0 ? cord_len : cord_len - 38;
module pigtails() {
    for (i = [0 : n - 1]) {
        x = gx(i); z = gz(i); y0 = bar[1]; L = glen(i);
        // grommet
        translate([x, y0 - 0.5, z]) rotate([-90, 0, 0]) cylinder(d = 12, h = 3);
        // cord: straight out, then sagging a little
        hull() { translate([x, y0 + 2, z]) sphere(d = cord_d); translate([x, y0 + L * 0.55, z - 4]) sphere(d = cord_d); }
        hull() { translate([x, y0 + L * 0.55, z - 4]) sphere(d = cord_d); translate([x, y0 + L, z - 10]) sphere(d = cord_d); }
    }
    // 6 ft mains cord out of the left end
    hull() { translate([-bar[0] / 2, bar[1] / 2, z0 + 20]) sphere(d = 9); translate([-bar[0] / 2 + 6, bar[1] + 60, z0 + 20]) sphere(d = 9); }
}
module sockets() {
    for (i = [0 : n - 1]) {
        x = gx(i); z = gz(i) - 10;
        translate([x - sock[0] / 2, bar[1] + glen(i) - 4, z - sock[2] / 2]) cube(sock);
    }
}

if (which == "body") { ears(); bar_body(); }
if (which == "front") front_bits();
if (which == "pigtails") pigtails();
if (which == "sockets") sockets();
