module mcp3008_interface_tb();

   reg      dout;
   reg      sample;
   reg      dclk;
   wire     din;
   wire     cs_n;
   wire     busy;
   wire [31:0] dout_reg;
   
   mcp3008_interface dut
     (
      sample,  // sample on posedge
      dclk,    // mcp3008 data clock
      dout,    // mcp3008 data out
      din,     // mcp3008 data in
      cs_n,    // mcp3008 active low chip select
      busy,    // this interface is busy
      dout_reg // output
      );

   always begin
      #1 dclk <= !dclk;
   end

   task mcp_wait;
      begin
	 fork : f // implement a wait until cs_n goes high
	    begin
	       // timeout check
	       #2000000 $display("%t : mcp_wait timeout", $time);
	       disable f;
	    end
	    begin
	       @(negedge busy);
	       disable f;
	    end
	 join
      end
   endtask // mcp_wait
   
   initial begin
      
      dclk <= 0;
      dout <= 1;
      
      $dumpfile("mcp3008_interface_tb.vcd");
      $dumpvars;
      
      sample <= 1;
      #10 sample <= 0;
      mcp_wait();

      #10 sample <= 1;
      #10 sample <= 0;
      mcp_wait();
      
      #10000 $finish;
   end

endmodule // mcp3008_interface

      
			
