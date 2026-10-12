// V4 review geometry, imported directly from the final print STLs.
// This file is for inspection and validation, not a third printable part.
mode = "preview"; // preview, base_collision, device_collision, hardware_collision
lift = 0;
show_devices = false;
$fn = 48;

module base_installed() {
    rotate([-90,0,0]) translate([0,-44,0]) import("01-main-mount-PRINT-1.stl");
}
module frame_installed() {
    translate([0,0,lift]) rotate([90,0,0])
        translate([31.45,1.2,-108.3]) import("02-retaining-frame-PRINT-1.stl");
}
module device_interiors() {
    translate([29.46,4.81,4.01]) cube([117.08,89.98,21.18]);
    translate([162.01,4.81,4.01]) cube([61.98,92.98,34.98]);
}
module hardware_envelopes() {
    // Nominal hardware, not printable: 6mm head, M3 shaft, 5.5 AF x2.4 nut.
    for (x = [68,180]) {
        translate([x,103.7,0]) {
            cylinder(d1=6,d2=3,h=1.5);
            cylinder(d=3,h=10);
            translate([0,0,7.1]) rotate([0,0,30])
                cylinder(d=5.5/cos(30),h=2.4,$fn=6);
        }
    }
}
if (mode == "base_collision") {
    intersection() {
        base_installed(); frame_installed();
        // Exclude only the intended coincident shoulders/floor at Z4.
        union() {
            translate([-1,-1,-1]) cube([300,200,4.99]);
            translate([-1,-1,4.01]) cube([300,200,120]);
        }
    }
} else if (mode == "device_collision") {
    intersection() { device_interiors(); frame_installed(); }
} else if (mode == "hardware_collision") {
    intersection() {
        hardware_envelopes();
        union() { base_installed(); frame_installed(); device_interiors(); }
    }
} else {
    color([0.2,0.28,0.37]) base_installed();
    color([0.95,0.48,0.12]) frame_installed();
    color([0.65,0.65,0.65]) hardware_envelopes();
    if (show_devices) {
        %color([0.8,0.85,0.9,0.3]) translate([29.45,4.8,4]) cube([117.1,90,21.2]);
        %color([0.8,0.85,0.9,0.3]) translate([162,4.8,4]) cube([62,93,35]);
    }
}
