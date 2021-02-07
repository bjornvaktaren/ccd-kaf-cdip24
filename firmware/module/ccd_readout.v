`default_nettype none

/*
 Pixel timing (two cycles)
                _                 _               
 kaf_r        _/ \_______________/ \______________
                _______           _______         
 kaf_h1       _/       \_________/       \________
                    _                 _           
 ad_cdsclk1   _____/ \_______________/ \__________
                          _____             _____ 
 ad_cdsclk2   ___________/     \___________/     \
              _____         _________         ____
 ad_adclk          \_______/         \_______/    
              _____ _______ _________ _______ ____
 ad_data      _____X_______X_________X_______X____
               n-4    n-4     n-3        n-3      n-2
               msb    lsb     msb        lsb      msb
                            ___               ___ 
 data_avail   _____________/   \_____________/   \
                             __                __ 
 data_accept  ______________/  \______________/  \

 state (h*)   0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 8
 
 
 Line timing (one cycle)

 kaf_h1       XXXX_________XXXX
                      _
 kaf_v1       _______/ \_______
                    _   _
 kaf_v2       _____/ \_/ \_____
 
 state (v*)   N/A 0 1 2 3 4 N/A  

  
*/
module ccd_readout
  (
   clk,        // System clock
   ad_cdsclk1, // Input to AD9826
   ad_cdsclk2, // Input to AD9826
   ad_adclk,   // Input to AD9826
   ad_oeb_n,   // Input to AD9826
   ad_data,    // Output from AD9826
   kaf_r,      // CCD reset clock
   kaf_h1,     // CCD H1 and !H2 clock
   kaf_v1,     // CCD V1 clock
   kaf_v2,     // CCD V2 clock
   kaf_amp,    // CCD amplifier On/Off
   module_clk, // Module clock
   busy,       // High if this module is busy
   toggle,     // Toggle readout of sensor
   mode,       // Readout mode: none, flush (no ADC conversion), or 1x1 binning
   data_out,   // 16-bit output (pixel value)
   data_avail, // Data is available on data_out if this is high.
   data_accept,// Input high to accept data from this module.
   );

   `include "ccd_readout.vh"
   
   localparam state_idle = 4'b0000;
   localparam state_h0   = 4'b0001;
   localparam state_h1   = 4'b0011;
   localparam state_h2   = 4'b0010;
   localparam state_h3   = 4'b0110;
   localparam state_h4   = 4'b0111;
   localparam state_h5   = 4'b0101;
   localparam state_h6   = 4'b0100;
   localparam state_h7   = 4'b1100;
   localparam state_h8   = 4'b1101;
   localparam state_v0   = 4'b1111;
   localparam state_v1   = 4'b1110;
   localparam state_v2   = 4'b1010;
   localparam state_v3   = 4'b1011;
   localparam state_v4   = 4'b1001;


   // First four 16-bit values from the ADC are undefined, as well as the
   // h_regs - 4 last ADC values.
`ifdef SYNTHESIS
   localparam v_regs = 1510;  // number of vertical pixels in the ccd
   localparam h_regs = 2267;  // number of horizontal pixels in the ccd
`else
   localparam v_regs = 5;  // number of vertical pixels in the testbench ccd
   localparam h_regs = 4;  // number of horizontal pixels in the testbench ccd
`endif
   localparam v_delay = 150;    // clock delays for states v1-v4.

   input             clk;
   output wire       ad_cdsclk1, ad_cdsclk2, ad_adclk, ad_oeb_n;
   output reg        kaf_r, kaf_h1, kaf_v1, kaf_v2, kaf_amp;
   input             module_clk;
   output wire 	     busy;
   input 	     toggle;
   input [1:0] 	     mode; // clean, readout, readout 2x2 binning
   input [7:0] 	     ad_data;
   output reg [15:0] data_out;
   output wire 	     data_avail;
   input 	     data_accept;

   // Internal registers and signals
   reg 		     cdsclk1;
   reg 		     cdsclk2;
   reg		     adclk;
   reg 		     oeb_n;
   reg               data_avail_int;
   reg [3:0] 	     state = state_idle;
   reg [10:0] 	     v_counter;
   reg [11:0] 	     h_counter;
   reg [7:0] 	     v_delay_counter;

   // Output to AD9826 is gated on the readout mode.
   assign ad_cdsclk1 = ( mode != ccd_mode_clean ) ? cdsclk1 : 1'b0;
   assign ad_cdsclk2 = ( mode != ccd_mode_clean ) ? cdsclk2 : 1'b0;
   assign ad_adclk   = ( mode != ccd_mode_clean ) ? adclk   : 1'b1;
   assign ad_oeb_n   = ( mode != ccd_mode_clean ) ? oeb_n   : 1'b1;
   assign data_avail = ( mode != ccd_mode_clean ) ? data_avail_int : 1'b0;

   // Readout toggling 
   reg toggle_int = 1'b0;
   always @(posedge clk) begin
      if ( state == state_idle ) begin
	 if ( toggle_int == 1'b0 && toggle == 1'b1 )
	   toggle_int <= 1'b1;
      end
      else
	toggle_int <= 1'b0;
   end
   
   // state-machine: idle, clean, read_out
   always @(posedge module_clk) begin

      state <= state;
      
      case (state)

   	state_idle:
	  if ( toggle_int == 1'b1 ) begin
	     v_counter <= 0;
    	     h_counter <= 0;
	     v_delay_counter <= 0;
	     data_out <= 16'h0000;
	     if (mode == ccd_mode_clean)
	       state <= state_h0;
	     if (mode == ccd_mode_readout_1x1)
	       state <= state_h0;
	     if (mode == ccd_mode_readout_2x2)
	       state <= state_h0;
	  end

   	state_h0: begin
	   state <= state_h1;
	   data_out[15:8] <= ad_data;
	end
   	state_h1:
	  state <= state_h2;
   	state_h2:
	  state <= state_h3;
   	state_h3:
	  state <= state_h4;
   	state_h4: begin
	   state <= state_h5;
	   data_out[7:0] <= ad_data;
	end
   	state_h5:
	  state <= state_h6;
   	state_h6:
	  state <= state_h7;
   	state_h7:
	  state <= state_h8;
   	state_h8: begin
	   if ( h_counter == h_regs - 1 ) begin
	      // V is clocked one extra time, and H register is read out.
	      if ( v_counter == v_regs ) begin
		 state <= state_idle;
	      end
	      else
		state <= state_v0;
	   end
	   else if ( data_accept == 1'b1 || 
		     h_counter == 0 || 
		     mode == ccd_mode_clean ) begin
	      state <= state_h0;
	      h_counter <= h_counter + 1;
	   end
	end
   	state_v0:
	  if ( v_delay_counter == v_delay ) begin
	     v_delay_counter <= 0;
	     state <= state_v1;
	  end
	  else
	    v_delay_counter <= v_delay_counter + 1;
   	state_v1:
	  if ( v_delay_counter == v_delay ) begin
	     v_delay_counter <= 0;
	     state <= state_v2;
	  end
	  else
	    v_delay_counter <= v_delay_counter + 1;
   	state_v2:
	  if ( v_delay_counter == v_delay ) begin
	     v_delay_counter <= 0;
	     state <= state_v3;
	  end
	  else
	    v_delay_counter <= v_delay_counter + 1;
   	state_v3:
	  if ( v_delay_counter == v_delay ) begin
	     v_delay_counter <= 0;
	     state <= state_v4;
	  end
	  else
	    v_delay_counter <= v_delay_counter + 1;
   	state_v4: begin
	   if ( v_delay_counter == v_delay) begin
	      state <= state_h0;
	      v_counter <= v_counter + 1;
	      h_counter <= 0;
	      v_delay_counter <= 0;
	   end
	   else
	     v_delay_counter <= v_delay_counter + 1;
	end

   	default: state <= state_idle;

      endcase // case (state)

   end // always @(posedge module_clk)


   // state task logic
   assign busy = ( state != state_idle || toggle_int == 1'b1 ) ? 1'b1 : 1'b0;
   
   always @* begin

      cdsclk1    = 0;
      cdsclk2    = 0;
      adclk      = 0;
      oeb_n      = 0;
      kaf_r      = 0;
      kaf_h1     = 0;
      kaf_v1     = 0;
      kaf_v2     = 0;
      kaf_amp    = 0;
      data_avail_int = 0;

      if ( state == state_idle ) begin
	 adclk = 1;
	 oeb_n = 1;
      end
      if ( state == state_h0 ) begin
	 adclk = 1;
      end
      if ( state == state_h1 ) begin
	 adclk  = 1;
	 kaf_r  = 1;
	 kaf_h1 = 1;
      end
      if ( state == state_h2 ) begin
	 adclk  = 1;
	 kaf_h1 = 1;
      end
      if ( state == state_h3 ) begin
	 cdsclk1 = 1;
	 kaf_h1  = 1;
      end
      if ( state == state_h4 ) begin
	 kaf_h1 = 1;
      end
      if ( state == state_h5 ) begin
      end
      if ( state == state_h6 ) begin
	 cdsclk2        = 1;
      end
      if ( state == state_h7 ) begin
	 cdsclk2 = 1;
	 adclk   = 1;
	 data_avail_int = 1;
      end
      if ( state == state_h8 ) begin
	 adclk          = 1;
	 cdsclk2        = 1;
	 data_avail_int = 1;
      end
      if ( state == state_v0 ) begin
	 adclk      = 1;
	 oeb_n      = 1;
      end
      if ( state == state_v1 ) begin
	 adclk      = 1;
	 oeb_n      = 1;
	 kaf_v2     = 1;
      end
      if ( state == state_v2 ) begin
	 adclk      = 1;
	 oeb_n      = 1;
	 kaf_v1     = 1;
      end
      if ( state == state_v3 ) begin
	 adclk      = 1;
	 oeb_n      = 1;
	 kaf_v2     = 1;
      end
      if ( state == state_v4 ) begin
	 adclk      = 1;
	 oeb_n      = 1;
      end
      
   end // always @*

   
endmodule // ccd_readout
