module fifomem #(parameter data_width = 16, addr_width = 8)
   (
    rdata,
    wdata,
    waddr, 
    raddr,
    wclken,
    wfull,
    wclk
    );
   
   output [data_width - 1:0] rdata;
   input [data_width - 1:0]  wdata;
   input [addr_width - 1:0]  waddr, raddr;
   input 		     wclken, wfull, wclk;
   
   // RTL Verilog memory model
   localparam DEPTH = 1 << addr_width;
   reg [data_width-1:0] 	 mem [0:DEPTH-1];
   
   assign rdata = mem[raddr];
   
   always @(posedge wclk)
     if (wclken && !wfull) 
       mem[waddr] <= wdata;
   
endmodule // fifomem
