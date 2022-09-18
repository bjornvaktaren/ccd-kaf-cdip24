`default_nettype none

module ft245_loopback_tb();

   reg clk = 1'b0;

   inout [7:0] ft_bus;
   reg [7:0] 	out_reg = 8'h00;
   assign ft_bus = (ft_oe_n == 1'b0) ? out_reg : 8'bZ;

   reg ft_rxf_n         = 1;
   reg ft_txe_n         = 1;
   reg ft_clkout        = 1;
   wire	ft_rd_n;
   wire	ft_wr_n;
   wire	ft_siwu_n;
   wire	ft_oe_n;
   wire busy;
   
   wire [7:0] lb_data;
   wire [7:0] rx_data;
   wire [7:0] tx_data;
   wire	      tx_wfull;
   wire	      tx_rempty;
   wire	      tx_wclk;
   wire	      tx_rinc;
   wire	      tx_rclk;
   reg	      tx_wrst_n = 1;
   reg	      tx_rrst_n = 1;
   
   wire	      rx_wfull;
   wire	      rx_rempty;
   wire	      rx_winc;
   wire	      rx_wclk;
   wire	      rx_rclk;
   reg	      rx_wrst_n = 1;
   reg	      rx_rrst_n = 1;

   reg	      rx_rinc = 0;
   reg	      tx_winc = 0;
   
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
      .tx_rinc(tx_rinc),
      .tx_rempty(tx_rempty),
      .tx_rdata(tx_data),
      .rx_wdata(rx_data),
      .rx_wfull(rx_wfull),
      .rx_winc(rx_winc),
      .busy(busy)
      );

   fifo #(8, 4) rx_fifo
     (
      .rclk(clk),
      .rdata(lb_data),
      .rempty(rx_rempty),
      .rinc(rx_rinc),
      .rrst_n(rx_rrst_n),
      .wclk(ft_clkout),
      .wdata(rx_data),
      .wfull(rx_wfull),
      .winc(rx_winc),
      .wrst_n(rx_wrst_n)
      );
   
   fifo #(8, 4) tx_fifo
     (
      .rclk(ft_clkout),
      .rdata(tx_data),
      .rempty(tx_rempty),
      .rinc(tx_rinc),
      .rrst_n(tx_rrst_n),
      .wclk(clk),
      .wdata(lb_data),
      .wfull(tx_wfull),
      .winc(tx_winc),
      .wrst_n(tx_wrst_n)
      );
   
   always begin
      #5 clk <= !clk;
   end
   always begin
      #6 ft_clkout <= !ft_clkout;
   end

   always @(negedge clk) begin
      if (!rx_rempty && !tx_wfull && rx_rinc == 0)
	rx_rinc <= 1'b1;
      else
	rx_rinc <= 1'b0;
      // Delay tx_winc by 1 clock
      tx_winc <= rx_rinc;
   end
   

   initial begin
      ft_clkout <= 0;
      $dumpfile("ft245_loopback_tb.vcd");
      $dumpvars;

      ft_txe_n <= 1'b0;
      #10
      tx_rrst_n <= 1'b0;
      tx_wrst_n <= 1'b0;
      rx_rrst_n <= 1'b0;
      rx_wrst_n <= 1'b0;
      
      #20
      tx_rrst_n <= 1'b1;
      tx_wrst_n <= 1'b1;
      rx_rrst_n <= 1'b1;
      rx_wrst_n <= 1'b1;
      
      // Read cycle
      
      #200 out_reg  <= 8'hD0;
      ft_rxf_n <= 0;
      wait_rd_low;
      out_reg  <= 8'hD1;
      wait_rd_low;
      out_reg  <= 8'hD2;
      wait_rd_low;
      out_reg  <= 8'hD3;
      wait_rd_low;
      out_reg  <= 8'hD4;
      wait_rd_low;
      out_reg  <= 8'hD5;
      wait_rd_low;
      out_reg  <= 8'hD6;
      wait_rd_low;
      out_reg  <= 8'hD7;
      wait_rd_low;
      out_reg  <= 8'hD8;
      wait_rd_low;
      out_reg  <= 8'hD9;
      wait_rd_low;

      out_reg  <= 8'hFF;
      ft_rxf_n <= 1;
      
      #10000 $finish;
   end // initial begin

   reg rd_low_on_neg_ft_clkout = 0;
   always @(posedge ft_clkout) begin
      if ( ft_rd_n == 0 )
	rd_low_on_neg_ft_clkout = 1;
      else
	rd_low_on_neg_ft_clkout = 0;
   end
   
   task wait_rd_low;
      begin
	 
	 fork : f
	    begin
	       #200000 $display("%t : wait_oe_low", $time);
	       disable f;
	    end
	    begin
	       @(posedge rd_low_on_neg_ft_clkout)
		 disable f;
	    end
	 join
	    
      end
   endtask // wait_rd_low
		 
endmodule // ft245_loopback_tb
