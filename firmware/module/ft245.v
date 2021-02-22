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
   rx_winc,
   busy
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
   output reg 	    busy;
 //   output wire [3:0] state_out;
 // = state;

   reg [7:0] 	    tx_rdata_int;
   reg 		    tx_rinc_int = 0;
   reg 		    tx_rempty_int = 0;
   reg 		    ft_wr_n_int = 0;
   
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
   
   always @(negedge ft_clkout) begin
      tx_rinc       <= tx_rinc_int;
      ft_wr_n       <= ft_wr_n_int;
      tx_rdata_int  <= tx_rdata;
      tx_rempty_int <= tx_rempty;
   end
   
   localparam state_idle        = 4'b0000; // transition to 0001 or 1000
   localparam state_read_wait_1 = 4'b0001; //
   localparam state_read_wait_2 = 4'b0011; //
   localparam state_read        = 4'b0010; //
   localparam state_read_finish = 4'b0110; // transition to 0000
   localparam state_write_setup = 4'b1000; //
   localparam state_write_1     = 4'b1001; //
   localparam state_write_2     = 4'b1011; //
   
   reg [3:0] state = state_idle;
   
   always @(posedge ft_clkout) begin
      state <= state;
      
      case (state)

	state_idle:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write_setup;
	  else if ( ft_rxf_n == 1'b0 && rx_wfull == 1'b0 )
	    state <= state_read_wait_1;

	state_write_setup:
	  if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	    state <= state_write_1;
	  else
	    state <= state_idle;
	
	state_write_1:
	  if ( ft_txe_n == 1'b0 )
	    state <= state_write_2;
	  else
	    state <= state_idle;
	
	state_write_2:
	  // if ( ft_txe_n == 1'b0 && tx_rempty == 1'b0 )
	  //   state <= state_write_setup;
	  // else
	    state <= state_idle;
	
	state_read_wait_1:
	  state <= state_read_wait_2;
	state_read_wait_2:
	  state <= state_read;
	
	state_read:
	  state <= state_read_finish;
	
	state_read_finish:
	    state <= state_idle;
	
      endcase // case (state)
      
   end // always @ (negedge ft_clkout)
   
	    
   always @* begin

      ft_rd_n   = 1'b1;
      ft_siwu_n = 1'b1;
      ft_oe_n   = 1'b1;

      rx_winc   = 1'b0;
      busy      = 1'b0;

      tx_rinc_int = 1'b0;
      ft_wr_n_int = 1'b1;

      if ( state == state_write_setup ) begin
	 busy        = 1'b1;
      end
      if ( state == state_write_1 ) begin
	 ft_wr_n_int = 1'b0;
	 busy        = 1'b1;
      end
      if ( state == state_write_2 ) begin
	 tx_rinc_int = 1'b1; // tell tx fifo to increase read pointer
	 busy        = 1'b1;
      end
      if ( state == state_read_wait_1 ) begin
	 busy    = 1'b1;
      end
      if ( state == state_read_wait_2 ) begin
	 ft_oe_n = 1'b0;
	 busy    = 1'b1;
      end
      if ( state == state_read ) begin
	 ft_oe_n = 1'b0;
   	 ft_rd_n = 1'b0;
	 busy    = 1'b1;
   	 rx_winc = 1'b1; // tell rx fifo to increase write pointer
      end
      if ( state == state_read_finish ) begin
	 // ft_oe_n = 1'b0;
   	 // ft_rd_n = 1'b0;
	 busy    = 1'b1;
      end
      
   end
   

endmodule // ft245
