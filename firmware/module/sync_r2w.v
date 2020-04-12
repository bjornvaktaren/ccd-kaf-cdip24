`default_nettype none

module sync_r2w #(parameter addr_width = 8)
   (
    wq2_rptr,
    rptr,
    wclk,
    wrst_n
    );

   output reg [addr_width:0] wq2_rptr;
   input [addr_width:0]      rptr;
   input 		     wclk, wrst_n;

   reg [addr_width:0] 	     wq1_rptr;

   always @(posedge wclk or negedge wrst_n)
     if (!wrst_n)
       {wq2_rptr, wq1_rptr} <= 0;
     else
       {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};

endmodule // sync_t2w

