`default_nettype none

module sync_w2r #(parameter addr_width = 8)
   (
    rq2_wptr,
    wptr,
    rclk,
    rrst_n
    );

   output reg [addr_width:0] rq2_wptr;
   input [addr_width:0]      wptr;
   input 		     rclk, rrst_n;

   reg [addr_width:0] 	     rq1_wptr;

   always @(posedge rclk or negedge rrst_n)
     if (!rrst_n)
       {rq2_wptr, rq1_wptr} <= 0;
     else
       {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};

endmodule // sync_t2w

