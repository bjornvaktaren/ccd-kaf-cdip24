module ad9826_config
  (
   ad_config_in,
   ad_config_out,
   ad_sload,
   ad_sclk,
   ad_sdata,
   toggle,
   counter
   );

   // 1 r/w bit, 3 address bits, 3 zero bits, 9 config bits
   input [15:0]	     ad_config_in;
   output reg [15:0] ad_config_out = 1;
   output wire 	     ad_sclk;
   output reg 	     ad_sload = 1;  // Also works as not busy signal
   inout 	     ad_sdata;
   input 	     toggle;
   input [7:0] 	     counter;
   
   // 100 MHz / 2^(3+1) = 6.25 MHz (Maximum is 10 MHz)
   wire 	    clk = counter[3];
   assign 	ad_sclk = ( ad_sload == 1'b0 ) ? clk : 1'b0;
   wire		    ad_wdata;
   wire		    ad_rdata;
   reg [3:0] 	    bit_pointer = 0;

   // arachne-pnr cannot infer tristate, so need to intatiate explicitly
   wire		    drive_sdata = !(ad_config_in[0] && bit_pointer > 6);
   `ifdef SYNTHESIS
   SB_IO #(.PIN_TYPE(6'b 1010_01), .PULLUP(1'b 0)) ad_sdata_tristate
     (
      .PACKAGE_PIN(ad_sdata),
      .OUTPUT_ENABLE(drive_sdata),
      .D_OUT_0(ad_wdata),
      .D_IN_0(ad_rdata)
      );
   `else
   assign ad_sdata = drive_sdata ? ad_wdata : 1'bz;
   assign ad_rdata = drive_sdata ? ad_wdata : ad_sdata;
   `endif

   assign ad_wdata = ad_config_in[15 - bit_pointer];
   
   always @(negedge clk) begin
      
      if (toggle == 1'b1) begin
	 ad_sload    <= 1'b0;
	 bit_pointer <= 0;
      end
      
      if (ad_sload == 1'b0) begin
	 if (bit_pointer < 15) begin
	    bit_pointer <= bit_pointer + 1;
	 end
	 else begin
	    ad_sload    <= 1'b1;
	 end
      end
   end

   always @(posedge ad_sclk) begin
      ad_config_out[15 - bit_pointer] <= ad_rdata;
   end


endmodule // ad9826_config

