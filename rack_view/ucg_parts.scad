// Visual stand-in for the Blazin3D UCG-Ultra 1U rack mount (bought, not
// printed here), with the gateway and three short orange patch cables.
// Same rack coordinates as the other parts: X across (0 = centre),
// Y rearward from the back face of the rack ears, Z up from the bottom of the U.
which = "mount";   // [mount, device, cables, keystones]
$fn = 32;

U = 44.45;
ucg = [141.8, 127.6, 30];          // UCG-Ultra W x D x H (Ubiquiti spec)
panel_t = 4;
dev_x = -30;                        // device centre across the panel
dev_z = 7;                          // device bottom above the bottom of the U
jacks_x = [62, 82, 102];            // keystone pass-throughs, right of the window
cradle_d = 135;                     // how far the side rails reach back
rail_t = 4;
rail_h = 34;

module panel() {
    difference() {
        translate([-127, -panel_t, 0]) cube([254, panel_t, U - 0.8]);
        // device window, slightly smaller than the case so the edge overlaps
        translate([dev_x, 1, dev_z + ucg[2] / 2]) rotate([90, 0, 0])
            hull() for (s = [-1, 1]) translate([s * (ucg[0] / 2 - 14), 0, 0])
                scale([1, 0.85]) cylinder(r = 13, h = panel_t + 2);
        // keystone openings
        for (x = jacks_x) translate([x - 7.5, -panel_t - 1, 15]) cube([15, panel_t + 2, 16]);
        // rack ear slots
        for (s = [-1, 1], z = [6.35, 38.1])
            translate([s * 118.25, 1, z]) rotate([90, 0, 0])
                hull() for (dx = [-3, 3]) translate([dx, 0, 0]) cylinder(d = 6.6, h = panel_t + 2);
    }
}

module cradle() {
    // floor plate with a lightening window and two tall side rails
    difference() {
        translate([dev_x - ucg[0] / 2 - rail_t, 0, 0]) cube([ucg[0] + 2 * rail_t, cradle_d, dev_z]);
        translate([dev_x - ucg[0] / 2 + 15, 25, -1]) cube([ucg[0] - 30, cradle_d - 50, dev_z + 2]);
    }
    for (s = [-1, 1]) translate([dev_x + s * (ucg[0] / 2 + rail_t / 2) - rail_t / 2, 0, 0])
        hull() {
            cube([rail_t, 12, rail_h]);
            translate([0, cradle_d - 12, 0]) cube([rail_t, 12, rail_h]);
        }
    // keystone housing behind the panel
    translate([jacks_x[0] - 12, 0, 10]) cube([jacks_x[2] - jacks_x[0] + 24, 22, 26]);
}

module device() {
    r = 10;
    translate([dev_x, ucg[1] / 2 + 2, dev_z]) hull()
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (ucg[0] / 2 - r), sy * (ucg[1] / 2 - r), 0]) {
                translate([0, 0, 3]) cylinder(r = r, h = ucg[2] - 6);
                cylinder(r = r - 3, h = ucg[2]);
            }
}

// a cable as a chain of hulled spheres along a cubic Bezier
function bez(p, t) = pow(1 - t, 3) * p[0] + 3 * pow(1 - t, 2) * t * p[1] + 3 * (1 - t) * t * t * p[2] + pow(t, 3) * p[3];
module cable(p, d = 5.5) {
    n = 24;
    for (i = [0 : n - 1]) hull() {
        translate(bez(p, i / n)) sphere(d = d, $fn = 12);
        translate(bez(p, (i + 1) / n)) sphere(d = d, $fn = 12);
    }
}
module cables() {
    for (i = [0 : 2]) {
        // run back beside the gateway and loop round into its rear ports,
        // staying inside the 1U
        jack = [jacks_x[i], 24, 18 + i * 4];
        port = [dev_x + 10 + i * 16, ucg[1] + 4, dev_z + ucg[2] / 2];
        cable([jack, jack + [0, 150 - i * 12, 0], port + [0, 60 - i * 12, 0], port + [0, 8, 0]]);
        // boots
        translate(jack + [-6, -2, -6]) cube([12, 16, 12]);
        translate(port + [-6, -4, -6]) cube([12, 16, 12]);
    }
}

module keystones() {
    for (x = jacks_x) translate([x - 7, -panel_t + 0.4, 15.5]) cube([14, 20, 15]);
}

if (which == "mount") { panel(); cradle(); }
if (which == "device") device();
if (which == "cables") cables();
if (which == "keystones") keystones();
