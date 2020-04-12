`define state_idle         2'b00 // 
`define state_clean        2'b01 // get command from FT245 interface
`define state_readout_1x1  2'b11 // evaluate the recieved command
`define state_readout_2x2  2'b10 // evaluate the recieved command

module ccd_readout_tb();

   wire       ad_cdsclk1, ad_cdsclk2, ad_adclk, ad_oeb_n;
   reg [7:0]  ad_data = 0;
   wire       kaf_r, kaf_h1, kaf_h2, kaf_v1, kaf_v2, kaf_amp;
   wire       busy;
   reg 	      toggle = 0;
   reg [1:0]  mode   = 0;

   reg [15:0] 	counter = 0;

   ccd_readout dut
     (
      .ad_cdsclk1(ad_cdsclk1),
      .ad_cdsclk2(ad_cdsclk2),
      .ad_adclk(ad_adclk),
      .ad_oeb_n(ad_oeb),
      .ad_data(ad_data),
      .kaf_r(kaf_r),
      .kaf_h1(kaf_h1),
      .kaf_h2(kaf_h2),
      .kaf_v1(kaf_v1),
      .kaf_v2(kaf_v2),
      .kaf_amp(kaf_amp),
      .counter(counter),
      .busy(busy),
      .toggle(toggle),
      .mode(mode)
      );

   // test-bench master clock
   reg clk = 0;
   always begin
      #1 clk <= !clk;
   end

   // master counter
   always @(posedge clk) begin
      counter <= counter + 1;
   end

   
   initial begin
      $dumpfile("ccd_readout_tb.vcd");
      $dumpvars;
      #2 toggle <= 1;
      mode <= `state_readout_1x1;
      #10 toggle <= 0;
      #2000 $finish;
   end
   
   
endmodule // ccd_readout_tb


