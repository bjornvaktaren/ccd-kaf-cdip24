$fa = 1;
$fs = 0.4;
$fn = 100;
EXPORT="";
// EXPORT="coolfinger_holes_y";
{
   if ( EXPORT == "coolfinger_base_z" ) {
      // Project the base plate
      projection()
	 translate([0,0,20])
	 cool_finger();
   }
   else if ( EXPORT == "coolfinger_tip_z" ) {
      // Project the tip
      projection(cut=true)
	 translate([0,0,-10])
	 cool_finger();
   }
   else if ( EXPORT == "coolfinger_y" ) {
      // Side view
      projection(cut=true)
	 rotate(a = [-90,0,0])
	 cool_finger();
   }
   else if ( EXPORT == "coolfinger_holes_y" ) {
      // Side view
      projection(cut=true)
	 translate([0,0,4])
	 rotate(a = [-90,0,0])
	 cool_finger(invert=true);
   }
   else {
      projection(cut=true)
	 rotate(a = [-90,30,0])
	 // translate([0,0,-2.5])
	 window();
      // cool_finger();
   }
}

module cool_finger(invert=false) {
   x_base = 50;
   y_base = 35;
   z_base = 3;
   z_tot = 20;
   x_tip = 14;
   y_tip = 18;

   // 3 mm hole
   x_hole_offset = 20;
   y_hole_offset = 4;
   r_hole = 1.5;
   module hole (x_offset, y_offset) {
      translate([x_offset, y_offset, -0.5])
	 cylinder(r=r_hole, h=1.5*z_base);
   }
   module holes() {
      hole(x_hole_offset, y_hole_offset);
      hole(-x_hole_offset, y_hole_offset);
      hole(-x_hole_offset, -y_hole_offset);
      hole(x_hole_offset, -y_hole_offset);
   }
      
   if (invert) {
      holes();
   }
   else {
      // Base plate
      difference() {
	 translate([-x_base/2, -y_base/2, 0])
	    cube([x_base, y_base, z_base]);
	 holes();
      }

      // Finger
      translate([-x_tip/2, -y_tip/2, z_base])
	 cube([x_tip, y_tip, z_tot-z_base]);
   }
}

module window() {
   h = 5.3;
   d_i = 28.5;
   r_o1 = 28;
   r_o2 = 29;
   r_o3 = 30;
   h_window = 2;
   r_window = 36/2;
   r_window_outer_margin = 0.5;
   r_window_inner_margin = 1;
   R_oring = 1.5/2 + 30/2;
   b_oring = 2.1;
   h_oring = 1.15;
   o_ring_float = 0.2;
   r_min_oring = 0.2;

   R_screw_hole = r_o1-(r_o1 - R_oring - r_window_inner_margin - b_oring/2)/2;
   r_screw_hole = 1.5;

   difference () {
      rotate_extrude($fn=200)
	 difference () {
	 polygon(
	    points=[
	       [r_o3, 0],
	       [r_o3, 1.0],
	       [r_o2, 1.0],
	       [r_o2, 1.4],
	       [r_o1, 1.4],
	       [r_o1, 1.4+2.5],
	       [r_o2, h-1],
	       [r_o2, h],
	       [R_oring - r_window_inner_margin - b_oring/2, h],
	       [R_oring - r_window_inner_margin - b_oring/2,
		h_window + 2*o_ring_float],
	       [r_window + r_window_outer_margin,
		h_window + 2*o_ring_float],
	       [r_window + r_window_outer_margin, 0],
	       ]
	    );
	 translate([0, h_window + 2*o_ring_float])
	    oring_hole(h_oring - o_ring_float, b_oring, r_min_oring, R_oring);
      }
      for (i=[0:1:2]) {
	 translate([R_screw_hole*sin(i*360/3), R_screw_hole*cos(i*360/3),
		    h/2]) 
	    cylinder(h=h, r=r_screw_hole, center=true);
	 translate([R_screw_hole*sin(i*360/3), R_screw_hole*cos(i*360/3),
		    1.45*0.5]) 
	    cylinder(h=1.45, r2=r_screw_hole, r1=r_screw_hole+1.45, center=true);
      }
   }
}

module oring_hole(h, b, r, R) {
   // rotate_extrude() {
   translate([R, 0])
      union () {
      translate([b/2-r, h-r])
	 circle(r);
      translate([-b/2+r, h-r,])
	 circle(r);
      polygon(points=[
		 [-b/2, 0],
		 [-b/2, h-r],
		 [-b/2+r, h],
		 [b/2-r, h],
		 [b/2, h-r],
		 [b/2,0 ],
		 ]);
	 }
   // }
   
}

module ring(r, R) {
   rotate_extrude()
      translate([R,0,0])
      circle(r);
}
