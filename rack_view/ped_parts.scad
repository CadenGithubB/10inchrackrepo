use <../u6pro_top_mount/u6pro_top_mount.scad>
which = "base";
$fn = 72;
if (which == "base") base();
if (which == "deck") translate([0, 0, 32]) deck();
if (which == "ap") translate([0, 0, 32 + 4 + 12]) ap();
if (which == "fan") fan();
if (which == "inj") injector();
