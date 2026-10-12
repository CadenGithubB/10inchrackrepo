// whole-rack composite (rough stand-in for the DeskPi RackMate T2, 12U)
U = 44.45; top_z = 566.4; floor_z = -30; rail_x = 118.25; depth = 255;
mac_u = 1;   // shelf bottom at U index (0-based)
flex_u = 11;
ped_y = depth / 2 - 19.85;
module post(x, y) translate([x - 10, y, floor_z]) cube([20, 20, top_z - floor_z]);
which = "all";
if (which == "all" || which == "rack") color("#1b1e21") {
  for (x = [-rail_x, rail_x], y = [0, depth - 20]) post(x, y);
  // top and bottom frames
  for (z = [floor_z, top_z - 33]) translate([-rail_x - 10, 0, z]) difference() {
    cube([2 * rail_x + 20, depth, 33]);
    translate([12, 12, -1]) cube([2 * rail_x - 4, depth - 24, 35]);
  }
  // handles, centred along each side
  for (s = [-1, 1]) translate([s * (239 / 2 + 7) - 7, depth / 2 - 60, top_z]) {
    translate([0, 0, 25]) cube([14, 120, 8]);
    for (y = [0, 106]) cube([14, 14, 33]);
  }
}
if (which == "all" || which == "cover") color("#30353a", 0.85) translate([-rail_x + 2, 12, top_z - 3]) cube([2 * rail_x - 4, depth - 24, 3]);
if (which == "all" || which == "sides") color("#6a7480", 0.18) for (s = [-1, 1]) translate([s * 138 - 1.5, 20, floor_z + 33]) cube([3, depth - 40, top_z - floor_z - 66]);
if (which == "all") {
translate([0, 0, mac_u * U]) {
  color("#2f3337") import("stl/mac_frame.stl");
  color("#f28c28") import("stl/mac_seps.stl");
  color("#c9ccd1") import("stl/mac_studio.stl");
  color("#b8bcc2") import("stl/mac_minis.stl");
  color("#3a3f45") import("stl/mac_fan.stl");
}
translate([0, 0, flex_u * U]) {
  color("#33475e") import("stl/flex_base.stl");
  color("#f28c28") import("stl/flex_frame.stl");
  color("#e8eaec") import("stl/flex_switch.stl");
  color("#d0d4d8") import("stl/flex_inj.stl");
}
translate([0, ped_y, top_z]) {
  color("#5f7a94") import("stl/ped_base.stl");
  color("#5f7a94") import("stl/ped_deck.stl");
  color("#f2f3f4") import("stl/ped_ap.stl");
  color("#3a3f45") import("stl/ped_fan.stl");
  color("#c9ced3") import("stl/ped_inj.stl");
}
}
