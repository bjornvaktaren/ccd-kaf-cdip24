`default_nettype none

module controller_tb();
   reg clk;
   reg  [7:0]  ft_buff;
   wire [7:0]  ft_bus;
   reg 	ft_rxf_n;
   reg 	ft_txe_n;
   wire ft_clkout;
   wire ft_rd_n;
   wire ft_wr_n;
   wire ft_siwu_n;
   wire ft_oe_n;
   reg 	mcp_dout;
   wire mcp_dclk;
   wire mcp_din;
   wire mcp_cs_n;
   wire ad_cdsclk1;
   wire ad_cdsclk2;
   wire ad_adclk;
   wire ad_oeb;
   wire kaf_r;
   wire kaf_h1;
   wire kaf_h2;
   wire kaf_v1;
   wire kaf_v2;
   wire kaf_amp;
   reg [7:0] ad_data;
   wire pwm_shutter;
   wire pwm_peltier;

   // include header file with localparams containing the command definitions
   `include "controller.vh"

   reg [7:0] clk_div;
   assign ft_clkout = clk_div[1];
   assign ft_bus = ~ft_oe_n ? ft_buff : 8'hZZ;

   controller dut
     (clk,         // clock
      ft_bus,      // ft232h data bus
      ft_rxf_n,    // ft232h read fifo
      ft_txe_n,    // ft232h transmit enable
      ft_rd_n,     // ft232h read data
      ft_wr_n,     // ft232h write
      ft_siwu_n,   // ft232h send immediate / wkae up
      ft_clkout,   // ft232h clock
      ft_oe_n,     // ft232h output enable
      mcp_dclk,    // mcp3008 data clock
      mcp_dout,    // mcp3008 data out
      mcp_din,     // mcp3008 data in
      mcp_cs_n,    // mcp3008 active low chip select
      ad_cdsclk1,  // ad9826 cds clock 1
      ad_cdsclk2,  // ad9826 cds clock 2
      ad_adclk,    // ad9826 clock
      ad_oeb,      // ad9826 output enable (active low)
      kaf_r,       // kaf ccd reset clock
      kaf_h1,      // kaf ccd horizontal 1 clock
      kaf_h2,      // kaf ccd horizontal 2 clock
      kaf_v1,      // kaf ccd vertical 1 clock
      kaf_v2,      // kaf ccd vertical 2 clock
      kaf_amp,     // kaf amplifier on/off
      ad_data,     // ad9826 output data
      pwm_shutter, // PWM output for controlling the shutter servo
      pwm_peltier  // PWM output for controlling the peltier control
      );
   // adc_emulator adc(adc_sdo, adc_sck, adc_busy, adc_cnv);

   
   always begin
      #1 clk <= ! clk;
   end

   
   // main clock domain
   always @(posedge clk) begin
      clk_div <= clk_div + 1;
   end

   
   task mcp_wait;
      begin
	 
	 fork : f // implement a wait until mcp_cs_n goes high
	    begin
	       // timeout check
	       #2000000 $display("%t : mcp_wait timeout", $time);
	       disable f;
	    end
	    begin
	       @(posedge mcp_cs_n);
	       disable f;
	    end
	 join
	    
      end
   endtask // mcp_wait
   
   task ft245_send;
      input [7:0] data_in;
      begin
	 ft_buff <= data_in;
	 #1 
	 ft_rxf_n <= 0;
	 
	 fork : f // implement a wait until ft_oe_n goes low
	    begin
	       // timeout check
	       #100 $display("%t : ft245_send timeout", $time);
	       disable f;
	    end
	    begin
	       @(negedge ft_rd_n);
	       disable f;
	    end
	 join
	 
	 ft_rxf_n <= 1;
	    
      end
   endtask // ft245_send

   
   initial begin
      clk     <= 0;
      clk_div <= 0;
      ft_rxf_n <= 1;
      ft_txe_n <= 0;

      $dumpfile("controller_tb.vcd");
      $dumpvars;

      #10 ft245_send(cmd_shutter_open);
      
      #100 ft245_send(cmd_get_mcp);
      #10 ft_txe_n <= 0;
      mcp_dout <= 1;
      mcp_wait();
      mcp_dout <= 0;

      #10 ft245_send(cmd_shutter_close);
      
      #10 ft245_send(cmd_read_ccd);
      #10 ft_txe_n <= 0;
      
      #10000 $finish;
   end

endmodule // test_bench
