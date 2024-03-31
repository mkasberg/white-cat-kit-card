/* Clip */

module clip_half(thickness = 1.8) {
  translate([0, -1, 0]) linear_extrude(thickness) {
    polygon([
      [0, 0],
      [0, 4],
      [0.6, 4],
      [1.4, 3.4],
      [1.4, 3],
      [0.8, 2.8],
      [0.8, 0]
    ]);
  }
}

module clip() {
  rotate([0, 0, -90]) {
    translate([0.8, 0, 0]) clip_half();
    translate([-0.8, 0, 0]) mirror([1, 0, 0]) clip_half();
  }
}

module clip_hole() {
  translate([0, -0.8 * 2, -1]) cube([1.8, 0.8*4, 1.8 + 2]);
}

clip();

translate([10, 0, 0]) clip_hole();
