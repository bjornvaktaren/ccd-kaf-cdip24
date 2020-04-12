module spi_slave
  (
   clk,
   rst,
   spi_miso, 
   spi_mosi, 
   spi_clk, 
   spi_cs_n,
   parallel_in,
   parallel_out,
   out_available
   );

   input clk, rst;
   input spi_mosi;
   input spi_clk;
   input spi_cs_n;
   output reg spi_miso = 0;
   input[7:0] parallel_in;
   output reg [7:0] parallel_out = 0;
   output reg 	    out_available = 0;

   reg [3:0] spi_bits = 0;

   always @(posedge spi_clk) begin
      if ( spi_cs_n == 1'b0 ) begin
	 parallel_out <= {parallel_out[6:0],spi_mosi};
	 spi_bits <= spi_bits + 1;
      end
   end // always @ (posedge spi_clk)

   always @(negedge spi_clk) begin
      if ( spi_cs_n == 1'b0 ) begin
	 spi_miso <= parallel_in[7 - spi_bits];
      end
   end // always @ (posedge spi_clk)

   always @(posedge clk) begin
      if (spi_bits == 8) begin
	 out_available <= 1'b1;
	 spi_bits      <= 0;
      end
      else out_available <= 1'b0;
   end

endmodule // spi_slave
