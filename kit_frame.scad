/* Kit Frame parts */

module kit_frame_perimeter(width, height, thickness=1.6) {
  difference() {
    cube([width, height, thickness]);
    
    translate([thickness, thickness, -1]) cube([width - 2*thickness, height - 2*thickness, thickness + 2]);
  }
}

module name_card(text, width, height, font_size, thickness=1.6) {
  difference() {
    cube([width, height, thickness / 2]);
    translate([width/2, 1, -1]) linear_extrude(thickness + 2) {
      text(text="THEFT OF FIRE", size=font_size-2, font="Roboto Slab:style=Bold", halign="center");
    }
    // O
    translate([28.8, 3, -1]) cylinder(h=thickness + 2, d=3.3, $fn=16);
    // R
    translate([43, 3.8, -1]) cylinder(h=thickness + 2, d=2.2, $fn=16);

  }
  
  translate([width/2, 7, 0.001]) {
    color("red") linear_extrude(thickness + 0.4) {
      text(text=text, size=font_size, font="Roboto Slab:style=Bold", halign="center");
    }
  }

}

module rounded_bend_cap(thickness = 1.6) {
  cylinder(h = thickness, d = thickness, $fn = 16);
}

module wire(length, taper_start, taper_end, thickness=1.6) {
  // Actually one more than this after slicing.
  join_layers = 1;
  join_width = 0.6;

  difference() {
    translate([-0.01, -thickness/2, 0]) cube([length + 0.02, thickness, thickness]);

    if(taper_start) {
      translate([-0.02, 0, join_layers * 0.2]) rotate([0, -45, 0]) translate([0, -thickness/2 - 1, 0]) cube([length, thickness + 2, thickness]);
      translate([-0.02, -join_width/2, 0]) rotate([0, 0, -45]) translate([0, -thickness, -1]) cube([length, thickness, thickness + 2]);
      translate([-0.02, join_width/2, 0]) rotate([0, 0, 45]) translate([0, 0, -1]) cube([length, thickness, thickness + 2]);
    }

    if (taper_end) {
      translate([length + 0.02, 0, join_layers * 0.2]) rotate([0, 45, 0]) translate([-length, -thickness/2 - 1, 0]) cube([length, thickness + 2, thickness]);
      translate([length + 0.02, -join_width/2, 0]) rotate([0, 0, 45]) translate([-length, -thickness, -1]) cube([length, thickness, thickness + 2]);
      translate([length + 0.02, join_width/2, 0]) rotate([0, 0, -45]) translate([-length, 0, -1]) cube([length, thickness, thickness + 2]);
    }
  }
}

module white_cat_card() {
  name_card("WHITE CAT", 55, 15, 6);
}

module kasm_card() {
  name_card("KASM", 30, 10, 6);
}

module white_cat_frame(thickness = 1.6) {
  x = 30 / sqrt(2) + 1.6;

  difference() {
    kit_frame_perimeter(180, 180);

    translate([-0.01, -0.01, -1]) cube([x, x, thickness + 2]);
    translate([180 - x + 0.01, -0.01, -1]) cube([x, x, thickness + 2]);
  }
  translate([x, thickness/2, 0]) rounded_bend_cap();
  translate([thickness/2, x, 0]) rounded_bend_cap();

  translate([180-x, thickness/2, 0]) rounded_bend_cap();
  translate([180-thickness/2, x, 0]) rounded_bend_cap();

  translate([180-x, thickness/2, 0]) rotate([0, 0, 45]) translate([0, -thickness/2, 0]) cube([30+thickness*sin(45), thickness, thickness]);
  translate([x, thickness/2, 0]) rotate([0, 0, 135]) translate([0, -thickness/2, 0]) cube([30+thickness*sin(45), thickness, thickness]);

  translate([90 - (55/2), 1.6, 0]) white_cat_card();

  //translate([180 - x, 1.6, 0]) rotate([0, 0, 45]) kasm_card();
}

module frame_test() {
  kit_frame_perimeter(30, 30);
  
  translate([40, 0, 0]) rotate([0, 0, 90]) kasm_card();
  
  translate([4, 4, 0]) cube([10, 10, 1.6]);
  
  translate([0, 4+5, 0]) wire(4, false, true);
  translate([4+5, 0, 0]) rotate([0, 0, 90]) wire(4, false, true);
}

frame_test();

//white_cat_frame();

