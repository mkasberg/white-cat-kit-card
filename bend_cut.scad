/* Cuts a bend under the kit card */

module bend_cut(sides, length, thickness = 1.6) {
  // Make it thicker to avoid edge collisions
  angle = (360 / sides);
  h = thickness;
  w = 2 * h * tan(angle / 2);

  translate([0, 0, -h]) rotate([0, 90, 0]) rotate([0, 0, 90]) {
    difference() {
      linear_extrude(length) {
        polygon([
          [-w, 0],
          [0, 2*h],
          [w, 0]
        ]);
      }

      translate([-w, 2*h - 0.2, -1]) cube([2*w, h, length + 2]);
    }
  }
}

// When rotated anticlockwise about the Z axis, sides_left will calculate the left angle.
module transition_bend_cut(sides_left, sides_right, length, thickness = 1.6) {
  angle_l = 360 / sides_left / 2;
  angle_r = 360 / sides_right / 2;
  h = thickness;
  w_l = h * tan(angle_l);
  w_r = h * tan(angle_r);

  translate([0, 0, -h]) rotate([0, 90, 0]) rotate([0, 0, 90]) {
    difference() {
      linear_extrude(length) {
        polygon([
          [-w_r, 0],
          [0, 2*h],
          [w_l, 0]
        ]);
      } 

      translate([-w_r, 2*h - 0.2, -1]) cube([w_r + w_l, h, length + 2]);
    }
  }
}

module test_bend() {
  difference() {
    cube([20, 10, 1.6]);
    translate([10, -5, 0]) rotate([0, 0, 90]) bend_cut(8, 30);
  }
}

module test_bend_narrow() {
  difference() {
    cube([20, 10, 1.6]);
    translate([10, -5, 0]) rotate([0, 0, 90]) bend_cut(16, 30);
  }
}

module test_transition_bend() {
  difference() {
    cube([20, 10, 1.6]);
    translate([10, -5, 0]) rotate([0, 0, 90]) transition_bend_cut(4, 16, 30);
  }
}

test_bend();
translate([0, 20, 0]) test_transition_bend();

translate([30, 0, 0]) test_bend_narrow();
