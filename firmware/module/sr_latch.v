`default_nettype none

module sr_latch(set, rst, q);

   input      set;
   input      rst;
   output reg q = 1'b0;

   always @(posedge set or posedge rst) begin
      q <= 1'b0;
      if (rst)
	q <= 1'b0;
      else
	q <= 1'b1;
   end

endmodule // sr_latch

