/* A clip with a ledge on one side. */

module flat_clip(width, thickness = 1.6, length_tolerance = 0.2) {
  translate([0, width / 2, 0]) rotate([90, 0, 0]) linear_extrude(width) {
    polygon([
      [-0.01, 0],
      [-0.01, 0.8],
      [thickness + length_tolerance, 0.8],
      [thickness + length_tolerance + 0.4, 1.4],
      [thickness + length_tolerance + 0.8, 1.4],
      [thickness + 1.6, 0.4],
      [thickness + 1.6, 0],
    ]);
  }
}

module flat_clip_hole(width) {
  side_tolerance = 0.3;
  clip_tolerance = 0.1;
  translate([0, -(width / 2 + side_tolerance), -1]) cube([1.6 + clip_tolerance, width + 2*side_tolerance, 1.6 + 2]);
}

module test_flat_clip() {
  cube([10, 10, 1.6]);
  translate([10, 5, 0]) clip(4);
}

module test_flat_clip_hole() {
  difference() {
    cube([10, 10, 1.6]);
    translate([5, 5, 0]) clip_hole(4);
  }
}

test_flat_clip();

translate([20, 0, 0]) test_flat_clip_hole();
