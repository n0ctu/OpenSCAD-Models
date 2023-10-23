/*
OpenSCAD script to create square pockets to run LED strips below.
Funnels the light towards a semi-translucent surface such as white acrylic glass
Hint: Print this with non-translucent, rather dark PLA/ABS/resin, then paint it white

By n0ctua https://github.com/n0ctu/
*/


// Define parameters

led_num_x = 4;             // amount, as many as your printer can take
led_num_y = 3;             // amount

led_cell_x = 1000/30;      // mm, 30 LEDs per meter in my case
led_cell_y = led_cell_x;   // mm, same as led_cell_x to make them square
panel_height = 20;         // mm, just about high enough to illuminate the whole top surface
bezel_width = 2;           // mm, trade off: solidity / narrow bezels

strip_pocket_height = 4;   // mm, height of the pocket to run an LED strip
strip_pocket_width = 12;   // mm, width of your strip
strip_pocket_radius = 12;  // mm, Radius of the rounded top of the cable pocket


// LED cells
module led_cell() {
    pocket_x = led_cell_x - bezel_width;
    pocket_y = led_cell_y - bezel_width;
    pocket_z = panel_height + 2;
    
    difference() {
        cube([led_cell_x, led_cell_y, panel_height]);
        translate([bezel_width / 2, bezel_width / 2, -1]) {
            cube([pocket_x, pocket_y, pocket_z]);
        }
    }
}

// LED strip pockets
module strip_pocket() {
    translate([led_cell_x / 2, led_cell_y / 2, 0]) {
        intersection() {
            translate([0, 0, strip_pocket_height / 2])
                cube([led_cell_x + 1, strip_pocket_width, strip_pocket_height], center=true);
            rotate([0,90,0]) {
            translate([strip_pocket_radius - strip_pocket_height, 0, 0])
                cylinder(h = led_cell_x + 1, r = strip_pocket_radius, center=true);
            }
        }
    }
}

// Assemble the whole thing
for (x = [1 : led_num_x]) {
    for (y = [1 : led_num_y]) {
        translate([(x - 1) * led_cell_x, (y - 1) * led_cell_y, 0]) {
            difference() {
                led_cell();
                strip_pocket();
            }
        }
    }
}
