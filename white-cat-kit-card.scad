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
use <flat_clip.scad>;
use <kit_frame.scad>;

thickness = 1.6;

cargo_bay_sides = 18;
top_inner_hull_sides = 12;
top_outer_hull_sides = 18;
bottom_hull_sides = 12;
bottom_ring_sides = 12;

// nose_d is the shorter diameter (flat hex edge).
nose_d = 14;
// All diameters below are the longer diameter (vertex to vertex).
cargo_bay_d = 46;
top_section_inner_d = 27;
top_section_outer_d = 33;
middle_d = 40;
bottom_section_d = 22;
bottom_ring_d = 28;
bottom_disc_d = 36;



module nose_exterior() {
  // Outside (flat hex side) diameter nose_d = 14
  // 45 deg slope over/up 2
  // interior diameter 10

  inner_r = 5;
  inner_side_w = inner_r / sin(60);
  outer_side_w = 7 / sin(60);
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

      translate([inner_r + diag_len_a + nose_h, 0, 0]) flat_clip(3);
      // if (i % 3 == 0) {
      //   translate([inner_r + diag_len_a + nose_h, 0, 0]) clip();
      // } else {
      //   translate([inner_r + diag_len_a + nose_h - 0.01, -thickness/2, 0]) cube([5.6, thickness, thickness]);
      // }
    }
  }
}

module cargo_bay_top_cap() {
  hole_r = cargo_bay_d / 2 * sin((180 - 360 / cargo_bay_sides) / 2) - thickness;
  // Don't multiply by sin here since the nose_d is to flat hexagon sides.
  nose_hole_r = nose_d / 2 - thickness + 0.4;

  difference() {
    cylinder(h = thickness + 0.4, d = cargo_bay_d + 2, $fn = 90);
    
    rotate([0, 0, 0.5 * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides / 2 - 1 + 0.5) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides / 2 + 0.5) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides - 1 + 0.5) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides / 4) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (3 * cargo_bay_sides / 4) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    
    for (i = [0:5]) {
      rotate([0, 0, i * 360 / 6]) translate([nose_hole_r, 0, 0]) flat_clip_hole(3);
    }

    translate([0, 0, thickness - 0.4]) difference() {
      cylinder(d = cargo_bay_d - 6, h = thickness, $fn = 90);

      translate([-6, -cargo_bay_d, 0]) cube([12, 2 * cargo_bay_d, thickness + 0.4 + 0.1]);
      translate([-cargo_bay_d, -6, 0]) cube([2 * cargo_bay_d, 12, thickness + 0.4 + 0.1]);
    }
  }
}

module cargo_bay_exterior() {
  height = 8;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 2 * 0.2 / sin((180 - 360 / cargo_bay_sides) / 2);
  extra_tolerance = 0.1;
  width = (cargo_bay_d - 2 * bend_thickness) * cos((180 - 360 / cargo_bay_sides) / 2) * (cargo_bay_sides / 2) - extra_tolerance;
  
  translate([-width/2, -height/2, 0]) {
    difference() {
      cube([width, height, thickness]);

      for (i = [0:cargo_bay_sides/2]) {
        translate([i * width / (cargo_bay_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(cargo_bay_sides, height+2);
      }
      
      translate([-1, 5, thickness - 0.4]) cube([width + 2, 0.4, 1]);
      translate([-1, 3, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    }

    side_w = width / (cargo_bay_sides / 2);
    for (i = [0:2]) {
      translate([(3*i + 1) * side_w + (side_w - 1.6) / 2, 0, thickness - 0.001]) cube([1.6, height, 1]);
    }
    
    translate([width / cargo_bay_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([width / cargo_bay_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);

    middle_side = (cargo_bay_sides / 2);
    translate([middle_side * width / cargo_bay_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([middle_side * width / cargo_bay_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
    
    translate([(cargo_bay_sides-1) * width / cargo_bay_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([(cargo_bay_sides-1) * width / cargo_bay_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
  }
}

module cargo_bay_bottom_cap() {
  hole_r = cargo_bay_d / 2 * sin((180 - 360 / cargo_bay_sides) / 2) - thickness;
  top_section_r = top_section_inner_d / 2 * sin((180 - 360 / top_inner_hull_sides) / 2) - thickness;
  top_outer_r = top_section_outer_d / 2 * sin((180 - 360 / top_outer_hull_sides) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = cargo_bay_d + 2, $fn = 90);
    
    rotate([0, 0, 0.5 * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides / 2 - 1 + 0.5) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides / 2 + 0.5) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides - 1 + 0.5) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (cargo_bay_sides / 4) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (3 * cargo_bay_sides / 4) * 360 / cargo_bay_sides]) translate([hole_r, 0, 0]) flat_clip_hole(4);
    
    rotate([0, 0, 0.5 * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 4 - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 4 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 2 - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 2 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides * 3 / 4 - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides * 3 / 4 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_section_r, 0, 0]) flat_clip_hole(4);

    for (i = [0:(top_outer_hull_sides/3 - 1)]) {
      rotate([0, 0, (3*i + 1 + 0.5) * 360 / top_outer_hull_sides]) translate([top_outer_r - 0.2, -(thickness + 0.6) / 2, -1]) cube([thickness + 0.6, thickness + 0.6, thickness + 2]);
    }

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = top_section_inner_d - 10, $fn=90);
  }
}

module top_section_inner_hull() {
  height = 21;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 2 * 0.2 / sin((180 - 360 / top_inner_hull_sides) / 2);
  extra_tolerance = 0.05;
  width = (top_section_inner_d - 2 * bend_thickness) * cos((180 - 360 / top_inner_hull_sides) / 2) * (top_inner_hull_sides / 2) - extra_tolerance;
  
  translate([0, -height/2, 0]) {
    difference() {
      cube([width, height, thickness]);
      
      for (i = [0:top_inner_hull_sides / 2]) {
        translate([i * width / (top_inner_hull_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(top_inner_hull_sides, height+2);
      }
    }
    
    translate([width / top_inner_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([width / top_inner_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
    translate([(top_inner_hull_sides / 2 - 1) * width / top_inner_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([(top_inner_hull_sides / 2 - 1) * width / top_inner_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
    translate([(top_inner_hull_sides / 2 + 1) * width / top_inner_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([(top_inner_hull_sides / 2 + 1) * width / top_inner_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
    translate([(top_inner_hull_sides - 1) * width / top_inner_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(4);
    translate([(top_inner_hull_sides - 1) * width / top_inner_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
  }
}

module top_section_outer_hull() {
  height = 12;
  beam_height = 21 - height + 6;
  extra_ring_r = (thickness - 0.2 * 3) / sin((180 - 360 / top_outer_hull_sides) / 2);
  extra_tolerance = 0.0;
  width = (top_section_outer_d + 2 * extra_ring_r) * cos((180 - 360 / top_outer_hull_sides) / 2) * (top_outer_hull_sides / 2) - extra_tolerance;

  difference() {
    union() {
      cube([width, height, thickness]);
      translate([0, 0, thickness - 0.01]) cube([width, 4, thickness]);
    }
    
    for (i = [0:top_outer_hull_sides/2]) {
      translate([i * width / (top_outer_hull_sides/2), -1, thickness]) rotate([0, 0, 90]) bend_cut(top_outer_hull_sides, height+beam_height+2);
    }

    translate([-1, 9, thickness - 0.4]) cube([width + 2, 0.4, 1]);
    translate([-1, 7, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }

  side_w = width / (top_outer_hull_sides / 2);
  for (i = [0:2]) {
    translate([(3*i + 1) * side_w + (side_w - thickness) / 2, height - 0.01, 0]) cube([thickness, beam_height, thickness + 0.4]);
  }
  
  translate([width / top_outer_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
  translate([(top_outer_hull_sides/2) * width / top_outer_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
  translate([(top_outer_hull_sides - 1) * width / top_outer_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
}

module middle_disc() {
  top_inner_hole_r = top_section_inner_d / 2 * sin((180 - 360 / top_inner_hull_sides) / 2) - thickness;
  top_outer_hole_r = top_section_outer_d / 2 * sin((180 - 360 / top_outer_hull_sides) / 2) - thickness;
  bottom_hole_r = bottom_section_d / 2 * sin((180 - 360 / bottom_hull_sides) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = middle_d, $fn = 90);
    
    rotate([0, 0, 0.5 * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 4 - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 4 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 2 - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides / 2 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides * 3 / 4 - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides * 3 / 4 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (top_inner_hull_sides - 1 + 0.5) * 360 / top_inner_hull_sides]) translate([top_inner_hole_r, 0, 0]) flat_clip_hole(4);
    
    rotate([0, 0, 0.5 * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (top_outer_hull_sides / 2 - 1 + 0.5) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (top_outer_hull_sides / 2 + 0.5) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (top_outer_hull_sides - 1 + 0.5) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (top_outer_hull_sides / 4) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (3 * top_outer_hull_sides / 4) * 360 / top_outer_hull_sides]) translate([top_outer_hole_r, 0, 0]) flat_clip_hole(3);

    rotate([0, 0, 0.5 * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 4 - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 4 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 2 - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 2 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides * 3 / 4 - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides * 3 / 4 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_hole_r, 0, 0]) flat_clip_hole(3);

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = bottom_section_d - 10, $fn=90);
  }
}

module satellite_dish(d) {
  difference() {
    sphere(d = d, $fn=36);

    sphere(d = d - 0.8, $fn = 36);

    translate([-(d/2 + 1), -(d/2 + 1), -0.15 * d]) cube([d + 2, d + 2, d + 2]);
  }
}

module bottom_section_hull(side_a = true) {
  height = 40;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 2 * 0.2 / sin((180 - 360 / bottom_hull_sides) / 2);
  extra_tolerance = 0.0;
  width = (bottom_section_d - 2 * bend_thickness) * cos((180 - 360 / bottom_hull_sides) / 2) * (bottom_hull_sides / 2) - extra_tolerance;
  
  side_w = width / (bottom_hull_sides / 2);
  inner_w = side_w - 2;

  difference() {
    cube([width, height, thickness]);
    
    for (i = [0:bottom_hull_sides/2]) {
      translate([i * width / (bottom_hull_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(bottom_hull_sides, height+2);
    }

    if (!side_a) {
      translate([(bottom_hull_sides - 1) * side_w / 2, 12, 0.75 * inner_w + thickness - 1]) sphere(d = 1.5 * inner_w, $fn=36);
    }
  }

  if (side_a) {
    translate([1, 10, thickness - 0.01]) cube([inner_w, inner_w * 2, thickness]);
    translate([1, 21, thickness - 0.01]) cube([inner_w, inner_w, thickness]);
    translate([1, 27, thickness - 0.01]) cube([inner_w, inner_w, thickness]);
    translate([3.5 * side_w, 5, thickness]) rotate([-90, 0, 0]) cylinder(d = 1.2, h = height/2-10, $fn=24);
  } else {
    translate([(bottom_hull_sides - 1) * side_w / 2, 12, 0.75 * inner_w + thickness - 1.01]) satellite_dish(d = 1.5 * inner_w, $fn=36);
    translate([2.5 * side_w, 5, thickness]) rotate([-90, 0, 0]) cylinder(d = 1.2, h = height-10, $fn=24);
  }
  
  translate([width / bottom_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(3);
  translate([width / bottom_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
  translate([(bottom_hull_sides / 2 - 1) * width / bottom_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(3);
  translate([(bottom_hull_sides / 2 - 1) * width / bottom_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
  translate([(bottom_hull_sides / 2 + 1) * width / bottom_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(3);
  translate([(bottom_hull_sides / 2 + 1) * width / bottom_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
  translate([(bottom_hull_sides - 1) * width / bottom_hull_sides, height, 0]) rotate([0, 0, 90]) flat_clip(3);
  translate([(bottom_hull_sides - 1) * width / bottom_hull_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(3);
}

module bottom_ring_hull(side_a = true) {
  height = 8;
  // Remove 0.2 from diameter on each side to account for bend.
  bend_thickness = 2 * 0.2 / sin((180 - 360 / bottom_ring_sides) / 2);
  extra_tolerance = 0.0;
  width = (bottom_ring_d - 2 * bend_thickness) * cos((180 - 360 / bottom_ring_sides) / 2) * (bottom_ring_sides / 2) - extra_tolerance;
  
  side_w = width / (bottom_ring_sides / 2);

  difference() {
    cube([width, height, thickness]);
    
    for (i = [0:bottom_ring_sides/2]) {
      translate([i * width / (bottom_ring_sides / 2), -1, 0]) rotate([0, 0, 90]) bend_cut(bottom_ring_sides, height+2);
    }

    translate([-1, 2, thickness - 0.4]) cube([width + 2, 0.4, 1]);
  }
  
  if (side_a) {
    translate([5*side_w/2, 5, thickness]) cylinder(d = side_w - 2, h = 0.6 + 0.01, $fn=36);
  }
  
  translate([width / bottom_ring_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
  translate([(bottom_ring_sides / 2 - 1) * width / bottom_ring_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
  translate([(bottom_ring_sides / 2 + 1) * width / bottom_ring_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
  translate([(bottom_ring_sides - 1) * width / bottom_ring_sides, 0, 0]) rotate([0, 0, -90]) flat_clip(4);
}

module bottom_disc() {
  bottom_section_r = bottom_section_d / 2 * sin((180 - 360 / bottom_hull_sides) / 2) - thickness;
  bottom_ring_r = bottom_ring_d / 2 * sin((180 - 360 / bottom_ring_sides) / 2) - thickness;

  difference() {
    cylinder(h = thickness, d = bottom_disc_d, $fn = 90);
    
    rotate([0, 0, 0.5 * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 4 - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 4 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 2 - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides / 2 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides * 3 / 4 - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides * 3 / 4 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    rotate([0, 0, (bottom_hull_sides - 1 + 0.5) * 360 / bottom_hull_sides]) translate([bottom_section_r, 0, 0]) flat_clip_hole(3);
    
    rotate([0, 0, 0.5 * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides / 4 - 1 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides / 4 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides / 2 - 1 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides / 2 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides * 3 / 4 - 1 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides * 3 / 4 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);
    rotate([0, 0, (bottom_ring_sides - 1 + 0.5) * 360 / bottom_ring_sides]) translate([bottom_ring_r, 0, 0]) flat_clip_hole(4);

    translate([0, 0, -1]) cylinder(h = thickness + 2, d = 6, $fn = 90);
  }
}

module build_plate() {
  translate([0, 0, -1.01]) color("gray", 0.5) cube([180, 180, 1]);
}

module layout_parts() {
  frame_margin = 4;
  top_disc_r = (cargo_bay_d + 2) / 2;
  translate([top_disc_r + frame_margin, 180 - top_disc_r - frame_margin, 0]) cargo_bay_top_cap();
  translate([180 - top_disc_r - frame_margin, 180 - top_disc_r - frame_margin, 0]) cargo_bay_bottom_cap();

  translate([90, 180 - frame_margin - top_disc_r - 3, 0]) nose_exterior();

  translate([90, 180 - frame_margin - top_disc_r + 18, 0]) cargo_bay_exterior();
  translate([90, 180 - frame_margin - top_disc_r - 24, 0]) cargo_bay_exterior();

  middle_disc_r = middle_d / 2;
  translate([frame_margin + middle_disc_r, 180 - frame_margin - 2 * top_disc_r - frame_margin - middle_disc_r, 0]) middle_disc();
  translate([180 - frame_margin - middle_disc_r, 180 - frame_margin - 2 * top_disc_r - frame_margin - middle_disc_r, 0]) bottom_disc();

  translate([90 + 2, 180 - frame_margin - 2 * top_disc_r - frame_margin - middle_disc_r, 0]) top_section_inner_hull();
  translate([90 - 2, 180 - frame_margin - 2 * top_disc_r - frame_margin - middle_disc_r, 0]) mirror([1, 0, 0]) top_section_inner_hull();

  translate([90 + 2, 40, 0]) bottom_section_hull(true);
  translate([90 - 2, 40, 0]) mirror([1, 0, 0]) bottom_section_hull(false);

  translate([90 + 2, 25, 0]) bottom_ring_hull(true);
  translate([90 - 2, 25, 0]) mirror([1, 0, 0]) bottom_ring_hull(false);


  translate([38, 24, 0]) rotate([0, 0, 90]) top_section_outer_hull();
  translate([180 - 38, 24, 0]) mirror([1, 0, 0]) rotate([0, 0, 90]) top_section_outer_hull();
}

module kit_frame() {
  frame_margin = 4;
  top_disc_r = (cargo_bay_d + 2) / 2;
  // Carbo Bay top
  translate([0, 180 - top_disc_r - frame_margin, 0]) wire(frame_margin, false, true);
  translate([top_disc_r + frame_margin, 180, 0]) rotate([0, 0, -90]) wire(frame_margin, false, true);

  // Cargo bay bottom
  translate([180, 180 - top_disc_r - frame_margin, 0]) rotate([0, 0, 180]) wire(frame_margin, false, true);
  translate([180 - (top_disc_r + frame_margin), 180, 0]) rotate([0, 0, -90]) wire(frame_margin, false, true);

  // Middle Disc
  middle_disc_r = middle_d / 2;
  translate([0, 180 - frame_margin - 2 * top_disc_r - frame_margin - middle_disc_r, 0]) wire(frame_margin, false, true);

  // Bottom Disc
  bottom_disc_r = bottom_disc_d / 2;
  translate([180, 180 - frame_margin - 2 * top_disc_r - frame_margin - middle_disc_r, 0]) rotate([0, 0, 180]) wire(frame_margin + (middle_disc_r - bottom_disc_r), false, true);

  // Cargo Bay Exterior
  translate([66, 180, 0]) rotate([0, 0, -90]) wire(top_disc_r + frame_margin - 18 - 4, false, true);
  translate([180 - 66, 180, 0]) rotate([0, 0, -90]) wire(top_disc_r + frame_margin - 18 - 4, false, true);

  translate([66, 180 - frame_margin - top_disc_r + 18 - 4, 0]) rotate([0, 0, -90]) wire(24+18-8, true, true);
  translate([180 - 66, 180 - frame_margin - top_disc_r + 18 - 4, 0]) rotate([0, 0, -90]) wire(24+18-8, true, true);

  // Top inner hull
  middle_disc_r = middle_d / 2;
  translate([76, 180 - frame_margin - top_disc_r - 24 - 4, 0]) rotate([0, 0, -90]) wire((top_disc_r + frame_margin + middle_disc_r) - (24 + 4) - 21/2, true, true);
  translate([180 - 76, 180 - frame_margin - top_disc_r - 24 - 4, 0]) rotate([0, 0, -90]) wire((top_disc_r + frame_margin + middle_disc_r) - (24 + 4) - 21/2, true, true);


  white_cat_frame();
}

//build_plate();

layout_parts();
kit_frame();
