module mcp3008_interface_tb();

   reg      dout;
   reg      sample;
   reg      dclk;
   wire     din;
   wire     cs_n;
   wire     busy;
   wire [9:0] dout_reg;
   
   mcp3008_interface dut
     (
      sample,  // sample on posedge
      dclk,    // mcp3008 data clock
      dout,    // mcp3008 data out
      din,     // mcp3008 data in
      cs_n,    // mcp3008 active low chip select
      busy,    // this interface is busy
      dout_reg // 10 bit output
      );

   always begin
      #1 dclk <= !dclk;
   end

   initial begin
      dclk <= 0;
      $dumpfile("mcp3008_interface_tb.vcd");
      $dumpvars;
      #10000 $finish;
   end

endmodule // mcp3008_interface

      
			
