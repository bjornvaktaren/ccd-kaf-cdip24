`default_nettype none

`include "sync_r2w.v"
`include "sync_w2r.v"
`include "fifomem.v"
// `include "ram.v"
`include "rptr_empty.v"
`include "wptr_full.v"

module fifo #(parameter data_width = 16, parameter addr_width = 8)
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
   
   output [data_width - 1:0] rdata;
   input [data_width - 1:0]  wdata;
   output 		     wfull, rempty;
   input 		     winc, wclk, wrst_n, rinc, rclk, rrst_n;

   wire [addr_width - 1:0]   waddr, raddr;
   wire [addr_width:0] 	     wptr, rptr, wq2_rptr, rq2_wptr;

   sync_r2w #(addr_width) sync_r2w
     (
      .wq2_rptr(wq2_rptr),
      .rptr(rptr),
      .wclk(wclk),
      .wrst_n(wrst_n)
      );

   sync_w2r #(addr_width) sync_w2r
     (
      .rq2_wptr(rq2_wptr),
      .wptr(wptr),
      .rclk(rclk),
      .rrst_n(rrst_n)
      );
   
   fifomem #(data_width, addr_width) fifomem
     (
      .rdata(rdata), 
      .raddr(raddr),
      .rclk(rclk),
      .wdata(wdata),
      .waddr(waddr), 
      .wclk(wclk),
      .wclken(winc),
      .wfull(wfull)
      );

   rptr_empty #(addr_width) rptr_empty
     (
      .rempty(rempty),
      .raddr(raddr),
      .rptr(rptr),
      .rq2_wptr(rq2_wptr),
      .rinc(rinc),
      .rclk(rclk),
      .rrst_n(rrst_n)
      );

   wptr_full #(addr_width) wptr_full
     (
      .wfull(wfull),
      .waddr(waddr),
      .wptr(wptr),
      .wq2_rptr(wq2_rptr),
      .winc(winc),
      .wclk(wclk),
      .wrst_n(wrst_n)
      );
   
				     
   
endmodule // fifo

