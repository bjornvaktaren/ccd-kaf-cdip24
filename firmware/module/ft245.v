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
   // state_out
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
 //   output wire [3:0] state_out;
 // = state;

   reg [7:0] 	    tx_rdata_int;
   
   // arachne-pnr cannot infer tristate, so need to intatiate explicitly
   wire   drive_buf = ft_oe_n;
   `ifdef SYNTHESIS
   SB_IO #(.PIN_TYPE(6'b 1010_01), .PULLUP(1'b 0)) ft_databus [7:0] 
     (
      .PACKAGE_PIN(ft_bus),
      .OUTPUT_ENABLE(drive_buf),
      .D_OUT_0(tx_rdata_int),
      .D_IN_0(rx_wdata)
      );
   `else
   assign ft_bus = drive_buf ? tx_rdata_int : 8'hZZ;
   `endif
   
   `ifndef SYNTHESIS
   always @(posedge ft_clkout)
     if (ft_oe_n == 1'b0)
       rx_wdata <= ft_bus;
   `endif
   
   always @(negedge ft_clkout)
     tx_rdata_int <= tx_rdata;

   localparam state_idle          = 3'b000;
   localparam state_read_wait_1   = 3'b001;
   localparam state_read_wait_2   = 3'b010;
   localparam state_read          = 3'b011;
   localparam state_write_setup_1 = 3'b100;
   localparam state_write_setup_2 = 3'b110;
   localparam state_write         = 3'b111;
   localparam state_write_finish  = 3'b101;
   
   reg [2:0] state = state_idle;
   
   always @(posedge ft_clkout) begin
      state <= state;
      
      case (state)

	state_idle:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write_setup_1;
	  else if ( ft_rxf_n == 1'b0 && rx_wfull == 1'b0 )
	    state <= state_read_wait_1;

	state_write_setup_1:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write_setup_2;
	  else
	    state <= state_idle;
	
	state_write_setup_2:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write;
	  else
	    state <= state_idle;
	
	state_write:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write;
	  else
	    state <= state_write_finish;

	state_write_finish:
	  state <= state_idle;

	state_read_wait_1:
	  state <= state_read_wait_2;
	state_read_wait_2:
	  state <= state_read;
	
	state_read:
	  if ( ft_rxf_n == 1'b1 || rx_wfull == 1'b1 )
	    state <= state_idle;
	
      endcase // case (state)
      
   end // always @ (negedge ft_clkout)
   
	    
   always @* begin

      ft_rd_n   = 1'b1;
      ft_wr_n   = 1'b1;
      ft_siwu_n = 1'b1;
      ft_oe_n   = 1'b1;

      tx_rinc   = 1'b0;
      rx_winc   = 1'b0;

      if ( state == state_write_setup_1 ) begin
	 tx_rinc = 1'b1; // tell tx fifo to increase read pointer
      end
      if ( state == state_write_setup_2 ) begin
	 tx_rinc = 1'b1; // tell tx fifo to increase read pointer
      end
      if ( state == state_write ) begin
	 ft_wr_n = 1'b0;
	 tx_rinc = 1'b1; // tell tx fifo to increase read pointer
      end
      if ( state == state_write_finish ) begin
	 ft_wr_n = 1'b0;
      end
      if ( state == state_read_wait_1 ) begin
      end
      if ( state == state_read_wait_2 ) begin
	 ft_oe_n = 1'b0;
      end
      if ( state == state_read ) begin
	 ft_oe_n = 1'b0;
   	 ft_rd_n = 1'b0;
   	 rx_winc = 1'b1; // tell rx fifo to increase write pointer
      end
      
   end
   

endmodule // ft245
