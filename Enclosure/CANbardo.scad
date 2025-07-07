// Rendering
$fn = 100;

// Plate thickness
thickness = 2;

module plate(screw_d = 3.5) {
    width = 56;
    height = 70;
    rounding = 5;

    difference() {
        translate([rounding, rounding, 0]) {
            minkowski() {
                square(size = [width - 2 * rounding, height - 2 * rounding], center = false);
                circle(r = rounding);
            }
        }

        /* Screw holes */
        for (x = [5, 38]) {
            for (y = [5, 65]) {
                offset_x = x;
                offset_y = y;
                translate([offset_x, offset_y, 0]) {
                    circle(d = screw_d);
                }
            }
        }
    }
}

module plate_bottom() {
    rounding = 1;

    difference() {
        plate();

        /* DB-9M connector shield solder pads */
        for (y = [4, 29, 41, 66]) {
            translate([46.5, y, 0]) {
                circle(d = 5);
            }
        }

        /* DB-9M connector pin solder pads */
        for (y = [11, 48]) {
            translate([45.5 - rounding, y - rounding, 0]) {
                minkowski() {
                    square(size = [6 - 2 * rounding, 15 - 2 * rounding], center = false);
                    circle(r = rounding);
                }
            }
        }

        /* Pin header solder pads */
        translate([16.25 - rounding, 47 - rounding, 0]) {
            minkowski() {
                square(size = [3 - 2 * rounding, 22 - 2 * rounding], center = false);
                circle(r = rounding);
            }
        }
    }
}

module plate_bottom_3d() {
    linear_extrude(height = thickness) {
        plate_bottom();
    }
}

module plate_top() {
    rounding = 1;

    difference() {
        plate();

        /* DFU button */
        translate([6, 52, 0]) {
            circle(d = 4);
        }

        /* DB-9M connectors */
        for (y = [16.5, 53.5]) {
            translate([50, y, 0]) {
                square([13, 18], center = true);
            }
            translate([55, y, 0]) {
                square([12, 33], center = true);
            }
        }

        /* Pin header */
        translate([16.25 - rounding, 47 - rounding, 0]) {
            minkowski() {
                square(size = [3 - 2 * rounding, 22 - 2 * rounding], center = false);
                circle(r = rounding);
            }
        }
    }
}

module plate_top_3d() {
    linear_extrude(height = thickness) {
        plate_top();
    }
}

module model_2d() {
    plate_bottom();

    translate([60, 0, 0]) {
        plate_top();
    }
}

module model_3d() {
    import("CANbardo.stl");

    translate([0, 0, -1 * thickness]) {
        %plate_bottom_3d();
    }

    translate([0, 0, 1.6 + 6]) {
        %plate_top_3d();
    }
}

3d = $preview;

if (3d) {
    model_3d();
} else {
    model_2d();
}
