`default_nettype none

module tx_tb();


   reg 	      clk;
   reg 	      ft_clkout;
   reg 	      ft_rxf_n;
   reg 	      ft_txe_n;
   reg 	      tx_fifo_rrst_n;
   reg 	      tx_fifo_wrst_n;
   reg [15:0] in_0;
   reg [15:0] in_1;
   reg [15:0] in_2;
   reg [15:0] in_3;
   reg [3:0]  req;
   wire	      tx_fifo_wfull;
   wire	      tx_fifo_winc;
   wire       ft_busy;
   wire       ft_oe_n;
   wire       ft_rd_n;
   wire       ft_siwu_n;
   wire       ft_wr_n;
   wire       winc;
   wire [3:0] accept;
   wire [3:0] ft_state_out;
   wire [7:0] ft_bus;
   wire [7:0] out;
   wire [7:0] tx_fifo_rdata;
   wire [7:0] tx_fifo_wdata;
   wire tx_fifo_rempty;
   wire tx_fifo_rinc;
   
   // TX formatter. Attached a 8-bit header, then writes the input two bytes
   // to the tx fifo.

   tx_mux tx_mux
     (
      .clk(clk),
      .req(req),
      .in_0(in_0), // priority 1 input
      .in_1(in_1), // priority 2 input
      .in_2(in_2), // priority 3 input
      .in_3(in_3), // priority input
      .wfull(tx_fifo_wfull), // tx fifo is full, active high
      .out(tx_fifo_wdata), // 8-bit output
      .winc(tx_fifo_winc), // tx fifo write increase, active high
      .accept(accept)
      );

   ft245 ft245 
     (
      .ft_bus(ft_bus),
      .ft_rxf_n(ft_rxf_n),
      .ft_txe_n(ft_txe_n),
      .ft_rd_n(ft_rd_n),
      .ft_wr_n(ft_wr_n),
      .ft_siwu_n(ft_siwu_n),
      .ft_clkout(ft_clkout),
      .ft_oe_n(ft_oe_n),
      .tx_rinc(tx_fifo_rinc),
      .tx_rempty(tx_fifo_rempty),
      .tx_rdata(tx_fifo_rdata),
      .busy(ft_busy)
      );

   fifo #(8, 4) tx_fifo
     (
      .rclk(ft_clkout),
      .rdata(tx_fifo_rdata),
      .rempty(tx_fifo_rempty), 
      .rinc(tx_fifo_rinc),
      .rrst_n(tx_fifo_rrst_n),
      .wclk(clk),
      .wdata(tx_fifo_wdata),
      .wfull(tx_fifo_wfull),
      .winc(tx_fifo_winc),
      .wrst_n(tx_fifo_wrst_n)
      );
   
   always
      #10  clk <= !clk;
   always
      #16 ft_clkout <= !ft_clkout;

   initial begin
      clk   <= 0;
      ft_clkout   <= 0;
      req   <= 4'b0000;
      in_0 <= 16'h0000;
      in_1 <= 16'h0000;
      in_2 <= 16'h0000;
      in_3 <= 16'h0000;
      tx_fifo_wrst_n <= 1;
      ft_rxf_n <= 0;
      ft_txe_n <= 0;
      
      $dumpfile("tx_tb.vcd");
      $dumpvars;
      
      #1;
      tx_fifo_wrst_n <= 0;
      in_0 <= 16'h1234;
      in_1 <= 16'hABCD;
      in_2 <= 16'h5678;
      in_3 <= 16'h1111;
      req  <= 4'b0100;
      #2  tx_fifo_wrst_n <= 1;
      #12;
      
      #10000;
      $finish;
   end

endmodule // pwm_tb

      
			
