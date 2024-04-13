/*
White Cat (from Theft of Fire)

A 3D Kit Card by Mike Kasberg

See the White Cat in this image:
https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1698083266i/199142773.jpg

Kit card design tips:
https://3dwithus.com/how-to-design-kit-card-models
*/

use <bend_cut.scad>;
use <clip.scad>;

thickness = 1.8;
nose_d = 14;
cargo_bay_d = 50;
top_section_inner_d = 26;
top_section_outer_d = 31 + 2 * thickness;
middle_d = 42;
bottom_section_d = 18;
bottom_ring_d = 26;
bottom_disc_d = middle_d;

module nose_exterior() {
  height = 5;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / 6) / 2);
  width = (nose_d - 2 * bend_thickness) * cos((180 - 360 / 6) / 2) * 3;
  
  translate([width, 0, thickness * 2]) rotate([0, 180, 0]) union() {
    difference() {
      cube([width, height, thickness * 2]);
      
      translate([0 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      translate([1 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      translate([2 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      translate([3 * width / 3, -1, thickness]) rotate([0, 0, 90]) bend_cut(6, height+2);
      
      translate([-1, height + thickness, 0])
        rotate([-45, 0, 0])
        translate([0, -2 * height, 0])
        cube([width + 2, 2 * height, 2 * thickness]);
    }
    
    translate([width / 6, 0, thickness]) rotate([0, 0, -90]) clip();
    translate([5 * width / 6, 0, thickness]) rotate([0, 0, -90]) clip();
  }
}

module cargo_bay_top_cap() {
  hole_r = cargo_bay_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  nose_hole_r = nose_d / 2 * sin((180 - 360 / 6) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = cargo_bay_d + 2, $fn = 90);
    
    rotate([0, 0, 0 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 2 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 5 * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
  }
}

module cargo_bay_exterior() {
  height = 10;
  // extra_r for the bend caps.
  extra_r = 3 * 0.2 / sin((180 - 360 / 8) / 2);
  width = (cargo_bay_d + 2 * extra_r) * cos((180 - 360 / 8) / 2) * 4;
  
  difference() {
    union() {
      cube([width, height, thickness]);

      difference() {
        translate([0 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
        translate([-10, -1, -1]) cube([10, height + 2, thickness + 2]);
      }
      translate([1 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
      translate([2 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
      translate([3 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
      difference() {
        translate([4 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
        translate([width, -1, -1]) cube([10, height + 2, thickness + 2]);
      }
    }
    
    translate([0 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([1 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([2 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([3 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([4 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    
    translate([-1, 7, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 3, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  translate([width / 8, height, 0]) rotate([0, 0, 90]) clip();
  translate([width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([7 * width / 8, height, 0]) rotate([0, 0, 90]) clip();
  translate([7 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
}

module cargo_bay_bottom_cap() {
  hole_r = cargo_bay_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  top_section_r = top_section_inner_d / 2 * sin((180 - 360 / 8) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = cargo_bay_d + 2, $fn = 90);
    
    rotate([0, 0, 0 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([hole_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / 8]) translate([top_section_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([top_section_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([top_section_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([top_section_r, 0, 0]) clip_hole();
  }
}

module top_section_inner_hull() {
  height = 25;
  // extra_r for the bend caps.
  extra_r = 3 * 0.2 / sin((180 - 360 / 6) / 2);
  width = (top_section_inner_d + 2 * extra_r) * cos((180 - 360 / 8) / 2) * 4;
  
  difference() {
    union() {
      cube([width, height, thickness]);

      difference() {
        translate([0 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
        translate([-10, -1, -1]) cube([10, height + 2, thickness + 2]);
      }
      translate([1 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
      translate([2 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
      translate([3 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
      difference() {
        translate([4 * width / 4, 0, 0]) rotate([0, 0, 90]) big_bend_cap(height);
        translate([width, -1, -1]) cube([10, height + 2, thickness + 2]);
      }
    }
    
    translate([0 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([1 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([2 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([3 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
    translate([4 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2, covered=true);
  }
  

  
  translate([width / 8, height, 0]) rotate([0, 0, 90]) clip();
  translate([width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([7 * width / 8, height, 0]) rotate([0, 0, 90]) clip();
  translate([7 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
}

module top_section_outer_hull() {
  height = 15;
  beam_height = 25 - height;
  extra_ring_r = (thickness - 0.2 * 3) / sin((180 - 360 / 6) / 2);
  width = (top_section_outer_d + 2 * extra_ring_r) * cos((180 - 360 / 8) / 2) * 4;

  difference() {
    union() {
      cube([width, height, thickness]);
      translate([0, 3, thickness - 0.01]) cube([width, 2, thickness]);

      difference() {
        translate([0 * width / 4 - thickness, height - 0.1, 0]) cube([2 * thickness, beam_height, thickness]);
        translate([-10, -1, -1]) cube([10, height + beam_height + 2, thickness + 2]);
      }
      translate([1 * width / 4 - thickness, height - 0.1, 0]) cube([2 * thickness, beam_height, thickness]);
      translate([2 * width / 4 - thickness, height - 0.1, 0]) cube([2 * thickness, beam_height, thickness]);
      translate([3 * width / 4 - thickness, height - 0.1, 0]) cube([2 * thickness, beam_height, thickness]);
      difference() {
        translate([4 * width / 4 - thickness, height - 0.1, 0]) cube([2 * thickness, beam_height, thickness]);
        translate([width, -1, -1]) cube([10, height + beam_height + 2, thickness + 2]);
      }
    }
    
    translate([0 * width / 4, -1, thickness - 0.2]) rotate([0, 0, 90]) bend_cut(8, height+beam_height+2);
    translate([1 * width / 4, -1, thickness - 0.2]) rotate([0, 0, 90]) bend_cut(8, height+beam_height+2);
    translate([2 * width / 4, -1, thickness - 0.2]) rotate([0, 0, 90]) bend_cut(8, height+beam_height+2);
    translate([3 * width / 4, -1, thickness - 0.2]) rotate([0, 0, 90]) bend_cut(8, height+beam_height+2);
    translate([4 * width / 4, -1, thickness - 0.2]) rotate([0, 0, 90]) bend_cut(8, height+beam_height+2);

    translate([-1, 12, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 9, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  translate([width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  translate([7 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
}

module middle_disc() {
  top_top_hole_r = top_section_inner_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  top_bottom_hole_r = top_section_outer_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  bottom_hole_r = bottom_section_d / 2 * sin((180 - 360 / 8) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = middle_d, $fn = 90);
    
    rotate([0, 0, 0 * 360 / 8]) translate([top_top_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([top_top_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([top_top_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([top_top_hole_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / 8]) translate([top_bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([top_bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([top_bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([top_bottom_hole_r, 0, 0]) clip_hole();

    rotate([0, 0, 0 * 360 / 8]) translate([bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([bottom_hole_r, 0, 0]) clip_hole();
  }
}

module bottom_section_hull() {
  height = 45;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / 8) / 2);
  width = (bottom_section_d - 2 * bend_thickness) * cos((180 - 360 / 8) / 2) * 4;
  
  difference() {
    cube([width, height, thickness]);
    
    translate([0 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([1 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([2 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([3 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([4 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
  }

  inner_w = width / 4 - 2;

  translate([1, 12, thickness - 0.01]) cube([inner_w, inner_w * 2, thickness]);
  translate([1, 23, thickness - 0.01]) cube([inner_w, inner_w, thickness]);
  translate([1, 29, thickness - 0.01]) cube([inner_w, inner_w, thickness]);
  
  translate([width / 8, height, 0]) rotate([0, 0, 90]) clip();
  translate([width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([7 * width / 8, height, 0]) rotate([0, 0, 90]) clip();
  translate([7 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
}

module bottom_ring_hull() {
  height = 10;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / 8) / 2);
  width = (bottom_ring_d - 2 * bend_thickness) * cos((180 - 360 / 8) / 2) * 4;
  
  difference() {
    cube([width, height, thickness]);
    
    translate([0 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([1 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([2 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([3 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([4 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);

    translate([-1, 4, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  translate([width / 8, 0, 0]) rotate([0, 0, -90]) clip();
  translate([7 * width / 8, 0, 0]) rotate([0, 0, -90]) clip();
}

module bottom_disc() {
  bottom_section_r = bottom_section_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  bottom_ring_r = bottom_ring_d / 2 * sin((180 - 360 / 8) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = bottom_disc_d, $fn = 90);
    
    rotate([0, 0, 0 * 360 / 8]) translate([bottom_section_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([bottom_section_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([bottom_section_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([bottom_section_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / 8]) translate([bottom_ring_r, 0, 0]) clip_hole();
    rotate([0, 0, 3 * 360 / 8]) translate([bottom_ring_r, 0, 0]) clip_hole();
    rotate([0, 0, 4 * 360 / 8]) translate([bottom_ring_r, 0, 0]) clip_hole();
    rotate([0, 0, 7 * 360 / 8]) translate([bottom_ring_r, 0, 0]) clip_hole();

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = 8, $fn = 90);
  }
}

module build_plate() {
  translate([0, 0, -1.01]) color("gray", 0.5) cube([180, 180, 1]);
}

//build_plate();

translate([0, 170, 0]) nose_exterior();
translate([30, 170, 0]) nose_exterior();

translate([0, 150, 0]) cargo_bay_exterior();
translate([0, 130, 0]) cargo_bay_exterior();

translate([0, 95, 0]) top_section_inner_hull();
translate([50, 95, 0]) top_section_inner_hull();

translate([0, 40, 0]) top_section_outer_hull();
translate([63, 85, 0]) rotate([0, 0, 180]) top_section_outer_hull();

translate([65, 40, 0]) bottom_section_hull();
translate([95, 40, 0]) bottom_section_hull();

translate([0, 10, 0]) bottom_ring_hull();
translate([0, 25, 0]) bottom_ring_hull();


translate([150, 140, 0]) cargo_bay_top_cap();
translate([150, 80, 0]) cargo_bay_bottom_cap();
translate([140, 22, 0]) middle_disc();
translate([102, 150, 0]) bottom_disc();

