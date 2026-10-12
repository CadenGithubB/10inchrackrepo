which = "base";
$fn = 48;
translate([-127, -4, 0]) {
if (which == "base") rotate([-90,0,0]) translate([0,-44,0]) import("/Users/morgan/Documents/ChatGPT/10 in rack/v4-slot-retainer/01-main-mount-PRINT-1.stl");
if (which == "frame") rotate([90,0,0]) translate([31.45,1.2,-108.3]) import("/Users/morgan/Documents/ChatGPT/10 in rack/v4-slot-retainer/02-retaining-frame-PRINT-1.stl");
if (which == "switch") translate([29.45,4.8,4]) cube([117.1,90,21.2]);
if (which == "inj") translate([162,4.8,4]) cube([62,93,35]);
}
