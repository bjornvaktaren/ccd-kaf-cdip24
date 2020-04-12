`default_nettype none

module rptr_empty #(parameter addr_width = 8)
   (
    rempty,
    raddr,
    rptr,
    rq2_wptr,
    rinc,
    rclk,
    rrst_n
    );
   
   output reg 		     rempty;
   output [addr_width-1:0]   raddr;
   output reg [addr_width :0] rptr;
   input [addr_width :0]      rq2_wptr;
   input 		      rinc, rclk, rrst_n;
   
   reg [addr_width:0] 	     rbin;
   wire [addr_width:0] 	     rgraynext, rbinnext;
   wire 		     rempty_val;
   
   //-------------------
   // GRAYSTYLE2 pointer
   //-------------------
   
   always @(posedge rclk or negedge rrst_n)
     if (!rrst_n)
       {rbin, rptr} <= 0;
     else
       {rbin, rptr} <= {rbinnext, rgraynext};

   
   // Memory read-address pointer (okay to use binary to address memory)
   assign raddr     = rbin[addr_width-1:0];
   
   assign rbinnext  = rbin + (rinc & ~rempty);
   assign rgraynext = (rbinnext>>1) ^ rbinnext;
   
   //---------------------------------------------------------------
   // FIFO empty when the next rptr == synchronized wptr or on reset
   //---------------------------------------------------------------
   assign rempty_val = (rgraynext == rq2_wptr);
   always @(posedge rclk or negedge rrst_n)
     if (!rrst_n) 
       rempty <= 1'b1;
     else
       rempty <= rempty_val;
   
endmodule
