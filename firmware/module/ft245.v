// Module for synchronous FT245 interface to FTDI ICs
`default_nettype none

module ft245 
  (
   ft_bus, 
   ft_rxf_n, 
   ft_txe_n, 
   ft_rd_n,
   ft_wr_n, 
   ft_siwu_n,
   ft_clkout, 
   ft_oe_n,
   tx_rinc,
   tx_rempty,
   tx_rdata,
   rx_wdata,
   rx_wfull,
   rx_winc
   );

   inout      [7:0] ft_bus;
   input            ft_rxf_n;
   input            ft_txe_n;
   input            ft_clkout;
   output reg       ft_rd_n;
   output reg       ft_wr_n;
   output reg       ft_siwu_n;
   output reg       ft_oe_n;
   output reg       tx_rinc;
   input            tx_rempty;
   input      [7:0] tx_rdata;
   output reg [7:0] rx_wdata;
   input 	    rx_wfull;
   output reg 	    rx_winc;

   
   // arachne-pnr cannot infer tristate, so need to intatiate explicitly
   wire   drive_buf = ft_rd_n && ~ft_wr_n;
   `ifdef SYNTHESIS
   SB_IO #(.PIN_TYPE(6'b 1010_01), .PULLUP(1'b 0)) ft_databus [7:0] 
     (
      .PACKAGE_PIN(ft_bus),
      .OUTPUT_ENABLE(drive_buf),
      .D_OUT_0(tx_rdata),
      .D_IN_0(rx_wdata)
      );
   `else
   assign ft_bus = drive_buf ? tx_rdata : 8'hZZ;
   `endif
   
   `ifndef SYNTHESIS
   always @(posedge ft_clkout)
     if (ft_oe_n == 1'b0)
       rx_wdata <= ft_bus;
   `endif

   localparam state_idle  = 2'b00;
   localparam state_write = 2'b01;
   localparam state_read  = 2'b10;
   
   reg [1:0] state;
   
   always @(posedge ft_clkout) begin
      state <= state;
      
      case (state)

	state_idle:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write;
	  if ( ft_rxf_n == 1'b0 && rx_wfull == 1'b0 )
	    state <= state_read;
	
	state_write:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write;
	  else
	    state <= state_idle;

	state_read:
	  if ( ft_rxf_n == 1'b1 || rx_wfull == 1'b1 )
	    state <= state_idle;
	
      endcase
	    
   end // always @ (posedge ft_clkout)

   always @* begin

      ft_rd_n   <= 1'b1;
      ft_wr_n   <= 1'b1;
      ft_siwu_n <= 1'b1;
      ft_oe_n   <= 1'b1;

      tx_rinc   <= 1'b0;
      rx_winc   <= 1'b0;

      if ( state == state_idle ) 
      
   end
   
   
   // always @(negedge ft_clkout) begin
      
   //    ft_rd_n   <= 1'b1;
   //    ft_wr_n   <= 1'b1;
   //    ft_siwu_n <= 1'b1;
   //    ft_oe_n   <= 1'b1;

   //    tx_rinc   <= 1'b0;
   //    rx_winc   <= 1'b0;

   //    // write to ft
   //    if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 ) begin
   // 	 ft_wr_n <= 1'b0;
   // 	 tx_rinc <= 1'b1; // tell tx fifo to increase read pointer
   //    end

   //    // accept request to recieve from ft
   //    if ( ft_rxf_n == 1'b0 && rx_wfull == 1'b0 ) begin
   // 	 ft_oe_n <= 1'b0;
   //    end
   //    // next clock cycle, tell the ft to output the next byte
   //    if ( ft_oe_n == 1'b0 && ft_rxf_n == 1'b0 && rx_wfull == 1'b0 ) begin
   // 	 ft_rd_n <= 1'b0;
   // 	 rx_winc <= 1'b1; // tell rx fifo to increase write pointer
   //    end
   // end

endmodule // ft245
