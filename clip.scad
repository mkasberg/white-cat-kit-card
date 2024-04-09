/* Clip */

module clip_half(thickness = 1.8) {
  translate([0, -1, 0]) linear_extrude(thickness) {
    polygon([
      [0, 0],
      [0, 4.6],
      [0.2, 4.6],
      [1.3, 3.6],
      [1.3, 3.2],
      [0.8, 1 + 1.8 + 0.2],
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
  translate([-0.1, -(0.8 + 0.8 + 0.2), -1]) cube([1.8 + 0.2, 2 * (0.8 + 0.8 + 0.2), 1.8 + 2]);
}

module test_clip_hole() {
  difference() {
    cube([10, 10, 1.8]);
    translate([5, 5, 0]) clip_hole();
  }
}

module test_clip() {
  cube([10, 10, 1.8]);
  translate([10, 5, 0]) clip();
}

test_clip();
//translate([11.8, 0, -5]) rotate([0, -90, 0]) test_clip_hole();

translate([20, 0, 0]) test_clip_hole();
