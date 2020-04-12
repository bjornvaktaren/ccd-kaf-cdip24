`default_nettype none
`include "ram.v"
`define state_in_idle 'b00       // in port waits for data
`define state_in_push 'b01       // data is pushed to the fifo
`define state_in_wait 'b10       // fifo is full, not accepting new data
`define state_out_not_ready 'b00 // in port waits for data
`define state_out_pop 'b01       // data is read from the fifo
`define state_out_wait 'b10      // fifo is empty, waiting for new data

// FT232H has up to 30 Mb/s burst read and a 1kB buffer.
module async_serial_fifo(ckla, write, full, clkb, read, emty);
   
   parameter m4k_blocks = 2;
   parameter addr_width = 8;
   parameter data_width = 16;
   
   input clka, clkb, write, read, data_in;
   output reg data_out = 1'b0;
   output reg full = 0;
   output reg empty = 0;

   reg [1:0]  state_in;
   reg [data_width - 1 : 0] wdata;
   reg 			    wdata_bit;

   // clka domain
   always @(posedge clka) begin
      case ( state_in )
	`state_in_idle:
	  ;
	`state_in_push:
	  ;
	`state_in_wait
	  ;
	default: state_in <= `state_in_idle;
      endcase // case ( state_in )
   end // always @ (posedge clka)
   
	 
	 
   // // clkb domain
   // always @(posedge clkb) begin
   // end

   // genvar     n_m4k_blocks;
   // generate
   //    for ( n_m4k_blocks = 0; n_m4k_blocks < m4k_blocks; 
   // 	    n_m4k_blocks = n_m4k_blocks + 1 ) begin : genm4k
   // 	 ram ram[m4k_blocks - 1 : -](
   // 	     .wdata(),
   // 	     .waddr(),
   // 	     .we(),
   // 	     .wclke(),
   // 	     .wclk(),
   // 	     .rdata(),
   // 	     .raddr(),
   // 	     .re(),
   // 	     .rclke(),
   // 	     .rclk()
   // 	     );
   //    end
   // endgenerate

endmodule // async_serial_fifo

