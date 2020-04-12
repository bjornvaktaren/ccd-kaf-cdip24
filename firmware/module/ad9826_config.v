// `define state_idle     2'b00 // 
// `define state_clean    2'b01 // get command from FT245 interface
// `define state_readout  2'b11 // evaluate the recieved command

module ad9826_config
  (
   ad_sdata,
   ad_sclk,
   ad_sload,
   write,
   read,
   data_in,
   data_out,
   addr_in,
   addr_out,
   counter
   );
   
   output reg   ad_sdata = 0, ad_sclk = 0, ad_sload = 0;
   input 	write, read;
   input [8:0] 	data_in;
   output reg [8:0] data_out;
   input [2:0] 	addr_in;
   output reg [2:0] addr_out;
   input [7:0] 	counter;
   
   wire 	clk = counter[0];
      
   // state-machine: idle, clean, read_out
   always @(posedge clk) begin
      
      if (sample == 1'b1) begin
	 busy <= 1'b1;
      end
      
      case (state)
	
   	`state_idle: 
	  if (sample == 1'b1) 
	    state <= `state_clean;

   	`state_clean: 
	  if (busy == 1'b1) 
	    state <= `state_readout;

   	`state_readout: 
	  if (busy == 1'b1) 
	    state <= `state_idle;
	
   	default: state <= `state_idle;
	
      endcase // case (state)
      
   end // always @(posedge clk)


endmodule // ad9826_config

