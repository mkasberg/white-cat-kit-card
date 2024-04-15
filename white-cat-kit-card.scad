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
nose_d = 12;
cargo_bay_d = 46;
top_section_inner_d = 26;
top_section_outer_d = 30 + 2 * thickness;
middle_d = 40;
bottom_section_d = 18;
bottom_ring_d = 26;
bottom_disc_d = middle_d;

cargo_bay_sides = 24;
top_inner_hull_sides = 16;
top_outer_hull_sides = 16;
bottom_hull_sides = 8;
bottom_ring_sides = 12;


module nose_exterior() {
  // Outside (flat hex side) diameter nose_d = 12
  // 45 deg slope over/up 2
  // interior diameter 8

  inner_r = 4;
  inner_side_w = inner_r / sin(60);
  outer_side_w = 6 / sin(60);
  diag_len_a = sqrt(2^2 + 2^2);
  nose_h = 3;
  tolerance = 0.1;

  difference() {
    rotate([0, 0, 360/6/2]) cylinder(d=2*inner_r / sin(60), h=thickness, $fn=6);

    for(i = [0:5]) {
      rotate([0, 0, i * 360/6]) translate([inner_r, -inner_side_w/2 - 1, 0]) rotate([0, 0, 90]) bend_cut(8, inner_side_w + 2);
    }
  }

  for(i = [0:5]) {
    rotate([0, 0, i * 360/6]) {
      difference() {
        linear_extrude(thickness) {
          polygon([
            [inner_r - 0.01, inner_side_w / 2 - tolerance],
            [inner_r + diag_len_a, outer_side_w / 2 - tolerance],
            [inner_r + diag_len_a + nose_h, outer_side_w / 2 - tolerance],
            [inner_r + diag_len_a + nose_h, -(outer_side_w / 2 - tolerance)],
            [inner_r + diag_len_a, -(outer_side_w / 2 - tolerance)],
            [inner_r - 0.01, -(inner_side_w / 2 - tolerance)]
          ]);
        }

        translate([inner_r, -inner_side_w/2 - 1, 0]) rotate([0, 0, 90]) bend_cut(8, inner_side_w + 2);
        translate([inner_r + diag_len_a, -outer_side_w/2 - 1, 0]) rotate([0, 0, 90]) bend_cut(8, outer_side_w + 2);

        diag_angle = atan((outer_side_w/2 - inner_side_w/2) / (diag_len_a));
        translate([inner_r - 0.02, inner_side_w / 2 - tolerance, 0]) rotate([0, 0, diag_angle]) bend_cut(6, 10);
        translate([inner_r - 0.02, -(inner_side_w / 2 - tolerance), 0]) rotate([0, 0, -diag_angle]) bend_cut(6, 10);

        translate([inner_r + diag_len_a - 1, outer_side_w / 2 - tolerance, 0]) bend_cut(6, nose_h + 2);
        translate([inner_r + diag_len_a - 1, -(outer_side_w / 2 - tolerance), 0]) bend_cut(6, nose_h + 2);
      }

      if (i % 3 == 0) {
        translate([inner_r + diag_len_a + nose_h, 0, 0]) clip();
      } else {
        translate([inner_r + diag_len_a + nose_h - 0.01, -0.9, 0]) cube([5.6, 1.8, 1.8]);
      }
    }
  }
}

module cargo_bay_top_cap() {
  hole_r = cargo_bay_d / 2 * sin((180 - 360 / cargo_bay_sides) / 2) - thickness;
  // Don't multiply by sin here since the nose_d is to flat hexagon sides.
  nose_hole_r = nose_d / 2 - thickness + 0.4;

  difference() {
    cylinder(h = thickness, d = cargo_bay_d + 2, $fn = 90);
    
    rotate([0, 0, 0 * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (cargo_bay_sides / 2 - 1) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (cargo_bay_sides / 2) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (cargo_bay_sides - 1) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    
    for (i = [0:5]) {
      rotate([0, 0, i * 360 / 6]) translate([nose_hole_r, 0, 0]) clip_hole();
    }

    translate([0, 0, thickness - 0.4]) difference() {
      cylinder(d = cargo_bay_d - 6, h = thickness, $fn = 90);

      translate([-6, -cargo_bay_d, 0]) cube([12, 2 * cargo_bay_d, thickness + 0.1]);
      translate([-cargo_bay_d, -6, 0]) cube([2 * cargo_bay_d, 12, thickness + 0.1]);
    }
  }
}

module cargo_bay_exterior() {
  height = 8;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / cargo_bay_sides) / 2);
  width = (cargo_bay_d - 2 * bend_thickness) * cos((180 - 360 / cargo_bay_sides) / 2) * (cargo_bay_sides / 2);
  
  difference() {
    cube([width, height, thickness]);

    for (i = [0:cargo_bay_sides/2]) {
      translate([i * width / (cargo_bay_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(cargo_bay_sides, height+2);
    }
    
    translate([-1, 5, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 3, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }

  side_w = width / (cargo_bay_sides / 2);
  for (i = [0:3]) {
    translate([3*i * side_w + (side_w - 1.8) / 2, 0, thickness - 0.001]) cube([1.8, height, 1]);
  }
  
  translate([width / cargo_bay_sides, height, 0]) rotate([0, 0, 90]) clip();
  translate([width / cargo_bay_sides, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([(cargo_bay_sides-1) * width / cargo_bay_sides, height, 0]) rotate([0, 0, 90]) clip();
  translate([(cargo_bay_sides-1) * width / cargo_bay_sides, 0, 0]) rotate([0, 0, -90]) clip();
}

module cargo_bay_bottom_cap() {
  hole_r = cargo_bay_d / 2 * sin((180 - 360 / cargo_bay_sides) / 2) - thickness;
  top_section_r = top_section_inner_d / 2 * sin((180 - 360 / top_inner_hull_sides) / 2) - thickness;
  top_outer_r = top_section_outer_d / 2 * sin((180 - 360 / top_outer_hull_sides) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = cargo_bay_d + 2, $fn = 90);
    
    rotate([0, 0, 0 * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (cargo_bay_sides / 2 - 1) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (cargo_bay_sides / 2) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (cargo_bay_sides - 1) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_inner_hull_sides / 2 - 1) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_inner_hull_sides / 2) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_inner_hull_sides - 1) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) clip_hole();

    for (i = [0:(top_outer_hull_sides/2 - 1)]) {
      rotate([0, 0, 2*i * 360 / top_outer_hull_sides]) translate([top_outer_r - 0.2, -(thickness + 0.6) / 2, -1]) cube([thickness + 0.4, thickness + 0.6, thickness + 2]);
    }

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = top_section_inner_d - 8, $fn=90);
  }
}

module top_section_inner_hull() {
  height = 21;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / top_inner_hull_sides) / 2);
  width = (top_section_inner_d - 2 * bend_thickness) * cos((180 - 360 / top_inner_hull_sides) / 2) * (top_inner_hull_sides / 2);
  
  difference() {
    cube([width, height, thickness]);
    
    for (i = [0:top_inner_hull_sides / 2]) {
      translate([i * width / (top_inner_hull_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(top_inner_hull_sides, height+2);
    }
  }
  
  translate([width / top_inner_hull_sides, height, 0]) rotate([0, 0, 90]) clip();
  translate([width / top_inner_hull_sides, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([(top_inner_hull_sides - 1) * width / top_inner_hull_sides, height, 0]) rotate([0, 0, 90]) clip();
  translate([(top_inner_hull_sides - 1) * width / top_inner_hull_sides, 0, 0]) rotate([0, 0, -90]) clip();
}

module top_section_outer_hull() {
  height = 12;
  beam_height = 21 - height + 3;
  extra_ring_r = (thickness - 0.2 * 3) / sin((180 - 360 / top_outer_hull_sides) / 2);
  width = (top_section_outer_d + 2 * extra_ring_r) * cos((180 - 360 / top_outer_hull_sides) / 2) * (top_outer_hull_sides / 2);

  difference() {
    union() {
      cube([width, height, thickness]);
      translate([0, 0, thickness - 0.01]) cube([width, 4, thickness]);
    }
    
    for (i = [0:top_outer_hull_sides/2]) {
      translate([i * width / (top_outer_hull_sides/2), -1, thickness - 0.2]) rotate([0, 0, 90]) bend_cut(top_outer_hull_sides, height+beam_height+2);
    }

    translate([-1, 9, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 7, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }

  side_w = width / (top_outer_hull_sides / 2);
  for (i = [0:3]) {
    translate([(2*i) * side_w + (side_w - thickness) / 2, height - 0.01, 0]) cube([thickness, beam_height, thickness]);
  }
  
  translate([width / top_outer_hull_sides, 0, 0]) rotate([0, 0, -90]) clip();
  translate([(top_outer_hull_sides - 1) * width / top_outer_hull_sides, 0, 0]) rotate([0, 0, -90]) clip();
}

module middle_disc() {
  top_inner_hole_r = top_section_inner_d / 2 * sin((180 - 360 / top_inner_hull_sides) / 2) - thickness;
  top_outer_hole_r = top_section_outer_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  bottom_hole_r = bottom_section_d / 2 * sin((180 - 360 / 8) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = middle_d, $fn = 90);
    
    rotate([0, 0, 0 * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_inner_hull_sides / 2 - 1) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_inner_hull_sides / 2) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_inner_hull_sides - 1) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_outer_hull_sides / 2 - 1) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_outer_hull_sides / 2) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (top_outer_hull_sides - 1) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) clip_hole();

    rotate([0, 0, 0 * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_hull_sides / 2 - 1) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_hull_sides / 2) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_hull_sides - 1) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) clip_hole();

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = bottom_section_d - 8, $fn=90);
  }
}

module bottom_section_hull(side_a = true) {
  height = 45;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / bottom_hull_sides) / 2);
  width = (bottom_section_d - 2 * bend_thickness) * cos((180 - 360 / bottom_hull_sides) / 2) * (bottom_hull_sides / 2);
  
  side_w = width / (bottom_hull_sides / 2);
  inner_w = side_w - 2;

  difference() {
    cube([width, height, thickness]);
    
    // Treat it as if it has 8 sides everywhere else, but we actually do extra bends for 16 sides in the middle part.
    translate([0 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);
    translate([1 * width / 4, -1, 0]) rotate([0, 0, 90]) transition_bend_cut(8, 16, height+2);
    translate([3 * width / 8, -1, 0]) rotate([0, 0, 90]) bend_cut(16, height+2);
    translate([4 * width / 8, -1, 0]) rotate([0, 0, 90]) bend_cut(16, height+2);
    translate([5 * width / 8, -1, 0]) rotate([0, 0, 90]) bend_cut(16, height+2);
    translate([3 * width / 4, -1, 0]) rotate([0, 0, 90]) transition_bend_cut(16, 8, height+2);
    translate([4 * width / 4, -1, 0]) rotate([0, 0, 90]) bend_cut(8, height+2);

    if (!side_a) {
      translate([side_w / 2, 14, 0.75 * inner_w + thickness - 1]) sphere(d = 1.5 * inner_w, $fn=12);
    }
  }

  if (side_a) {
    translate([1, 12, thickness - 0.01]) cube([inner_w, inner_w * 2, thickness]);
    translate([1, 23, thickness - 0.01]) cube([inner_w, inner_w, thickness]);
    translate([1, 29, thickness - 0.01]) cube([inner_w, inner_w, thickness]);
    translate([3.5 * side_w, 5, thickness]) rotate([-90, 0, 0]) cylinder(d = 1, h = height/2-10, $fn=24);
  } else {
    translate([3.5 * side_w, 5, thickness]) rotate([-90, 0, 0]) cylinder(d = 1, h = height-10, $fn=24);
  }
  
  translate([width / bottom_hull_sides, height, 0]) rotate([0, 0, 90]) clip();
  translate([width / bottom_hull_sides, 0, 0]) rotate([0, 0, -90]) clip();
  
  translate([(bottom_hull_sides - 1) * width / bottom_hull_sides, height, 0]) rotate([0, 0, 90]) clip();
  translate([(bottom_hull_sides - 1) * width / bottom_hull_sides, 0, 0]) rotate([0, 0, -90]) clip();
}

module bottom_ring_hull(side_a = true) {
  height = 10;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 0.2 / sin((180 - 360 / bottom_ring_sides) / 2);
  width = (bottom_ring_d - 2 * bend_thickness) * cos((180 - 360 / bottom_ring_sides) / 2) * (bottom_ring_sides / 2);
  
  side_w = width / (bottom_ring_sides / 2);

  difference() {
    cube([width, height, thickness]);
    
    for (i = [0:bottom_ring_sides/2]) {
      translate([i * width / (bottom_ring_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(bottom_ring_sides, height+2);
    }

    translate([-1, 4, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  if (side_a) {
    difference() {
      translate([side_w / 2, 7, 0]) sphere(d = side_w - 0.6, $fn=36);
      translate([-2, 0, -10 + thickness - 0.01]) cube([10, 10, 10]);
    }
  }
  
  translate([width / bottom_ring_sides, 0, 0]) rotate([0, 0, -90]) clip();
  translate([(bottom_ring_sides - 1) * width / bottom_ring_sides, 0, 0]) rotate([0, 0, -90]) clip();
}

module bottom_disc() {
  bottom_section_r = bottom_section_d / 2 * sin((180 - 360 / 8) / 2) - thickness;
  bottom_ring_r = bottom_ring_d / 2 * sin((180 - 360 / 8) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = bottom_disc_d, $fn = 90);
    
    rotate([0, 0, 0 * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_hull_sides / 2 - 1) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_hull_sides / 2) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_hull_sides - 1) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) clip_hole();
    
    rotate([0, 0, 0 * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_ring_sides / 2 - 1) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_ring_sides / 2) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) clip_hole();
    rotate([0, 0, (bottom_ring_sides - 1) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) clip_hole();

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = 8, $fn = 90);
  }
}

module build_plate() {
  translate([0, 0, -1.01]) color("gray", 0.5) cube([180, 180, 1]);
}

//build_plate();

translate([70, 20, 0]) nose_exterior();

translate([0, 150, 0]) cargo_bay_exterior();
translate([0, 130, 0]) cargo_bay_exterior();

translate([0, 95, 0]) top_section_inner_hull();
translate([50, 95, 0]) top_section_inner_hull();

translate([0, 40, 0]) top_section_outer_hull();
translate([58, 85, 0]) rotate([0, 0, 180]) top_section_outer_hull();

translate([65, 40, 0]) bottom_section_hull(true);
translate([95, 40, 0]) bottom_section_hull(false);

translate([0, 10, 0]) bottom_ring_hull(true);
translate([0, 25, 0]) bottom_ring_hull(false);


translate([150, 140, 0]) cargo_bay_top_cap();
translate([150, 80, 0]) cargo_bay_bottom_cap();
translate([140, 22, 0]) middle_disc();
translate([102, 150, 0]) bottom_disc();

