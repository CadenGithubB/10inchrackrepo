// Whole-rack render scene for README pictures. Imports the parts that
// build.sh exported to stl/ (all in rack coordinates) and picks the Mac
// shelf layout with `config`. Rendered by render.sh.
config = "m1";          // [m1, m4, m1_m4]
show_sides = false;     // acrylic side panels (they wash out the picture)
focus = "all";          // [all, shelf] shelf = hide the parts above the shelf
U = 44.45; TOP_Z = 566.4; DEPTH = 255;

module part(name, c, a = 1) color(c, a) import(str("stl/", name, ".stl"));
module at(z) translate([0, 0, z]) children();

part("rack_rack", "#1b1e21");
part("rack_cover", "#30353a", 0.85);
if (show_sides) part("rack_sides", "#9aa3ad", 0.15);
// PDU, U1
part("pdu_body", "#1f2124"); part("pdu_front", "#d23224");
part("pdu_pigtails", "#111214"); part("pdu_sockets", "#222426");
// Mac shelf, U2-U6
at(U) {
    part("mac_frame", "#2f3337");
    part(str("mac_seps_", config), "#f28c28");
    part(str("mac_studio_", config), "#c9ccd1");
    part(str("mac_minis_", config), "#b8bcc2");
}
if (focus == "all") {
    at(9.5 * U) { part("brush_panel", "#1a1c1e"); part("brush_brush", "#0b0c0d"); }
    at(10 * U) { part("flex_base", "#33475e"); part("flex_frame", "#f28c28");
                 part("flex_switch", "#e8eaec"); part("flex_inj", "#d0d4d8"); }
    at(11 * U) { part("ucg_mount", "#161718"); part("ucg_keystones", "#e9eaeb");
                 part("ucg_cables", "#f08a2c"); part("ucg_device", "#f4f5f6"); }
    part("hol_holster_r", "#2f3337"); part("hol_holster_l", "#2f3337");
    part("hol_inj_r", "#d0d4d8"); part("hol_inj_l", "#d0d4d8");
    translate([0, DEPTH / 2, TOP_Z]) {
        part("ped_body", "#2f3337"); part("ped_tabs", "#f28c28");
        part("ped_fan", "#3a3f45"); part("ped_ap", "#f2f3f4");
    }
}
