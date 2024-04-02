/* Cargo Bay for the White Cat */

use <bend_cut.scad>;
use <clip.scad>;

module cargo_bay_exterior(thickness = 1.8) {
  height = 10;
  
  width = 50 * cos((180 - 360 / 12) / 2) * 6;
  
  difference() {
    cube([width, height, thickness]);
    
    translate([0 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    translate([1 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    translate([2 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    translate([3 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    translate([4 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    translate([5 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    translate([6 * width / 6, -1, 0]) rotate([0, 0, 90]) bend_cut(12, height+2, covered=true);
    
    translate([-1, 7, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 3, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  translate([1 * width / 6, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  translate([2 * width / 6, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  translate([3 * width / 6, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  translate([4 * width / 6, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  translate([5 * width / 6, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
  
  
  translate([width / 12, 10, 0]) rotate([0, 0, 90]) clip();
  translate([width / 12, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([11 * width / 12, 10, 0]) rotate([0, 0, 90]) clip();
  translate([11 * width / 12, 0, 0]) rotate([0, 0, -90]) clip();
  
}

module nose_exterior(thickness = 1.8) {
  height = 4;
  width = 12 * cos((180 - 360 / 6) / 2) * 3;
  
  translate([width, 0, 0]) rotate([0, 180, 0]) union() {
    difference() {
      cube([width, height, thickness * 2]);
      
      translate([0 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      translate([1 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      translate([2 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      translate([3 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
    }
    
    translate([width / 6, 0, thickness]) rotate([0, 0, -90]) clip();
    translate([5 * width / 6, 0, thickness]) rotate([0, 0, -90]) clip();
  }
}

module cargo_bay_top_cap(thickness = 1.8) {
  hole_r = 50 / 2 * sin((180 - 360 / 12) / 2) - 1.8;
  nose_hole_r = 12 / 2 * sin((180 - 360 / 6) / 2) - 1.8;

  difference() {
    cylinder(h = thickness, d = 50 + 2, $fn = 90);
    
    rotate([0, 0, 0 * 360 / 12]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 5 * 360 / 12]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 6 * 360 / 12]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 11 * 360 / 12]) translate([hole_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 2 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 5 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
  }
}

cargo_bay_exterior();

translate([0, 30, 0]) nose_exterior();

translate([0, 70, 0]) cargo_bay_top_cap();

