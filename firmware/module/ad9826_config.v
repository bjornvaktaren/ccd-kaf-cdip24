module ad9826_config
  (
   ad_config_in,
   ad_config_out,
   config_out_avail,    // data is available if this is high
   config_out_recieved, // data has been accepted if this is high
   busy,                // module is busy
   ad_sload,
   ad_sclk,
   ad_sdata,
   toggle,
   counter
   );

   // 1 r/w bit, 3 address bits, 3 zero bits, 9 config bits
   input [15:0]	     ad_config_in;
   output reg [15:0] ad_config_out;
   output reg 	     config_out_avail;
   input 	     config_out_recieved;
   output reg 	     busy;
   output wire 	     ad_sclk;
   output reg 	     ad_sload;  // Also works as not busy signal
   inout 	     ad_sdata;
   input 	     toggle;
   input [7:0] 	     counter;
   
   // 100 MHz / 2^(3+1) = 6.25 MHz (Maximum is 10 MHz)
   wire 	    clk = counter[3];
   assign 	ad_sclk = ( ad_sload == 1'b0 ) ? clk : 1'b0;
   reg		    io_out;
   wire		    io_in;
   reg		    oe;
   reg              rw;

   // arachne-pnr cannot infer tristate, so need to intatiate explicitly
   `ifdef SYNTHESIS
   SB_IO #(.PIN_TYPE(6'b 1010_01), .PULLUP(1'b 0)) ad_sdata_tristate
     (
      .PACKAGE_PIN(ad_sdata),
      .OUTPUT_ENABLE(oe),
      .D_OUT_0(io_out),
      .D_IN_0(io_in)
      );
   `else
   assign ad_sdata = oe ? io_out : 1'bz;
   assign io_in = oe ? 1'bz : ad_sdata;
   `endif // !`ifdef SYNTHESIS

   reg [4:0] state;
   localparam state_idle      = 5'b00000;
   localparam state_rw        = 5'b00001;
   localparam state_a2        = 5'b00011;
   localparam state_a1        = 5'b00010;
   localparam state_a0        = 5'b00110;
   localparam state_dc1       = 5'b00111;
   localparam state_dc2       = 5'b00101;
   localparam state_dc3       = 5'b00100;
   localparam state_rd8       = 5'b01100;
   localparam state_rd7       = 5'b01101;
   localparam state_rd6       = 5'b01111;
   localparam state_rd5       = 5'b01110;
   localparam state_rd4       = 5'b01010;
   localparam state_rd3       = 5'b01011;
   localparam state_rd2       = 5'b01001;
   localparam state_rd1       = 5'b01000;
   localparam state_rd0       = 5'b11000;
   localparam state_wait_fifo = 5'b11001;
   localparam state_wd8       = 5'b11011;
   localparam state_wd7       = 5'b11010;
   localparam state_wd6       = 5'b11110;
   localparam state_wd5       = 5'b11111;
   localparam state_wd4       = 5'b11101;
   localparam state_wd3       = 5'b11100;
   localparam state_wd2       = 5'b10100;
   localparam state_wd1       = 5'b10101;
   localparam state_wd0       = 5'b10111;

   // Set up on negative edge   
   always @(negedge clk) begin

      state <= state_idle;
      
      case (state)

	state_idle:
	   if ( toggle )
	     state <= state_rw;

	// Read/Write bit and address bits
	state_rw:
	  state <= state_a2;
	state_a2:
	  state <= state_a1;
	state_a1:
	  state <= state_a0;
	state_a0:
	  state <= state_dc1;

	// Don't-care bits
	state_dc1:
	  state <= state_dc2;
	state_dc2:
	  state <= state_dc3;
	state_dc3:
	  if ( rw )
	    state <= state_rd8;
	  else
	    state <= state_wd8;

	// Read bits
	state_rd8:
	  state <= state_rd7;
	state_rd7:
	  state <= state_rd6;
	state_rd6:
	  state <= state_rd5;
	state_rd5:
	  state <= state_rd4;
	state_rd4:
	  state <= state_rd3;
	state_rd3:
	  state <= state_rd2;
	state_rd2:
	  state <= state_rd1;
	state_rd1:
	  state <= state_rd0;
	state_rd0:
	  state <= state_wait_fifo;
	state_wait_fifo:
	  if ( config_out_recieved )
	    state <= state_idle;

	// Write bits
	state_wd8:
	  state <= state_wd7;
	state_wd7:
	  state <= state_wd6;
	state_wd6:
	  state <= state_wd5;
	state_wd5:
	  state <= state_wd4;
	state_wd4:
	  state <= state_wd3;
	state_wd3:
	  state <= state_wd2;
	state_wd2:
	  state <= state_wd1;
	state_wd1:
	  state <= state_wd0;
	state_wd0:
	  state <= state_idle;

      endcase // case (state)
   end // always @ (negedge clk)

   // State-dependent output
   always @* begin
      
      config_out_avail = 1'b0;
      ad_sload = 1'b0;
      io_out = 1'b0;
      oe = 1'b0;
      busy = 1'b1;
      
      if ( state == state_idle ) begin
	 ad_sload = 1'b1;
	 busy     = 1'b0;
      end
      
      if ( state == state_rw ) begin
	 io_out = ad_config_in[15];
	 oe = 1'b1;
      end
      if ( state == state_a2 ) begin
	 io_out = ad_config_in[14];
	 oe = 1'b1;
      end
      if ( state == state_a1 ) begin
	 io_out = ad_config_in[13];
	 oe = 1'b1;
      end
      if ( state == state_a0 ) begin
	 io_out = ad_config_in[12];
	 oe = 1'b1;
      end
      if ( state == state_dc1 ) 
	io_out = ad_config_in[11];
      if ( state == state_dc2 )
	io_out = ad_config_in[10];
      if ( state == state_dc3 )
	io_out = ad_config_in[9];
      
      if ( state == state_wd8 ) begin
	 io_out = ad_config_in[8];
	 oe = 1'b1;
      end
      if ( state == state_wd7 ) begin
	 io_out = ad_config_in[7];
	 oe = 1'b1;
      end
      if ( state == state_wd6 ) begin
	 io_out = ad_config_in[6];
	 oe = 1'b1;
      end
      if ( state == state_wd5 ) begin
	 io_out = ad_config_in[5];
	 oe = 1'b1;
      end
      if ( state == state_wd4 ) begin
	 io_out = ad_config_in[4];
	 oe = 1'b1;
      end
      if ( state == state_wd3 ) begin
	 io_out = ad_config_in[3];
	 oe = 1'b1;
      end
      if ( state == state_wd2 ) begin
	 io_out = ad_config_in[2];
	 oe = 1'b1;
      end
      if ( state == state_wd1 ) begin
	 io_out = ad_config_in[1];
	 oe = 1'b1;
      end
      if ( state == state_wd0 ) begin
	 io_out = ad_config_in[0];
	 oe = 1'b1;
      end
      
      if ( state == state_wait_fifo ) begin
	 ad_sload         = 1'b1;
	 config_out_avail = 1'b1;
      end
      
   end // always @ *

   always @(posedge clk) begin

      case (state)
	
	state_idle:
	  rw <= 1'b0;
	  
	state_rw: begin
	   ad_config_out[15] <= ad_config_in[15];
	   rw <= ad_config_in[15];
	end
	
	state_a2:
	  ad_config_out[14] <= ad_config_in[14];
	state_a1:
	  ad_config_out[13] <= ad_config_in[13];
	state_a0:
	  ad_config_out[12] <= ad_config_in[12];
	state_dc1:
	  ad_config_out[11] <= ad_config_in[11];
	state_dc2:
	  ad_config_out[10] <= ad_config_in[10];
	state_dc3:
	  ad_config_out[9] <= ad_config_in[9];
	
	state_rd8:
	  ad_config_out[8] <= io_in;
	state_rd7:
	  ad_config_out[7] <= io_in;
	state_rd6:
	  ad_config_out[6] <= io_in;
	state_rd5:
	  ad_config_out[5] <= io_in;
	state_rd4:
	  ad_config_out[4] <= io_in;
	state_rd3:
	  ad_config_out[3] <= io_in;
	state_rd2:
	  ad_config_out[2] <= io_in;
	state_rd1:
	  ad_config_out[1] <= io_in;
	state_rd0:
	  ad_config_out[0] <= io_in;
	
	state_wd8:
	  ad_config_out[8] <= io_out;
	state_wd7:
	  ad_config_out[7] <= io_out;
	state_wd6:
	  ad_config_out[6] <= io_out;
	state_wd5:
	  ad_config_out[5] <= io_out;
	state_wd4:
	  ad_config_out[4] <= io_out;
	state_wd3:
	  ad_config_out[3] <= io_out;
	state_wd2:
	  ad_config_out[2] <= io_out;
	state_wd1:
	  ad_config_out[1] <= io_out;
	state_wd0:
	  ad_config_out[0] <= io_out;
	
      endcase // case (state)
      
   end

endmodule // ad9826_config

