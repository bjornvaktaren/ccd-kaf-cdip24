// Module for synchronous FT245 interface to FTDI ICs
`default_nettype none

module sync_ft245 
  (
   ft_bus, 
   ft_rxf_n, 
   ft_txe_n, 
   ft_rd_n,
   ft_wr_n, 
   ft_siwu_n,
   ft_clkout, 
   ft_oe_n, 
   data_to_ft,
   data_to_ft_avail,
   next_data_to_ft,
   data_from_ft,
   data_from_ft_avail
   );

   input ft_rxf_n, ft_txe_n, ft_clkout, data_to_ft_avail;
   output reg ft_rd_n, ft_wr_n, ft_siwu_n, ft_oe_n;
   inout [7:0] ft_bus;
   output reg data_from_ft_avail, next_data_to_ft;
   input [7:0] data_to_ft;
   output reg [7:0] data_from_ft;

   // arachne-pnr cannot infer tristate, so need to intatiate explicitly
   wire   drive_buf = ft_rd_n && ~ft_wr_n;
   `ifdef SYNTHESIS
   SB_IO #(.PIN_TYPE(6'b 1010_01), .PULLUP(1'b 0)) ft_databus [7:0] 
     (
      .PACKAGE_PIN(ft_bus),
      .OUTPUT_ENABLE(drive_buf),
      .D_OUT_0(data_to_ft),
      .D_IN_0(data_from_ft)
      );
   `else
   assign ft_bus = drive_buf ? data_to_ft : 8'hZZ;
   `endif
   
   
   always @(posedge ft_clkout) begin
      data_from_ft_avail <= 1'b0;
      if (ft_rd_n == 1'b0) begin
	 data_from_ft_avail <= 1'b1;
         `ifndef SYNTHESIS
	 data_from_ft       <= ft_bus;
         `endif
      end
   end

   
   always @(negedge ft_clkout) begin
      
      ft_rd_n   <= 1'b1;
      ft_wr_n   <= 1'b1;
      ft_siwu_n <= 1'b1;
      ft_oe_n   <= 1'b1;
      next_data_to_ft <= 1'b0;

      // write to ft
      if (ft_txe_n == 1'b0 && data_to_ft_avail == 1'b1) begin
	 ft_wr_n <= 1'b0;
	 next_data_to_ft <= 1'b1; // tell tx fifo to increase read pointer
      end

      // accept request to recieve from ft
      if (ft_rxf_n == 1'b0) begin
	 ft_oe_n <= 1'b0;
      end
      // next clock cycle, tell the ft to output the next byte
      if (ft_oe_n == 1'b0 && ft_rxf_n == 1'b0) begin
	 ft_rd_n <= 1'b0;
      end
   end

endmodule // ft245
