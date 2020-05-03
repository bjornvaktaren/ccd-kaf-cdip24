`default_nettype none
`timescale 1ns/100ps

module breadboard_tests_tb();
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

   // include header file with localparams containing the command definitions
   `include "controller.vh"

   reg [7:0] clk_div;
   reg 	     ft_clkout;
   assign ft_bus = ~ft_oe_n ? ft_buff : 8'hZZ;

   breadboard_tests dut
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
      .mcp_cs_n(mcp_cs_n)    // mcp3008 active low chip select
      );
   
   always begin
      #5 clk <= ! clk;
   end
   always begin
      #6 ft_clkout <= ! ft_clkout;
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
	 #5 
	 ft_rxf_n <= 0;
	 
	 fork : f // implement a wait until ft_oe_n goes low
	    begin
	       // timeout check
	       #500 $display("%t : ft245_send timeout", $time);
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
      clk       <= 0;
      ft_clkout <= 0;
      clk_div   <= 0;
      ft_rxf_n  <= 1;
      ft_txe_n  <= 0;

      $dumpfile("breadboard_tests_tb.vcd");
      $dumpvars;

      #250 ft245_send(8'hF0);
      #250 ft245_send(8'hF1);
      #250 ft245_send(8'hF2);
      #250 ft245_send(8'hF3);
      
      #250 ft245_send(cmd_get_mcp);
      #50 ft_txe_n <= 0;
      mcp_dout <= 1;
      // sampling two times
      mcp_wait();
      mcp_wait();

      #250 ft245_send(cmd_get_mcp);
      #50 ft_txe_n <= 0;
      mcp_dout <= 1;
      // sampling two times
      mcp_wait();
      mcp_wait();

      #250 ft245_send(cmd_get_mcp);
      #50 ft_txe_n <= 0;
      mcp_dout <= 1;
      // sampling two times
      mcp_wait();
      mcp_wait();

      #250 ft245_send(cmd_get_mcp);
      #50 ft_txe_n <= 0;
      mcp_dout <= 1;
      // sampling two times
      mcp_wait();
      mcp_wait();

      #250 ft245_send(cmd_get_mcp);
      #50 ft_txe_n <= 0;
      mcp_dout <= 1;
      // sampling two times
      mcp_wait();
      mcp_wait();
      
      #50 ft245_send(cmd_shutter_close);
      
      #50 ft245_send(cmd_read_ccd);
      #50 ft_txe_n <= 0;
      
      #50000 $finish;
   end

endmodule // test_bench
