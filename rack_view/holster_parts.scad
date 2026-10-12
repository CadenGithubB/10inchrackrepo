// Injector holsters on the rear rails, in rack coordinates.
// Bolted to the BACK face of the rear rails (y = 255 in the stand-in rack),
// hanging just outside the rack.
use <../injector_holster/injector_holster.scad>
which = "holster_r";
rail_y = 255;
rail_x = 118.25;
z0 = 11 * 44.45 - 97.6 - 2;   // one U down from the top, leaving room above for cables
// local strip centre: right holster 78.45, left 9.25 (see injector_holster.scad)
module place(side) {
    dx = side == "right" ? rail_x - 78.45 : -rail_x - 9.25;
    translate([dx, rail_y, z0]) children();
}
if (which == "holster_r") place("right") holster("right");
if (which == "holster_l") place("left") holster("left");
if (which == "inj_r") place("right") injector("right");
if (which == "inj_l") place("left") injector("left");
