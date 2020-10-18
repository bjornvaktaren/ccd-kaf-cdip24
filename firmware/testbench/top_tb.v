`default_nettype none
`timescale 1ns/100ps

module top_tb();
   reg clk;
   reg  [7:0]  ft_buff;
   wire [7:0]  ft_bus;
   reg 	ft_rxf_n;
   reg 	ft_txe_n;
   wire ft_rd_n;
   wire ft_wr_n;
   wire ft_siwu_n;
   wire ft_oe_n;
   reg 	mcp_dout;
   wire mcp_dclk;
   wire mcp_din;
   wire mcp_cs_n;
   wire	pwm_shutter;
   wire	pwm_peltier_1;
   wire	pwm_peltier_2;
   wire ad_cdsclk1;
   wire ad_cdsclk2;
   wire ad_adclk;
   wire ad_oeb_n;
   reg [7:0] ad_data;
   wire ad_sload;
   wire ad_sclk;
   wire	ad_sdata;
   wire kaf_r;
   wire kaf_h1;
   wire kaf_v1;
   wire kaf_v2;
   wire kaf_amp;
   

   // include header file with localparams containing the command definitions
   `include "controller.vh"

   reg [7:0] clk_div;
   reg 	     ft_clkout;
   assign ft_bus = ~ft_oe_n ? ft_buff : 8'hZZ;

   top dut
     (.clk_in(clk),          // clock
      .ft_bus(ft_bus),       // ft232h data bus
      .ft_rxf_n(ft_rxf_n),   // ft232h read fifo
      .ft_txe_n(ft_txe_n),   // ft232h transmit enable
      .ft_rd_n(ft_rd_n),     // ft232h read data
      .ft_wr_n(ft_wr_n),     // ft232h write
      .ft_siwu_n(ft_siwu_n), // ft232h send immediate / wkae up
      .ft_clkout(ft_clkout), // ft232h clock
      .ft_oe_n(ft_oe_n),     // ft232h output enable
      .mcp_dclk(mcp_dclk),   // mcp3008 data clock
      .mcp_dout(mcp_dout),   // mcp3008 data out
      .mcp_din(mcp_din),     // mcp3008 data in
      .mcp_cs_n(mcp_cs_n),    // mcp3008 active low chip select
      .pwm_shutter(pwm_shutter), 
      .pwm_peltier_1(pwm_peltier_1),
      .pwm_peltier_2(pwm_peltier_2),
      .ad_cdsclk1(ad_cdsclk1),//AD9826 correlated double sampling clock input 1
      .ad_cdsclk2(ad_cdsclk2),//AD9826 correlated double sampling clock input 2
      .ad_adclk(ad_adclk),    // AD9826 clock
      .ad_oeb_n(ad_oeb_n),    // AD9826 output enable, active low
      .ad_data(ad_data),      // AD9826 output, 8 bits
      .ad_sload(ad_sload),    // AD9826 serial interface slave select
      .ad_sclk(ad_sclk),      // AD9826 serial interface data clock
      .ad_sdata(ad_sdata),    // AD9826 serial interface data i/o
      .kaf_r(kaf_r),          // CCD R clock
      .kaf_h1(kaf_h1),        // CCD H1 clock
      .kaf_v1(kaf_v1),        // CCD V1 clock
      .kaf_v2(kaf_v2),        // CCD V2 clock
      .kaf_amp(kaf_amp)       // CCD Amplifier supply on/off
      );
   
   always begin
      #5 clk <= ! clk; // Period = 10 ns => 1/10ns = 100 MHz
   end
   always begin
      #8.3333333333 ft_clkout <= ! ft_clkout; // 60 MHz
   end

   
   // main clock domain
   always @(posedge clk) begin
      clk_div <= clk_div + 1;
   end

   task ft245_send;
      input [7:0] data_in;
      begin
	 ft_buff <= data_in;
	 fork : f // synchronize with ft_clkout
	    begin
	       // timeout check
	       #500 $display("%t : ft245_send timeout", $time);
	       disable f;
	    end
	    begin
	       @(posedge ft_clkout);
	       disable f;
	    end
	 join
	 ft_rxf_n <= 0;
	 

	 #75
	 ft_rxf_n <= 1;
	    
      end
   endtask // ft245_send

   
   initial begin
      clk       <= 0;
      ft_clkout <= 0;
      clk_div   <= 0;
      ft_rxf_n  <= 1;
      ft_txe_n  <= 0;
      ad_data   <= 8'h00;

      $dumpfile("top_tb.vcd");
      $dumpvars;

      // #250 ft245_send(cmd_rw_adconf);
      // ft245_send(8'b00000000); // write to 000, "Configuration" register
      // // 4V input range, Internal Vref, 3CH mode off, CDS on, 4V input clamp,
      // // no power-down, unused bit, 2 byte output mode
      // ft245_send(8'b11011000);

      // #250 ft245_send(cmd_rw_adconf);
      // ft245_send(8'b10000000); // read from 000, "Configuration" register
      // ft245_send(8'b11111111);
      
      // #250 ft245_send(cmd_rw_adconf);
      // ft245_send(8'b01000000); // write to 100, "Red Offset" register
      // ft245_send(8'b00000011);
      // ft_txe_n  <= 1;
      // #250 ft245_send(cmd_rw_adconf);
      // ft245_send(8'b11000000); // read from 010, "Red Offset" register
      // ft245_send(8'b00000000);
      // #4000 ft_txe_n  <= 0;
      
      // // #250 ft245_send(cmd_set_register);
      // ft245_send(8'b00000001); // write to 01, TEC 2 PWM register
      // ft245_send(8'b00110010);
      // ft245_send(cmd_set_register);
      // ft245_send(8'b00000000); // write to 00, TEC 1 PWM register
      // ft245_send(8'b00111111);
      
      // #1 ft_txe_n  <= 1;
      // ft245_send(cmd_toggle_mcp);
      // // #50 ft_txe_n <= 0;
      // #1 mcp_dout <= 1;
      // #40000 ft_txe_n  <= 0;

      // Test shutter open and closing
      // #50 ft245_send(cmd_open_shutter);
      // #50000 ft245_send(cmd_close_shutter);
      
      #250 ft245_send(cmd_set_register);
      ft245_send(8'b00000010); // write to 10, ccd_readout_mode register
      ft245_send(8'b00000001); // flush sensor, i.e. no ADC conversion
      // ft245_send(8'b00000010); // read out with 1x1 binning
      #50 ft245_send(cmd_toggle_read_ccd);
      #50 ft_txe_n <= 0;
      
      #100000 $finish;
   end

endmodule // top_tb
