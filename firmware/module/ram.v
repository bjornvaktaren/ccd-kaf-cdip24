`default_nettype none

// 256x16 RAM
module ram
  (
   write_data, 
   write_address, 
   write_enable, 
   write_clk, 
   read_data, 
   read_address, 
   read_clk
   );
   parameter addr_width = 8;
   parameter data_width = 16;
   input wire [addr_width - 1 : 0] write_address, read_address;
   input wire [data_width - 1 : 0] write_data;
   input wire		      write_enable, write_clk;
   input wire		      read_enable, read_clk;
   output reg [data_width - 1 : 0] read_data;

   reg [data_width - 1 : 0] 	   mem [( 1 << addr_width ) - 1 : 0];
   // wire [data_width - 1 : 0] 	   memh80; // wire for debugging
   // assign memh80 = mem[8'h80];

   initial begin
      read_data <= 16'h00;
   end

   always @(posedge write_clk) begin
      if (write_enable == 1'b1) mem[write_address] <= write_data;
   end

   always @(posedge read_clk) begin
      read_data <= mem[read_address];
   end

// `endif // !`ifdef SYNTHESIS

endmodule // ram


	
