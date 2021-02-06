`default_nettype none

/*
 Pixel timing (two cycles)
                _                   _                
 kaf_r        _/ \_________________/ \_______________
                ________            ________         
 kaf_h1       _/        \__________/        \________
                    __                  __           
 ad_cdsclk1   _____/  \________________/  \__________
                           ____                ____  
 ad_cdsclk2   ____________/    \______________/    \_
              _____          __________          ____
 ad_adclk          \________/          \________/    
              _____ ________ __________ ________ ____
 ad_data      _____X________X__________X________X____
               n-4     n-4     n-3        n-3      n-2
               msb     lsb     msb        lsb      msb
                             ____                ____ 
 data_avail   ______________/    \______________/    \
                              ___                 ___ 
 data_accept  _______________/   \_______________/   \

 state (h*)   0 1 2 3  4   5 6  7 0 1 2 3  4   5 6  7 
 
 
 Line timing (one cycle)

 kaf_h1       XXXX_________XXXX
                      _
 kaf_v1       _______/ \_______
                    _   _
 kaf_v2       _____/ \_/ \_____
 
 state (h*)   N/A 0 1 2 3 4 N/A  

  
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
   tx_full     // tx_fifo is full if this is high
   );

   `include "ccd_readout.vh"
   
   localparam state_fifo_check = 5'b00000;  // See README
   localparam state_idle = 5'b00001;  // See README
   localparam state_h0   = 5'b00011;  // --"--
   localparam state_h1   = 5'b00010;  // --"--
   localparam state_h2   = 5'b00110;  // --"--
   localparam state_h3   = 5'b00111;  // --"--
   localparam state_h4   = 5'b00101;  // --"--
   localparam state_h5   = 5'b00100;  // --"--
   localparam state_h6   = 5'b01100;  // --"--
   localparam state_h7   = 5'b01101;  // --"--
   localparam state_h8   = 5'b01111;  // --"--
   localparam state_h9   = 5'b01110;  // --"--
   localparam state_v0   = 5'b01010;  // --"--
   localparam state_v1   = 5'b01011;  // --"--
   localparam state_v2   = 5'b01001;  // --"--
   localparam state_v3   = 5'b01000;  // --"--
   localparam state_v4   = 5'b11000;  // --"--


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
   input 	     tx_full;

   // Internal registers and signals
   reg 		     cdsclk1;
   reg 		     cdsclk2;
   reg		     adclk;
   reg 		     oeb_n;
   reg               data_avail_int;
   reg [4:0] 	     state = state_idle;
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
	       state <= state_fifo_check;
	     if (mode == ccd_mode_readout_1x1)
	       state <= state_fifo_check;
	     if (mode == ccd_mode_readout_2x2)
	       state <= state_fifo_check;
	  end

   	state_fifo_check:
	  if ( tx_full == 1'b0 )
	    state <= state_h0;
	
   	state_h0:
	  state <= state_h1;
   	state_h1:
	  state <= state_h2;
   	state_h2:
	  state <= state_h3;
   	state_h3:
	  if ( data_accept == 1'b1 || 
	       h_counter == 0 || 
	       mode == ccd_mode_clean )
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
   	state_h8:
	  state <= state_h9;
   	state_h9: begin
	   state <= state_h0;
	   data_out[15:8] <= ad_data;
	   if ( h_counter == h_regs - 1 ) begin
	      // V is clocked one extra time, and H register is read out.
	      if ( v_counter == v_regs ) begin
		 state <= state_idle;
		 // busy <= 1'b0;
	      end
	      else
		state <= state_v0;
	   end
	   h_counter <= h_counter + 1;
	end
	
   	state_v0:
	    state <= state_v1;
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
	      if ( data_accept == 1'b1 || mode == ccd_mode_clean ) begin
		 state <= state_fifo_check;
		 v_counter <= v_counter + 1;
		 h_counter <= 0;
		 v_delay_counter <= 0;
	      end
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

      if ( state == state_fifo_check ) begin
      end      
      if ( state == state_idle ) begin
	 adclk = 1;
	 oeb_n = 1;
      end
      if ( state == state_h0 ) begin
	 adclk  = 1;
	 kaf_r  = 1;
	 kaf_h1 = 1;
	 // data_avail_int = 1;
      end
      if ( state == state_h1 ) begin
	 adclk  = 1;
	 kaf_h1 = 1;
	 // data_avail_int = 1;
      end
      if ( state == state_h2 ) begin
	 cdsclk1 = 1;
	 kaf_h1  = 1;
	 // data_avail_int = 1;
      end
      if ( state == state_h3 ) begin
	 kaf_h1 = 1;
	 data_avail_int = 1;
      end
      if ( state == state_h4 ) begin
	 kaf_h1 = 1;
      end
      if ( state == state_h5 ) begin
      end
      if ( state == state_h6 ) begin
	 cdsclk2 = 1;
      end
      if ( state == state_h7 ) begin
	 adclk   = 1;
	 cdsclk2 = 1;
      end
      if ( state == state_h8 ) begin
	 adclk   = 1;
	 cdsclk2 = 1;
      end
      if ( state == state_h9 ) begin
	 adclk   = 1;
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
	 data_avail_int = 1;
      end
      
   end // always @*

   
endmodule // ccd_readout
