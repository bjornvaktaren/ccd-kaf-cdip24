module fifomem #(parameter data_width = 16, addr_width = 8)
   (
    rdata,
    raddr,
    rclk,
    rclken,
    wdata,
    waddr, 
    wclk,
    wclken,
    wfull
    );
   
   output reg [data_width - 1:0] rdata;
   input [data_width - 1:0]  wdata;
   input [addr_width - 1:0]  waddr, raddr;
   input 		     wclken, wfull, wclk, rclk, rclken;
   
   // RTL Verilog memory model
   localparam DEPTH = 1 << addr_width;
   reg [data_width-1:0]      mem [0:DEPTH-1];
   
   always @(posedge rclk)
     rdata <= mem[raddr];
   
   always @(posedge wclk)
     if (wclken && !wfull) 
       mem[waddr] <= wdata;

`ifndef SYNTHESIS
   wire [data_width-1:0]     mem_x00 = mem[0];
   wire [data_width-1:0]     mem_x01 = mem[1];
   wire [data_width-1:0]     mem_x02 = mem[2];
   wire [data_width-1:0]     mem_x03 = mem[3];
   wire [data_width-1:0]     mem_x04 = mem[4];
   wire [data_width-1:0]     mem_x05 = mem[5];
   wire [data_width-1:0]     mem_x06 = mem[6];
   wire [data_width-1:0]     mem_x07 = mem[7];
`endif   
   
endmodule // fifomem
