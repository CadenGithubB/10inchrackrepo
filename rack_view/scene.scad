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
    part(str("mac_seps_", config), "#5a616b");
    part(str("mac_studio_", config), "#c9ccd1");
    part(str("mac_studio_ports_", config), "#1d2024");
    part(str("mac_minis_", config), "#b8bcc2");
}
if (focus == "all") {
    at(9.5 * U) { part("brush_panel", "#15171a"); part("brush_brush", "#4a5058"); }
    at(10 * U) { part("flex_base", "#2f3337"); part("flex_frame", "#5a616b");
                 part("flex_switch", "#e8eaec"); part("flex_inj", "#d0d4d8");
                 part("flex_ports", "#1d2024"); part("flex_leds", "#7cd38b"); }
    at(11 * U) { part("ucg_mount", "#2f3337"); part("ucg_keystones", "#e9eaeb");
                 part("ucg_cables", "#f08a2c"); part("ucg_device", "#f4f5f6");
                 part("ucg_screen", "#14171a"); part("ucg_screen_glow", "#9fd0ff");
                 part("ucg_ports", "#1d2024"); part("ucg_jacks", "#1d2024"); }
    part("hol_holster_r", "#2f3337"); part("hol_holster_l", "#2f3337");
    part("hol_inj_r", "#d0d4d8"); part("hol_inj_l", "#d0d4d8");
    translate([0, DEPTH / 2, TOP_Z]) {
        part("ped_body", "#2f3337"); part("ped_tabs", "#2f3337");
        part("ped_fan", "#3a3f45"); part("ped_ap", "#f2f3f4"); part("ped_led", "#8fc4ff");
    }
}
