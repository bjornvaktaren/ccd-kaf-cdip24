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
   output reg [15:0] dout_reg = 16'h0000;

   // // start-bit, pseudo-diff, CH[0,1] = IN[+,-]
   // reg [4:0]  mcp3008_conf = 5'b1_0_000; 
   // // start-bit, pseudo-diff, CH[2,3] = IN[+,-]
   // reg [4:0]  mcp3008_conf = 5'b1_0_010; 
   // start-bit, pseudo-diff, CH[0,1] = IN[+,-], then CH[2,3] = IN[+,-]
   reg [9:0]  mcp3008_conf = 10'b1_0_000_1_0_010;
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
	    din          <= mcp3008_conf[9];
	    mcp3008_conf <= {mcp3008_conf[8:0], mcp3008_conf[9]};
	 end
	 if (bit_count == 19) begin
	    cs_n      <= 1'b1;
	    bit_count <= 0;
	    busy      <= 1'b0;
	 end
	 bit_count <= bit_count + 1;
      end // if (busy == 1'b1)
   end // always @ (negedge dclk)

   always @(posedge dclk) begin
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
   end
      

endmodule // mcp3008_interface

      
			
