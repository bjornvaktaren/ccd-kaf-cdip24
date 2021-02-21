module fifo_tb();

   localparam data_width = 8;
   localparam addr_width = 4;
   
   wire [data_width - 1:0] rdata;
   reg [data_width - 1:0]  wdata;
   wire 		   wfull;
   wire 		   rempty;
   reg 			   winc;
   reg 			   wclk;
   reg 			   wrst_n;
   reg 			   rinc;
   reg 			   rclk;
   reg 			   rrst_n;
   
   fifo #(data_width, addr_width) fifo
     (
      rdata,
      wfull,
      rempty,
      wdata,
      winc,
      wclk,
      wrst_n,
      rinc,
      rclk,
      rrst_n
      );

   // test-bench write clock
   always begin
      #6 wclk <= !wclk;
   end

   // test-bench read clock
   always begin
      #10 rclk <= !rclk;
   end


   task fifo_write;
      input [data_width-1:0] data_in;
      begin
	 wdata <= data_in;
	 winc <= 1;
	 #10
	 winc <= 0;
      end
   endtask // ft245_send
   
   
   initial begin
      $dumpfile("fifo_tb.vcd");
      $dumpvars;
      wdata  <= 8'b0;
      winc   <= 0;
      wclk   <= 1;
      wrst_n <= 1;
      rinc   <= 0;
      rclk   <= 0;
      rrst_n <= 1;
      
      #10;
      wrst_n <= 0;
      rrst_n <= 0;
      #10;
      wrst_n <= 1;
      rrst_n <= 1;

      fifo_write(8'h1);
      fifo_write(8'h2);
      fifo_write(8'hA);
      fifo_write(8'hB);
      
      #2000 $finish;
   end

   
endmodule
