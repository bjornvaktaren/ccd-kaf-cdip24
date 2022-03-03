module mcp3008_interface_tb();

   reg         clk;
   reg         dout;
   reg         sample;
   reg         dclk;
   wire        din;
   wire        cs_n;
   wire        busy;
   wire [15:0] dout_reg;
   wire        dout_avail;
   reg 	       dout_accept;
   
   mcp3008_interface dut
     (
      clk,         // system clock
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

   always begin
      #1 dclk <= !dclk;
   end
   
   always begin
      #1 clk <= !clk;
   end

   task mcp_wait;
      begin
	 fork : f // implement a wait until dout_avail goes high
	    begin
	       // timeout check
	       #2000000 $display("%t : mcp_wait timeout", $time);
	       disable f;
	    end
	    begin
	       @(posedge dout_avail);
	       disable f;
	    end
	 join
      end
   endtask // mcp_wait
   
   initial begin
      
      clk <= 1'b0;
      dclk <= 1'b0;
      dout <= 1'b1;
      sample <= 1'b0;
      dout_accept <= 1'b0;
      
      $dumpfile("mcp3008_interface_tb.vcd");
      $dumpvars;
      
      sample <= 1'b1;
      mcp_wait();
      dout_accept <= 1'b1;
      
      mcp_wait();
      // dout_accept <= 1'b0;
      
      mcp_wait();
      // dout_accept <= 1'b0;
      sample <= 1'b0;

      // #10 sample <= 1;
      // #10 sample <= 0;
      // mcp_wait();
      
      #10000 $finish;
   end

endmodule // mcp3008_interface

      
			
