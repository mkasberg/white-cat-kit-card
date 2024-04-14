/* Cuts a bend under the kit card */

module bend_cut(sides, length, covered = false, thickness = 1.8) {
  // Make it thicker to avoid edge collisions
  angle = (360 / sides);
  h = thickness;
  w = 2 * h * tan(angle / 2);
  
  translate_h = covered ? -h + 0.6 - 0.01 : -h - 0.2;

  translate([0, 0, translate_h]) rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(length) {
    polygon([
      [-w, 0],
      [0, 2*h],
      [w, 0]
    ]);
  }

  // Don't allow the tip of the triangle near the bend to be too close and interfere with bend thickness.
  translate([0, -0.1, 0]) cube([length, 0.2, thickness - 0.2]);
}

module big_bend_cap(length, thickness = 1.8) {
  translate([0, 0, thickness - 0.1]) rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(length) {
    polygon([
      [-1.2, 0],
      [-0.8, 0.8],
      [0.8, 0.8],
      [1.2, 0]
    ]);
  }
}

// When rotated anticlockwise about the Z axis, sides_left will calculate the left angle.
module transition_bend_cut(sides_left, sides_right, length, thickness = 1.8) {
  angle_l = 360 / sides_left / 2;
  angle_r = 360 / sides_right / 2;
  h = thickness;
  w_l = h * tan(angle_l);
  w_r = h * tan(angle_r);
  translate_h = -h - 0.2;

  translate([0, 0, translate_h]) rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(length) {
    polygon([
      [-w_r, 0],
      [0, 2*h],
      [w_l, 0]
    ]);
  }

  // Don't allow the tip of the triangle near the bend to be too close and interfere with bend thickness.
  translate([0, -0.1, 0]) cube([length, 0.2, thickness - 0.2]);
}

module test_bend_covered() {
  difference() {
    union() {
      cube([20, 10, 1.8]);
      translate([10, 0, 0]) rotate([0, 0, 90]) big_bend_cap(10);
    }

    translate([10, -5, 0]) rotate([0, 0, 90]) bend_cut(8, 30, covered=true);
  }
  
}

module test_bend() {
  difference() {
    cube([20, 10, 1.8]);
    translate([10, -5, 0]) rotate([0, 0, 90]) bend_cut(8, 30);
  }
}

module test_transition_bend() {
  difference() {
    cube([20, 10, 1.8]);
    translate([10, -5, 0]) rotate([0, 0, 90]) transition_bend_cut(4, 16, 30);
  }
}

test_bend();
translate([0, 20, 0]) test_bend_covered();
translate([0, 40, 0]) test_transition_bend();
