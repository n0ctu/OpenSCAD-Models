/*
OpenSCAD script to generate coutout templates/mounts for standard fans with 4 mounting holes.

By n0ctua https://github.com/n0ctu/
*/


// Measure these
fan_size = 120;
screw_distance = 105;

// Fine tuning
fan_bezel = 5;
fan_diameter = fan_size + 5;
screw_diameter = 5;
fan_outline = true;

// Smooth circles
$fa = 1;
$fs = 0.5; 



// Fan Hole
module fan_hole() {
    intersection() {
        square(size = [fan_size - fan_bezel, fan_size - fan_bezel], center = true);
        circle(d = fan_diameter, center = true);
    }
}

// Screw Holes
module screw_holes() {
    screw_pos = 0 - screw_distance / 2;
    screw_neg = screw_distance / 2;
    
    translate([screw_neg, screw_pos, 0])
    circle(d = screw_diameter, center = true);
    
    translate([screw_pos, screw_pos, 0])
    circle(d = screw_diameter, center = true);
    
    translate([screw_neg, screw_neg, 0])
    circle(d = screw_diameter, center = true);
    
    translate([screw_pos, screw_neg, 0])
    circle(d = screw_diameter, center = true);
}


if(fan_outline) {
    difference() {
        square(size = [fan_size, fan_size], center = true);
        fan_hole();
        screw_holes();
    }
} else {
    fan_hole();
    screw_holes();
}