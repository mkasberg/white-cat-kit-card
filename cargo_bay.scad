/* Cargo Bay for the White Cat */

use <bend_cut.scad>;
use <clip.scad>;

module cargo_bay_exterior(thickness = 1.8) {
  height = 10;
  
  width = 50 * cos(67.5) * 4;
  
  difference() {
    cube([width, 10, thickness]);
    
    translate([width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, 12);
    translate([2 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, 12);
    translate([3 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, 12);
    translate([0, -1, 0]) rotate([0, 0, 90]) bend_cut(8, 12);
    translate([width, -1, 0]) rotate([0, 0, 90]) bend_cut(8, 12);
    
    translate([-1, 7, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 3, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  translate([width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  translate([2 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  translate([3 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  
  
  translate([width / 8, 10, 0]) rotate([0, 0, 90]) clip();
  translate([width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([3 *width / 8, 10, 0]) rotate([0, 0, 90]) clip();
  translate([3 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([5 * width / 8, 10, 0]) rotate([0, 0, 90]) clip();
  translate([5 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([7 * width / 8, 10, 0]) rotate([0, 0, 90]) clip();
  translate([7 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
}

module cargo_bay_top_cap(thickness = 1.8) {
  hole_r = 50 / 2 * sin(67.5);

  difference() {
    cylinder(h = thickness, d = 50 + 2, $fn = 90);
    
    translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 2 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 5 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 6 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
  }
}

//cargo_bay_exterior();

cargo_bay_top_cap();
