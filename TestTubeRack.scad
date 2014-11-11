use <TestTube.scad>;

$fn = 20;
height = 118;
max_radius = 17.5;

radii = [9, 15.5, 9, 15.5];

buildTestRack(1, max_radius, height, radii);

module buildTestRack(number, max_radius, height, radius) {
	offset = 17.5;
	width = (max_radius * 2) + 10;
	inc =  ( (number % 2) == 0 ) ? 0 : 25;
	difference() {
		union() {
			translate ([0, -((number - 1) * width/2), 0]) {
				union() {
					for ( i = [0 : 1 : (number - 1)] ) {
						translate( [0, width * i, 0] ) {
							rack(width, height, radii[i], max_radius, offset);
						}
					}
				}
			}
			puzzlePiece(width, height-40, offset, number);
		}
		puzzleHoles(width, height-40, offset, number);	
	}
}

module rack(width, height, radius, max_radius, offset){
	num_vials = (width * 4)/((radius * 2) + 10);
	union() {
		difference() {
			cube( [(width * 4) + offset * 2, width, height - 40], center = true );	// base for the test tube
			translate([0, 0, 4])
				cube( [(width * 4), width + 32, height - 40], center = true );
			translate([-((width * 4)/ 2), 0, -((height - 40)/2 - 4)]) {
				for ( i = [0 : 1 : num_vials - 1 ] ) {	// 8mm is used as the base offset from the edge
					translate( [((radius * 2 + 10) / 2) + offset/2 + (i * (radius * 2 + 10)), 0, 0] ) {	
						cylinder( 2, radius, radius, center = true );
					}
				}
			}
		}
		translate( [0, 0, (height - 40)/2] )
			spokeHoles(width, 40, offset, offset);
	}
}
module puzzlePiece(width, height, offset, number) {
	union() {
		translate([(width * 2 + offset - offset/4), (width * number)/2, height/4]) {
			puzzle(offset*2);
		}
		translate([(width * 2 + offset - offset/4), (width * number)/2, -height/4]) {
			puzzle(offset*2);
		}
		translate([-(width * 2 + offset/4 + 1), (width * number)/2, height/4]) {
			puzzle(offset*2);
		}
		translate([-(width * 2 + offset/4 + 1), (width * number)/2, -height/4]) {
			puzzle(offset*2);
		}
	}
}

module puzzleHoles(width, height, offset, number) {
	union() {
		translate([(width * 2 + offset - (offset/8)-1), -(width * number)/2, height/4]) {
			puzzle(offset*2);
		}
		translate([(width * 2 + offset - (offset/8)-1), -(width * number)/2, -height/4]) {
			puzzle(offset*2);
		}
		translate([-(width * 2 + (offset/8)-1), -(width * number)/2, height/4]) {
			puzzle(offset*2);
		}
		translate([-(width * 2 + (offset/8)-1), -(width * number)/2, -height/4]) {
			puzzle(offset*2);
		}
	}
}

module puzzleHalf(offset){
	union() {
		translate([0, 0, 5]) {
			polyhedron(
				[[-(offset/8), 4, 5], [-(offset/8), 4, 0], [-(offset/8), 0, 0], [(offset/8), 4, 5], [(offset/8), 4, 0], [(offset/8), 0, 0]],	// Points
				[[2, 1, 0], [5, 3, 4],	// Body
				[5, 4, 2], [1, 2, 4], [2, 0, 5], [3, 5, 0], [0, 1, 4], [4, 3, 0]]	// Edges
			);
		}
		translate([0, 2, 2.5]) {
				cube( [(offset/4), 4, 5], center = true );
		}
	}
}

module puzzle(offset) {
	translate([0, 1, 0]) {
		union() {
			minkowski() {
				union() {
					puzzleHalf(offset);
					mirror([0, 0, 1])
						puzzleHalf(offset);
				}
				rotate([0, 90, 0]) {
					cylinder((offset/16), 1, 1, center = true );
				}
			}
		}
	}
}