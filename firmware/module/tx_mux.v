`default_nettype none

module tx_mux
  (
   input clk,
   input [3:0] req,        // request to send 
   input [15:0] in_0,      // priority input
   input [15:0] in_1,      // priority input
   input [15:0] in_2,      // priority input
   input [15:0] in_3,      // priority input
   input wfull,            // tx fifo is full, active high
   output reg [7:0] out,   // 8-bit output
   output reg winc,        // tx fifo write increase, active high
   output reg [3:0] accept // mux accepted data, active high, low when done
   );

   reg [1:0]  sel = 0;
   reg [15:0] in_sel = 0;

   // serialized mux
   always @(posedge clk) begin
      
      // sel  <= 0;
      // in_sel <= 16'h0000;
      
      if (req[0]) begin
	 sel    <= 0;
	 in_sel <= in_0;
      end
      else if (req[1]) begin
	 sel    <= 1;
	 in_sel <= in_1;
      end
      else if (req[2]) begin
	 sel    <= 2;
	 in_sel <= in_2;
      end
      else if (req[3]) begin
	 sel    <= 3;
	 in_sel <= in_3;
      end
      
   end // always @ (posedge clk)

   
   localparam state_idle      = 4'b0000;
   localparam state_hdr_setup = 4'b0001;
   localparam state_hdr_send  = 4'b0011;
   localparam state_msb_setup = 4'b0010;
   localparam state_msb_send  = 4'b0110;
   localparam state_lsb_setup = 4'b0111;
   localparam state_lsb_send  = 4'b0101;
   localparam state_acc_wait  = 4'b0100;
   localparam state_finish    = 4'b1100;
   
   reg [3:0]   state = state_idle;
   
   // state logic
   always @(posedge clk) begin
      
      state <= state_idle;
      
      case (state)

	state_idle:
	  if (req > 0)
	    state <= state_hdr_setup;

	state_hdr_setup:
	  if (!wfull)
	    state <= state_hdr_send;
	  else
	    state <= state_hdr_setup;
	state_hdr_send:
	  state <= state_msb_setup;
	
	state_msb_setup:
	  if (!wfull)
	    state <= state_msb_send;
	  else
	    state <= state_msb_setup;
	state_msb_send:
	  state <= state_lsb_setup;
	
	state_lsb_setup:
	  if (!wfull)
	    state <= state_lsb_send;
	  else
	    state <= state_lsb_setup;
	state_lsb_send:
	  state <= state_acc_wait;
	
	state_acc_wait:
	  if ( req[sel] == 1'b1 )
	    state <= state_finish;
	  else
	    state <= state_acc_wait;
	
	state_finish:
	  if ( req[sel] == 1'b0 )
	    state <= state_idle;
	  else
	    state <= state_finish;
	
      endcase // case (state)

   end // always @ (posedge clk)
   
   // state task logic
   always @* begin

      out    = 8'h00;
      winc   = 1'b0;
      accept = 4'h0;

      if ( state == state_idle ) begin
      end
      if ( state == state_hdr_setup ) begin
	 out         = sel;
	 // winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_hdr_send ) begin
	 out         = sel;
	 winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_msb_setup ) begin
	 out         = in_sel[15:8];
	 // winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_msb_send ) begin
	 out         = in_sel[15:8];
	 winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_lsb_setup ) begin
	 out         = in_sel[7:0];
	 // winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_lsb_send ) begin
	 out         = in_sel[7:0];
	 winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_acc_wait ) begin
      	 accept[sel] = 1'b1;
      end
      if ( state == state_finish ) begin
      	 accept[sel] = 1'b1;
      end
      
   end // always @ *
   
endmodule // tx_mux

   
