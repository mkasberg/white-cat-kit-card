/* Cuts a bend under the kit card */

module bend_cut(sides, length, thickness = 1.8) {
  // Make it thicker to avoid edge collisions
  angle = (360 / sides);
  h = thickness;
  w = 2 * h * tan(angle / 2);

  translate([0, 0, -h - 0.01]) rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(length) {
    polygon([
      [-w, 0],
      [0, 2*h],
      [w, 0]
    ]);
  }
}

module big_bend_cap(length, thickness = 1.8) {
  translate([0, 0, thickness - 0.1]) rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(length) {
    polygon([
      [-1.2, 0],
      [-0.8, 0.2 + 0.1],
      [0.8, 0.2 + 0.1],
      [1.2, 0]
    ]);
  }
}

module test_bend() {
  difference() {
    cube([20, 10, 1.8]);
    translate([10, -5, 0]) rotate([0, 0, 90]) bend_cut(8, 30);
  }
  
  translate([10, 0, 0]) rotate([0, 0, 90]) big_bend_cap(10);
}

test_bend();
