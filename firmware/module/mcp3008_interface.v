module mcp3008_interface
  (
   sample,  // sample on posedge
   dclk,    // mcp3008 data clock
   dout,    // mcp3008 data out
   din,     // mcp3008 data in
   cs_n,    // mcp3008 active low chip select
   busy,    // this interface is busy
   dout_reg // 10 bit output
   );

   input      dout;
   input      sample;
   input      dclk;
   output reg din  = 1'b0;
   output reg cs_n = 1'b1;
   output reg busy = 0;
   output reg [9:0] dout_reg = 10'b0000000000;

   reg [4:0]  mcp3008_conf = 5'b10000; // start, pseudo-diff, CH[0,1] = IN[+,-]
   reg [4:0]  bit_count = 0;

   always @(negedge dclk) begin
      if (sample == 1'b1) begin
	 busy <= 1'b1;
      end
      if (busy == 1'b1) begin
	 if (bit_count == 0 )
	   cs_n <= 1'b0;
	 if (bit_count == 1 )
	   cs_n <= 1'b0;
	 if (bit_count < 5) begin
	    din  <= mcp3008_conf[4 - bit_count];
	 end
	 if (bit_count == 18) begin
	    cs_n      <= 1'b1;
	    bit_count <= 0;
	    busy      <= 1'b0;
	 end
	 bit_count <= bit_count + 1;
      end // if (busy == 1'b1)
   end // always @ (negedge dclk)

   always @(posedge dclk) begin
      if (bit_count > 6 && bit_count < 17) begin
	 dout_reg    <= dout_reg << 1;
	 dout_reg[0] <= dout;
      end
   end
      

endmodule // mcp3008_interface

      
			
