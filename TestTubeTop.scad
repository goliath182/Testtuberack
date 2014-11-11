use <TestTube.scad>;

height = 118;
max_radius = 17.5;

radii = [9, 15.5, 9, 15.5];

buildTestRack(1, max_radius, height, radii);
module buildTestRack(number, max_radius, height, radius) {
	offset = 10;
	width = (max_radius * 2) + 10;
	inc =  ( (number % 2) == 0 ) ? 0 : 25;
	difference() {
		union() {
			for ( i = [0 : 1 : (number - 1)] ) {
				translate( [0, width * i, 0] )
				topRack(width, height, radii[i], max_radius, offset);
			}
		}
	}
}

module topRack(width, height, radius, offset) {
	num_vials = (width * 4)/((radius * 2) + 10);
	difference() {
		translate( [-(((width * 4) + offset * 2) / 2), 0, ( (height + offset + 4) / 2)] ) {
			difference() {
				translate([(((width * 4) + offset * 2) / 2), 0, 0]) {
					cube( [(width * 4) + offset * 2, width, 4], center = true );
				}
				for ( i = [0 : 1 : num_vials - 1 ] ) {	// 8mm is used as the base offset from the edge
					translate( [((radius * 2 + 10) / 2) + offset + (i * (radius * 2 + 10)), 0, 0] ) {	
						cylinder( 8, radius, radius, center = true );
					}
				}
			}
		}
		spokeHoles(width, height * 4, offset, offset);
	}
}