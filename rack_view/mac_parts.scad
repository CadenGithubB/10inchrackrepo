include <../mac_rack_shelf.scad>
part = "none";
which = "frame";
seps = preset_xs(config);
devs = preset_devices(config);
if (which == "frame") frame_onepiece();
if (which == "seps") for (k = [0 : len(seps) - 1]) translate([seps[k], 0, 0]) separator(sep_hold(config, k));
if (which == "fan") fan_dummy();
if (which == "studio") studio_dummy((seps[0] + seps[1] - studio_dim[2]) / 2);
if (which == "minis") for (i = [0 : len(devs) - 1]) {
    bay_l = seps[i + 1] + sep_t / 2;
    bay_r = (i + 2 < len(seps)) ? seps[i + 2] - sep_t / 2 : xi;
    w = devs[i] == "m4" ? m4_dim[2] : m1_dim[2];
    mini_dummy(devs[i], (bay_l + bay_r - w) / 2);
}
