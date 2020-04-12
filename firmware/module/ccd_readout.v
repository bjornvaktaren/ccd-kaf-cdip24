`default_nettype none

module ccd_readout
  (
   ad_cdsclk1,
   ad_cdsclk2,
   ad_adclk,
   ad_oeb_n,
   kaf_r,
   kaf_h1,
   kaf_h2,
   kaf_v1,
   kaf_v2,
   kaf_amp,
   counter,
   busy,
   toggle,
   mode
   );

   `include "ccd_readout.vh"
   
   localparam state_idle = 4'h0;  // See README
   localparam state_h0   = 4'h1;  // --"--
   localparam state_h1   = 4'h2;  // --"--
   localparam state_h2   = 4'h3;  // --"--
   localparam state_h3   = 4'h4;  // --"--
   localparam state_h4   = 4'h5;  // --"--
   localparam state_h5   = 4'h6;  // --"--
   localparam state_h6   = 4'h7;  // --"--
   localparam state_h7   = 4'h8;  // --"--
   localparam state_h8   = 4'h9;  // --"--
   localparam state_h9   = 4'ha;  // --"--
   localparam state_v0   = 4'hb;  // --"--
   localparam state_v1   = 4'hc;  // --"--
   localparam state_v2   = 4'hd;  // --"--
   localparam state_v3   = 4'he;  // --"--
   localparam state_v4   = 4'hf;  // --"--

`ifdef SYNTHESIS
   localparam v_regs = 1472;  // number of vertical pixels in the ccd
   localparam h_regs = 2184;  // number of horizontal pixels in the ccd
`else
   localparam v_regs = 5;  // number of vertical pixels in the testbench ccd
   localparam h_regs = 3;  // number of horizontal pixels in the testbench ccd
`endif

   
   output reg   ad_cdsclk1, ad_cdsclk2, ad_adclk, ad_oeb_n;
   output reg   kaf_r, kaf_h1, kaf_h2, kaf_v1, kaf_v2, kaf_amp;
   input [15:0] counter;
   output reg 	busy = 0;
   input 	toggle;
   input [1:0] 	mode; // idle, clean, readout, readout 2x2 binning

   wire 	clk = counter[ccd_counter_clk_bit];
   reg [3:0]    state = state_idle;
   reg [11:0] 	v_counter = 0;
   reg [11:0] 	h_counter = 0;

   // state-machine: idle, clean, read_out
   always @(posedge clk) begin

      if (toggle == 1'b1) begin
	 busy <= 1'b1;
      end

      case (state)

   	state_idle:
	  if (toggle == 1'b1) begin
	     if (mode == ccd_mode_idle)
	       state <= state_idle;
	     if (mode == ccd_mode_clean)
	       state <= state_h0;
	     if (mode == ccd_mode_readout_1x1)
	       state <= state_h0;
	     if (mode == ccd_mode_readout_2x2)
	       state <= state_h0;
	  end

   	state_h0:
	    state <= state_h1;
   	state_h1:
	    state <= state_h2;
   	state_h2:
	    state <= state_h3;
   	state_h3:
	    state <= state_h4;
   	state_h4:
	    state <= state_h5;
   	state_h5:
	    state <= state_h6;
   	state_h6:
	    state <= state_h7;
   	state_h7:
	    state <= state_h8;
   	state_h8:
	    state <= state_h9;
   	state_h9: begin
	   if ( h_counter == h_regs ) begin
	      if ( v_counter == v_regs )
		state <= state_idle;
	      else
		state <= state_v0;
	   end
	   else
	     state <= state_h0;
	   h_counter <= h_counter + 1;
	end

   	state_v0:
	    state <= state_v1;
   	state_v1:
	    state <= state_v2;
   	state_v2:
	    state <= state_v3;
   	state_v3:
	    state <= state_v4;
   	state_v4: begin
	   state <= state_h0;
	   v_counter <= v_counter + 1;
	   h_counter <= 0;
	end

   	default: state <= state_idle;

      endcase // case (state)

   end // always @(posedge clk)


   // state task logic
   always @* begin

      ad_cdsclk1 = 0;
      ad_cdsclk2 = 0;
      ad_adclk   = 0;
      ad_oeb_n   = 0;
      kaf_r      = 0;
      kaf_h1     = 0;
      kaf_h2     = 0;
      kaf_v1     = 0;
      kaf_v2     = 0;
      kaf_amp    = 0;
      
      if ( state == state_idle ) begin
	 ad_adclk   = 1;
	 ad_oeb_n   = 1;
	 kaf_h2     = 1;
      end
      if ( state == state_h0 ) begin
	 ad_adclk   = 1;
	 kaf_r      = 1;
	 kaf_h1     = 1;
      end
      if ( state == state_h1 ) begin
	 ad_adclk   = 1;
	 kaf_h1     = 1;
      end
      if ( state == state_h2 ) begin
	 ad_cdsclk1 = 1;
	 kaf_h1     = 1;
      end
      if ( state == state_h3 ) begin
	 kaf_h1     = 1;
      end
      if ( state == state_h4 ) begin
	 kaf_h1     = 1;
      end
      if ( state == state_h5 ) begin
	 kaf_h2     = 1;
      end
      if ( state == state_h6 ) begin
	 ad_cdsclk2 = 1;
	 kaf_h2     = 1;
      end
      if ( state == state_h7 ) begin
	 ad_adclk   = 1;
	 ad_cdsclk2 = 1;
	 kaf_h2     = 1;
      end
      if ( state == state_h8 ) begin
	 ad_adclk   = 1;
	 ad_cdsclk2 = 1;
	 kaf_h2     = 1;
      end
      if ( state == state_h9 ) begin
	 ad_adclk   = 1;
	 kaf_h2     = 1;
      end
      if ( state == state_v0 ) begin
	 ad_adclk   = 1;
	 ad_oeb_n   = 1;
	 kaf_h2     = 1;
      end
      if ( state == state_v1 ) begin
	 ad_adclk   = 1;
	 ad_oeb_n   = 1;
	 kaf_h2     = 1;
	 kaf_v2     = 1;
      end
      if ( state == state_v2 ) begin
	 ad_adclk   = 1;
	 ad_oeb_n   = 1;
	 kaf_h2     = 1;
	 kaf_v1     = 1;
      end
      if ( state == state_v3 ) begin
	 ad_adclk   = 1;
	 ad_oeb_n   = 1;
	 kaf_h2     = 1;
	 kaf_v2     = 1;
      end
      if ( state == state_v4 ) begin
	 ad_adclk   = 1;
	 ad_oeb_n   = 1;
	 kaf_h2     = 1;
      end
      
   end // always @*

   
endmodule // ccd_readout
