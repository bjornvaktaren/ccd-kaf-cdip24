`default_nettype none

module wptr_full #(parameter addr_width = 4)
   (
    wfull,
    waddr,
    wptr,
    wq2_rptr,
    winc,
    wclk,
    wrst_n
    );
   
   output reg 		       wfull;
   output [addr_width-1:0]     waddr;
   output reg [addr_width :0]  wptr;
   input [addr_width :0]       wq2_rptr;
   input 		       winc, wclk, wrst_n;

   reg [addr_width:0] 	       wbin;
   wire [addr_width:0] 	       wgraynext, wbinnext;
   wire 		       wfull_val;
   
   // GRAYSTYLE2 pointer
   always @(posedge wclk or negedge wrst_n)
     if (!wrst_n)
       {wbin, wptr} <= 0;
     else
       {wbin, wptr} <= {wbinnext, wgraynext};
   
   // Memory write-address pointer (okay to use binary to address memory)
   assign waddr = wbin[addr_width-1:0];
   assign wbinnext = wbin + (winc & ~wfull);
   assign wgraynext = (wbinnext>>1) ^ wbinnext;
   
   //------------------------------------------------------------------
   // Simplified version of the three necessary full-tests:
   // assign wfull_val=((wgnext[addr_width]     != wq2_rptr[addr_width]  ) &&
   //                   (wgnext[addr_width-1]   != wq2_rptr[addr_width-1]) &&
   //                   (wgnext[addr_width-2:0] == wq2_rptr[addr_width-2:0]));
   //------------------------------------------------------------------
   assign wfull_val = (wgraynext=={~wq2_rptr[addr_width:addr_width-1],
				   wq2_rptr[addr_width-2:0]});
   
   always @(posedge wclk or negedge wrst_n)
     if (!wrst_n)
       wfull <= 1'b0;
     else
       wfull <= wfull_val;
   
endmodule // wptr_full

