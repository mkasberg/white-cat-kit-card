/* Cuts a bend under the kit card */

module bend_cut(sides, length, thickness = 1.8) {
  // Make it thicker to avoid edge collisions
  angle = (360 / sides);
  h = thickness;
  w = 2 * h * tan(angle / 2);

  translate([0, 0, -h]) rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(length) {
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
      [-0.8, 0.4 + 0.1],
      [0.8, 0.4 + 0.1],
      [1.2, 0]
    ]);
  }
}

bend_cut(8, 20);
translate([30, 0, 0]) big_bend_cap(20);
