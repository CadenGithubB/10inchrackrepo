// Visual stand-in for a basic 10" 1U PDU with 8 short pigtail outlets
// coming out of the back (cords about 4 in / 100 mm, ending in a
// NEMA 5-15R socket). Not a printable part.
// Rack coordinates: X across (0 = centre), Y rearward from the back face
// of the rack ears, Z up from the bottom of the U.
which = "body";    // [body, front, pigtails, sockets]
$fn = 24;

U = 44.45;
panel = [254, 3, U - 0.8];
body = [200, 120, 40];
n = 8;
cord_d = 7;
cord_len = 100;       // pigtail length, max 4 in
sock = [36, 30, 22];  // moulded socket end, W x L x H

module front_panel() {
    difference() {
        translate([-panel[0] / 2, -panel[1], 0]) cube(panel);
        for (s = [-1, 1], z = [6.35, 38.1])
            translate([s * 118.25, 1, z]) rotate([90, 0, 0])
                hull() for (dx = [-3, 3]) translate([dx, 0, 0]) cylinder(d = 6.6, h = panel[1] + 2);
    }
}

module body_box() { translate([-body[0] / 2, 0, 2]) cube(body); }

// front details: rocker switch, breaker and power LED
module front_bits() {
    translate([60, -panel[1] - 4, 12]) cube([22, 4, 16]);              // switch
    translate([92, -panel[1] - 6, 15]) rotate([-90, 0, 0]) cylinder(d = 12, h = 6);  // breaker
    translate([-90, -panel[1] - 1.5, 20]) rotate([-90, 0, 0]) cylinder(d = 4, h = 1.5); // LED
}

// pigtails leave the back of the box in a row and droop slightly
function cord_x(i) = -body[0] / 2 + 15 + i * (body[0] - 30) / (n - 1);
module pigtails() {
    for (i = [0 : n - 1]) {
        x = cord_x(i);
        y0 = body[1];
        hull() { translate([x, y0, 14]) sphere(d = cord_d); translate([x, y0 + cord_len * 0.5, 10]) sphere(d = cord_d); }
        hull() { translate([x, y0 + cord_len * 0.5, 10]) sphere(d = cord_d); translate([x, y0 + cord_len * 0.8, 4]) sphere(d = cord_d); }
        // strain relief at the box
        translate([x, y0 - 1, 14]) rotate([-90, 0, 0]) cylinder(d1 = 12, d2 = 8, h = 10);
    }
    // mains input cord, longer, off to one side
    hull() { translate([-body[0] / 2 + 6, body[1], 30]) sphere(d = 9); translate([-body[0] / 2 + 6, body[1] + 70, 30]) sphere(d = 9); }
}
module sockets() {
    // socket ends: alternate heights so neighbours don't collide
    for (i = [0 : n - 1]) {
        x = cord_x(i);
        translate([x - sock[0] / 2, body[1] + cord_len * 0.8, -6 + (i % 2) * 14]) cube([sock[0] * 0.6, sock[1], sock[2] * 0.8]);
    }
}

if (which == "body") { front_panel(); body_box(); }
if (which == "front") front_bits();
if (which == "pigtails") pigtails();
if (which == "sockets") sockets();
