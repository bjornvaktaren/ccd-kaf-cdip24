`default_nettype none

module spi_slave_tb();

   reg spi_mosi;
   wire spi_sck;
   reg spi_cs_n;
   wire spi_miso;

   reg clk;

   reg [7:0] clk_div;
   assign spi_sck = clk_div[2:2] & !spi_cs_n;
   
   reg [7:0] parallel_in;
   wire [7:0] parallel_out;
   wire	     out_available;
   

   spi_slave dut
     ( 
       spi_miso, 
       spi_mosi, 
       spi_sck, 
       spi_cs_n,
       parallel_in,
       parallel_out,
       out_available
       );


   task spi_send;
      input [7:0] mosi;
      input [7:0] miso;
      begin
	 spi_cs_n     <= 1'b0;
	 parallel_in  <= miso;
	 @(negedge spi_sck) spi_mosi <= mosi[7];
	 @(negedge spi_sck) spi_mosi <= mosi[6];
	 @(negedge spi_sck) spi_mosi <= mosi[5];
	 @(negedge spi_sck) spi_mosi <= mosi[4];
	 @(negedge spi_sck) spi_mosi <= mosi[3];
	 @(negedge spi_sck) spi_mosi <= mosi[2];
	 @(negedge spi_sck) spi_mosi <= mosi[1];
	 @(negedge spi_sck) spi_mosi <= mosi[0];
	 @(negedge spi_sck) spi_cs_n <= 1'b1;
      end
   endtask // spi_send

   initial begin
      clk <= 0;
      spi_mosi      <= 1'b0;
      spi_cs_n      <= 1'b1;
      clk_div       <= 0;
      $dumpfile("spi_slave_tb.vcd");
      $dumpvars;
      #1000 $finish;
   end

   always begin
      #1 clk <= ! clk;
   end

      // main clock domain
   always @(posedge clk) begin
      clk_div <= clk_div + 1;
   end

   reg[7:0] ftdi_to_fpga = 8'hA3;
   reg[7:0] fpga_to_ftdi = 8'b11000101;
   initial begin
      #3 spi_send(ftdi_to_fpga, fpga_to_ftdi);
   end

endmodule // spi_slave_tb
