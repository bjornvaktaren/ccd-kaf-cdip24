// Interface for mcp3008 and mcp3004
module mcp3008_interface
  (
   sample,      // sample on posedge
   dclk,        // mcp3008 data clock
   dout,        // mcp3008 data out
   din,         // mcp3008 data in
   cs_n,        // mcp3008 active low chip select
   busy,        // this interface is busy
   dout_reg,    // output data
   dout_avail,  // data is available if this is high
   dout_accept  // data has been accapted if this is high
   );

   input             dout;
   input             sample;
   input             dclk;
   output reg        din;
   output reg        cs_n;
   output reg        busy;
   output reg [15:0] dout_reg = 'b0;
   output reg 	     dout_avail;
   input 	     dout_accept;

   localparam number_of_channels = 3;
   reg [2:0]  channel_count = 0;

   reg [4:0]  state;
   localparam state_idle           = 5'b00000;
   localparam state_send_start     = 5'b00001;
   localparam state_send_single    = 5'b00011;
   localparam state_send_channel_1 = 5'b00010;
   localparam state_send_channel_2 = 5'b00110;
   localparam state_send_channel_3 = 5'b00111;
   localparam state_wait_sample_1  = 5'b00101;
   localparam state_null_bit       = 5'b00100;
   localparam state_read_b9        = 5'b01100;
   localparam state_read_b8        = 5'b01101;
   localparam state_read_b7        = 5'b01111;
   localparam state_read_b6        = 5'b01110;
   localparam state_read_b5        = 5'b01010;
   localparam state_read_b4        = 5'b01011;
   localparam state_read_b3        = 5'b01001;
   localparam state_read_b2        = 5'b01000;
   localparam state_read_b1        = 5'b11000;
   localparam state_read_b0        = 5'b11001;
   localparam state_wait_fifo      = 5'b11011;

   // Set up on negative edge   
   always @(negedge dclk) begin
      
      state <= state_idle;
      
      case (state)

	state_idle:
	  if (sample)
	    state <= state_send_start;
	state_send_start: 
	  state <= state_send_single;
	state_send_single:
	  state <= state_send_channel_1;
	state_send_channel_1:
	  state <= state_send_channel_2;
	state_send_channel_2:
	  state <= state_send_channel_3;
	state_send_channel_3:
	  state <= state_wait_sample_1;
	state_wait_sample_1:
	  state <= state_null_bit;
	state_null_bit:
	  state <= state_read_b9;
	state_read_b9:
	  state <= state_read_b8;
	state_read_b8:
	  state <= state_read_b7;
	state_read_b7:
	  state <= state_read_b6;
	state_read_b6:
	  state <= state_read_b5;
	state_read_b5:
	  state <= state_read_b4;
	state_read_b4:
	  state <= state_read_b3;
	state_read_b3:
	  state <= state_read_b2;
	state_read_b2:
	  state <= state_read_b1;
	state_read_b1:
	  state <= state_read_b0;
	state_read_b0:
	  state <= state_wait_fifo;
	state_wait_fifo:
	  if ( dout_accept == 1'b1 ) begin
	     state <= state_idle;
	     if ( channel_count < number_of_channels - 1 )
	       channel_count <= channel_count + 1;
	     else
	       channel_count <= 0;
	  end
	  else
	    state <= state_wait_fifo;
	
      endcase // case (state)

   end // always @ (negedge dclk)

   always @* begin
      din  = 1'b0;
      cs_n = 1'b0; // default is to select chip
      busy = 1'b1; // default is busy
      dout_avail = 1'b0;

      if ( state == state_idle ) begin
	 busy <= 1'b0;
	 cs_n <= 1'b1; // chip is deselected
      end
      if ( state == state_send_start ) begin
	 din <= 1'b1;
      end
      if ( state == state_send_single ) begin
	 din <= 1'b1; // if 1, use single-ended measurement
      end
      if ( state == state_send_channel_1 ) begin
	 din <= channel_count[2];
      end
      if ( state == state_send_channel_2 ) begin
	 din <= channel_count[1];
      end
      if ( state == state_send_channel_3 ) begin
	 din <= channel_count[0];
      end
      if ( state == state_wait_fifo ) begin
	 dout_avail <= 1'b1;
	 cs_n       <= 1'b1; // chip is deslected
      end
   end

   // read on positive edge
   always @(posedge dclk) begin
      
      case (state)

	state_send_single: begin
   	   dout_reg    <= dout_reg << 1;
   	   dout_reg[0] <= din;
	end
	state_send_channel_1: begin
   	   dout_reg    <= dout_reg << 1;
   	   dout_reg[0] <= din;
	end
	state_send_channel_2: begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= din;
	end
	state_send_channel_3:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= din;
	end
	state_wait_sample_1:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= din;
	end
	state_null_bit:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= din;
	end
	state_read_b9:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b8:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b7:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b6:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b5:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b4:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b3:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b2:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b1:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	state_read_b0:begin
	   dout_reg    <= dout_reg << 1;
	   dout_reg[0] <= dout;
	end
	
      endcase // case (state)
      
   end
   

endmodule // mcp3008_interface

      
			
