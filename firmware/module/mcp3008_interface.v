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
   dout_accept, // data has been accapted if this is high
   );

   input      dout;
   input      sample;
   input      dclk;
   output reg din  = 1'b0;
   output reg cs_n = 1'b1;
   output reg busy = 0;
   output reg [15:0] dout_reg = 'b0;
   output reg 	     dout_avail = 1'b1;
   input 	     dout_accept;


   // Two samples, first CH[0,1], then CH[2,3].
   localparam number_of_samples = 3;
   // start-bit, single-ended, CH0-2
   reg [14:0]  mcp3008_conf = 10'b1_1_000_1_1_001_1_1_010;
   reg [4:0]  bit_count = 0;
   reg [1:0]  sample_count = 0;

   reg [4:0]  state;
   localparam state_idle           = 5'b00000;
   localparam state_send_start     = 5'b00001;
   localparam state_send_single    = 5'b00011;
   localparam state_send_channel_1 = 5'b00010;
   localparam state_send_channel_2 = 5'b00110;
   localparam state_send_channel_3 = 5'b00111;
   localparam state_wait_sample_1  = 5'b00111;
   localparam state_null_bit       = 5'b00101;
   localparam state_read_b9        = 5'b00100;
   localparam state_read_b8        = 5'b01100;
   localparam state_read_b7        = 5'b01101;
   localparam state_read_b6        = 5'b01111;
   localparam state_read_b5        = 5'b01110;
   localparam state_read_b4        = 5'b01010;
   localparam state_read_b3        = 5'b01011;
   localparam state_read_b2        = 5'b01001;
   localparam state_read_b1        = 5'b01000;
   localparam state_read_b0        = 5'b11000;
   localparam state_wait_fifo      = 5'b11001;
   
   always @(negedge dclk) begin
      if (sample == 1'b1) begin
	 busy <= 1'b1;
      end
      if (busy == 1'b1) begin
	 if (bit_count == 0 )
	   cs_n <= 1'b0;
	 if (bit_count < 5) begin
	    din          <= mcp3008_conf[9] ;
	    mcp3008_conf <= {mcp3008_conf[8:0], mcp3008_conf[9]};
	 end
	 if (bit_count == 17)
	   cs_n      <= 1'b1;
	 if (bit_count == 18) begin
	    bit_count <= 0;
	    if (sample_count == number_of_samples - 1) begin
	       busy      <= 1'b0;
	       sample_count <= 0;
	    end
	    else
	      sample_count <= sample_count + 1;
	 end
	 else
	   bit_count <= bit_count + 1;
      end // if (busy == 1'b1)
   end // always @ (negedge dclk)

   always @(posedge dclk) begin
      if (busy == 1'b1) begin
	 if (bit_count < 5) begin
	    dout_reg    <= dout_reg << 1;
	    dout_reg[0] <= mcp3008_conf[9];
	 end
	 if (bit_count == 5 ) begin
	    dout_reg    <= dout_reg << 1;
	    dout_reg[0] <= 1'b1;
	 end
	 if (bit_count > 7 && bit_count < 18) begin
	    dout_reg    <= dout_reg << 1;
	    dout_reg[0] <= dout;
	 end
      end // if (busy == 1'b1)
   end // always @ (posedge dclk)
      

endmodule // mcp3008_interface

      
			
