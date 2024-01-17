/*
OpenSCAD script to re-create the Luxeria logo (https://luxeria.ch/)
or other funny (per-) versions of it by manipulating various parameters.

By n0ctua https://github.com/n0ctu/
*/

// START CONFIGURATION

size = 100;
smoothness = 100; // affects all rounded parts

inner_circle = (size / 100) * 25;
outer_ring =   (size / 100) * 85;
outer_ring_thickness = (size / 100) * 12;

arrow_width =        (size / 100) * 25;
arrow_tip_start =    (size / 100) * 20;     // distance from center
arrow_tip_end =      (size / 2);            // distance from center
arrow_notch_offset = (size / 100) * 3;
arrow_base_width =   (arrow_width / 2);

num_arrows = 3;

spacing = (size / 100) * 5;
edges_rounded = 0;
edges_chamfer = 0;

// END CONFIGURATION

// Calculate diameters
diameter_circle1 = inner_circle;
diameter_circle2 = inner_circle + spacing*2;
diameter_circle4 = outer_ring; // most outer circle
diameter_circle3 = diameter_circle4 - outer_ring_thickness * 2;

// Calculate arrow
arrow_tip_height = size / 2.5;
arrow_notch_multiplier = 7;
arrow_base_height = arrow_width / 3;

// Calculate angles for positioning, 3 = [0, 120, 240]
angles = [for (i = 0; i < num_arrows; i = i + 1) i * (360 / num_arrows)];

module centered_circle(diameter) {
    translate([0, 0, 0])
    circle(d=diameter, $fn=smoothness);
}

module arrow_shape() {
    union() {
        polygon(points=[
            [0, arrow_tip_end],                          // Tip
            [-(arrow_width) / 2, arrow_tip_start],       // Right
            [0, (arrow_tip_start + arrow_notch_offset)], // Base notch
            [(arrow_width) / 2, arrow_tip_start]         // Left
        ]);
        square_height = arrow_tip_start - diameter_circle1 / 2 + arrow_notch_offset;
        translate([-arrow_base_width/2, diameter_circle1/2, 0])
        square(size = [(arrow_base_width), square_height]);
    }   
}

module arrow_spacing() {
    offset(delta=spacing)
    polygon(points=[
        [0, (arrow_tip_end)],                  // Tip
        [-(arrow_width) / 2, arrow_tip_start], // Right
        [(arrow_width ) / 2, arrow_tip_start]  // Left
    ]);
}

module arrow_arrange() {
    // Draw the arrow shapes around the circle
    difference() {
        for (angle = angles) {
            rotate([0, 0, angle])
            arrow_shape();
        }
        centered_circle(diameter_circle2);
    }
}

module arrow_spacing_arrange() {
    // Draw the arrow shapes around the circle
    for (angle = angles) {
        rotate([0, 0, angle])
        arrow_spacing();
    }
}

module outer_ring() {
    difference () {
        difference () {
            centered_circle(diameter_circle4);
            centered_circle(diameter_circle3);
        }
        arrow_spacing_arrange();
    }
}

// Final assembly
module luxlogo() {
    union() {
        // Draw the inner circle
        centered_circle(diameter_circle1);       
        // Draw the arrows
        arrow_arrange();
        // Draw outer ring parts
        outer_ring();
    }
}

offset(r=edges_rounded, $fn=smoothness)
offset(delta=edges_chamfer, chamfer=true)
luxlogo();