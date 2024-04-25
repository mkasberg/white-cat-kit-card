/* A clip with a ledge on one side. */

module flat_clip(width, thickness = 1.6, length_tolerance = 0.2) {
  // thickness is not of the clip itself, but for the depth of the clip.
  // clip_thickness is for the clip itself.
  clip_thickness = 0.8;
  translate([0, width / 2, 0]) rotate([90, 0, 0]) linear_extrude(width) {
    polygon([
      [-0.01, 0],
      [-0.01, clip_thickness],
      [thickness + length_tolerance, clip_thickness],
      [thickness + length_tolerance + 0.4, clip_thickness + 0.6],
      [thickness + length_tolerance + 0.8, clip_thickness + 0.6],
      [thickness + length_tolerance + 1.4, 0.4],
      [thickness + length_tolerance + 1.4, 0],
    ]);
  }
}

module flat_clip_hole(width) {
  side_tolerance = 0.25;
  clip_tolerance = 0.1;
  thickness = 1.6;
  clip_thickness = 0.8;
  // Position so that at [0, 0] translation, it's correctly positioned for a clip directly right of [0, 0]. (Move all the unfilled part of the hole left of the origin.)
  left_shift = (thickness + clip_tolerance) - clip_thickness;
  translate([-left_shift, -(width / 2 + side_tolerance), -1]) cube([thickness + clip_tolerance, width + 2*side_tolerance, 2 * thickness + 2]);
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
