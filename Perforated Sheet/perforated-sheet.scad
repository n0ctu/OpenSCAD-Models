/*
Simple OpenSCAD script to create perforated sheets.
By n0ctua https://github.com/n0ctu/
*/

// Sheet Size
x = 90;
y = 69;
thickness = 2;

// Hole Specs
diameter = 2.7;
xdistance = 4.3;
ydistance = 4.3;
offset = true;


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
    xamount = x / xdistance;
    for (i=[0 : xamount+1]) {
        translate([(i * (xdistance)), 0])
            hole();
    }
}

module holes() {
    yamount = y / ydistance;
    for (i=[0 : yamount+1]) {
        if (i % 2 == 0 && offset) {
            translate([((xdistance) / 2), (i * ydistance)])
                xholes();
        } else {
            translate([0, (i * ydistance)])
                xholes();

        }
    }
}

// Final bool op
difference() {
    sheet();
    translate([-(xdistance / 2), -(ydistance / 2),0])
        holes();
}
