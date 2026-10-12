use <../u6pro_top_mount/u6pro_riser.scad>
which = "body";
if (which == "body") difference() { union() { ring_plate(); ribs(); } bolt_holes(); }
if (which == "tabs") difference() { tabs(); bolt_holes(); }
if (which == "fan") fan();
if (which == "ap") ap();
