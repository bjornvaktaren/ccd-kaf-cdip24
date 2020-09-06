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
   output reg winc,        // tx figo write increase, active high
   output reg [3:0] accept // mux accepted data, active high, low when done
   );

   reg [1:0]  sel;
   reg [15:0] in_sel;

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

   
   localparam state_idle      = 3'b000;
   localparam state_hdr_setup = 3'b001;
   localparam state_hdr_send  = 3'b011;
   localparam state_msb_setup = 3'b010;
   localparam state_msb_send  = 3'b110;
   localparam state_lsb_setup = 3'b100;
   localparam state_lsb_send  = 3'b101;
   localparam state_finish    = 3'b111;
   
   reg [2:0]   state = state_idle;
   
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
	  state <= state_finish;
	
	state_finish:
	  state <= state_idle;
	
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
      	 accept[sel] = 1'b1;
      end
      if ( state == state_hdr_send ) begin
	 out         = sel;
	 winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_msb_setup ) begin
	 out         = in_sel[15:8];
      	 accept[sel] = 1'b1;
      end
      if ( state == state_msb_send ) begin
	 out         = in_sel[15:8];
	 winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_lsb_setup ) begin
	 out         = in_sel[7:0];
      	 accept[sel] = 1'b1;
      end
      if ( state == state_lsb_send ) begin
	 out         = in_sel[7:0];
	 winc        = 1'b1;
      	 accept[sel] = 1'b1;
      end
      if ( state == state_finish ) begin
      	 accept[sel] = 1'b1;
      end
      
   end // always @ *
   
endmodule // tx_mux

   
