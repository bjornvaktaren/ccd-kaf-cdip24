
module ad9826_config
  (
   ad_config_addr,
   ad_config_in,
   ad_config_out,
   ad_sload,
   ad_sclk,
   ad_sdata,
   toggle,
   counter
   );
   
   input [3:0]      ad_config_addr;
   input [7:0] 	    ad_config_in;
   output reg [7:0] ad_config_out;
   output wire 	    ad_sclk;
   output reg 	    ad_sload = 1;
   inout 	    ad_sdata; // Also works as not busy signal
   input 	    toggle;
   input [7:0] 	    counter;
   
   // 100 MHz / 2^(3+1) = 6.25 MHz (Maximum is 10 MHz)
   wire 	    clk = counter[3];
   assign 	ad_sclk = ( ad_sload == 1'b0 ) ? clk : 1'b0;
   reg 		    ad_wdata;
   reg 		    ad_rdata;
   reg [3:0] 	    bit_pointer;

   // arachne-pnr cannot infer tristate, so need to intatiate explicitly
   reg 		    drive_sdata = 1'b0;
   `ifdef SYNTHESIS
   SB_IO #(.PIN_TYPE(6'b 1010_01), .PULLUP(1'b 0)) ad_sdata_tristate
     (
      .PACKAGE_PIN(ad_sdata),
      .OUTPUT_ENABLE(drive_sdata),
      .D_OUT_0(ad_wdata),
      .D_IN_0(ad_rdata)
      );
   `else
   assign ad_sdata = drive_sdata ? ad_wdata : 8'hZZ;
   `endif
   
   `ifndef SYNTHESIS
   always @(posedge ft_clkout)
     if (ft_oe_n == 1'b0)
       rx_wdata <= ft_bus;
   `endif
   
   always @(negedge clk) begin
      
      if (toggle == 1'b1) begin
	 ad_sload    <= 1'b0;
	 bit_pointer <= 0;
      end
      
      if (ad_sload == 1'b0) begin
	 if (bit_pointer < 15)
	   bit_pointer <= bit_pointer + 1;
	 else
	   bit_pointer <= 0;
      end
      
   end

   always @(posedge clk) begin
      if ( ad_sload == 1'b0 ) begin
	 if ( bit_pointer > 6 ) begin
	    ad_config_out <= ad_rdata;
	 end
      end
   end

   always @* begin
      ad_wdata = 0;
      if ( ad_sload == 1'b0 ) begin
	 if ( bit_pointer < 4 ) 
	   ad_wdata = ad_config_addr[bit_pointer[2:0]];
	 if ( bit_pointer > 3 && bit_pointer < 7 ) 
	   ad_wdata = 1'b0;
	 if ( bit_pointer > 6 && ad_config_addr[0] ) 
	   ad_wdata = ad_config_in[bit_pointer[2:0]];
      end
   end
   
   

endmodule // ad9826_config

