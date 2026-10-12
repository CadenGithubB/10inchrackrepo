// L-shaped injector holsters: ear on the BACK face of each rear rail
// (y = 255 in the stand-in rack), injector sleeve inside the rack.
use <../injector_holster/injector_holster.scad>
which = "holster_r";
rail_y = 255;
rail_x = 118.25;
z0 = 11 * 44.45 - 97.6 - 2;   // one U down from the top, leaving room above for cables
module place(side) translate([side == "right" ? rail_x : -rail_x, rail_y, z0]) children();
if (which == "holster_r") place("right") holster("right");
if (which == "holster_l") place("left") holster("left");
if (which == "inj_r") place("right") injector("right");
if (which == "inj_l") place("left") injector("left");
