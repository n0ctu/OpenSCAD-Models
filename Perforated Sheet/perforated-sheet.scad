/*
Simple OpenSCAD script to create perforated sheets.
By n0ctua https://github.com/n0ctu/
*/


// Sheet Size
x = 80;
y = 100;
thickness = 2;

// Hole Specs
diameter = 3;
xdistance = 5;
ydistance = 5;
offset = true;

// Pythagoras to make it symmetric if offset is true
ydist = (offset) ? sqrt(ydistance^2 - (ydistance/2)^2) : ydistance;
xdist = xdistance;

// Smooth circles
$fa = 1;
$fs = 0.5; 

// Sheet
module sheet() {
    cube(size = [x, y, thickness], center = false);
}

// Hole pattern
module hole() {
    translate([0, 0, -0.5])
    cylinder(h = thickness + 1, d = diameter, center = false);
}

module xholes() {
    xamount = x / xdist;
    for (i=[0 : xamount+1]) {
        translate([(i * (xdist)), 0])
            hole();
    }
}

module holes() {
    yamount = y / ydist;
    for (i=[0 : yamount+1]) {
        if (i % 2 == 0 && offset) {
            translate([((xdist) / 2), (i * ydist)])
                xholes();
        } else {
            translate([0, (i * ydist)])
                xholes();

        }
    }
}

// Final bool op
translate([-(x/2),-(y/2),0])
    difference() {
        sheet();
        translate([-(xdist / 2), -(ydist / 2),0])
            holes();
    }
