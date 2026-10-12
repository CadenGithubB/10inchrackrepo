which = "base";
module rj45(x, z) translate([x - 6, 4.2, z - 5.5]) difference() {
    cube([12, 1, 10.5]);
    translate([4, -1, -1]) cube([4, 3, 2.5]);   // latch notch
}
$fn = 48;
translate([-127, -4, 0]) {
if (which == "base") rotate([-90,0,0]) translate([0,-44,0]) import("../flex_mini_mount/01-main-mount-PRINT-1.stl");
if (which == "frame") rotate([90,0,0]) translate([31.45,1.2,-108.3]) import("../flex_mini_mount/02-retaining-frame-PRINT-1.stl");
if (which == "switch") translate([29.45,4.8,4]) cube([117.1,90,21.2]);
if (which == "inj") translate([162,4.8,4]) cube([62,93,35]);
// front-panel detail (preview only): 5 RJ45 + USB-C on the switch, LAN + PoE on the injector
if (which == "ports") {
    for (i = [0 : 4]) rj45(29.45 + 117.1 / 2 - 24 + i * 15, 4 + 10.6);
    translate([29.45 + 10, 4.2, 4 + 9.4]) cube([9, 1, 3.2]);     // USB-C
    for (dx = [-9, 9]) rj45(162 + 31 + dx, 4 + 17.5);
}
if (which == "leds") {
    for (i = [0 : 4]) translate([29.45 + 117.1 / 2 - 24 + i * 15 - 1, 4.0, 4 + 17.3]) cube([2, 1, 1.2]);
}
}
