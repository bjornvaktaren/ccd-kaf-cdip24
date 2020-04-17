`default_nettype none

`include "mcp3008_interface.v"
`include "sync_ft245.v"
`include "fifo.v"

module breadboard_tests
  (clk,         // clock
   ft_bus,      // ft232h data bus
   ft_rxf_n,    // ft232h read fifo (active low)
   ft_txe_n,    // ft232h transmit enable (active low)
   ft_rd_n,     // ft232h read data (active low)
   ft_wr_n,     // ft232h write (active low)
   ft_siwu_n,   // ft232h send immediate / wake up (active low)
   ft_clkout,   // ft232h clock
   ft_oe_n,     // ft232h output enable (active low)
   mcp_dclk,    // mcp3008 data clock
   mcp_dout,    // mcp3008 data out
   mcp_din,     // mcp3008 data in
   mcp_cs_n,    // mcp3008 active low chip select
   // pwm_shutter, // PWM output for controlling the shutter servo
   // pwm_peltier  // PWM output for controlling the peltier cooling
   );
   
   input        clk;
   inout [7:0]  ft_bus;
   input 	ft_rxf_n;
   input 	ft_txe_n;
   input        ft_clkout;
   output wire  ft_rd_n;
   output wire  ft_wr_n;
   output wire  ft_siwu_n;
   output wire 	ft_oe_n;
   input 	mcp_dout;
   output wire 	mcp_dclk;
   output wire  mcp_din;
   output wire 	mcp_cs_n;
   // output wire 	pwm_shutter;
   // output wire 	pwm_peltier;

   // Gray coded states
   // reset state for 1 clock 
   localparam state_reset             = 4'b0000; 
   // 
   localparam state_idle              = 4'b0001; 
   // get command from FT245 interface
   localparam state_get_cmd           = 4'b0011;
   // evaluate the recieved command
   localparam state_eval_cmd          = 4'b0010;
   // send mcp datao to tx_fifo
   localparam state_tx_write_mcp_msb  = 4'b0110;
   // wait for handshake
   localparam state_tx_write_mcp_lsb  = 4'b0111;
   // read out the ccd
   localparam state_toggle_ccd        = 4'b0101;
   // read out the ccd
   localparam state_ccd_wait_busy     = 4'b0100;

   // Gray code for reference:
   // 4'b0000;
   // 4'b0001;
   // 4'b0011;
   // 4'b0010;
   // 4'b0110;
   // 4'b0111;
   // 4'b0101;
   // 4'b0100;
   // 4'b1100;
   // 4'b1101;
   // 4'b1111;
   // 4'b1110;
   // 4'b1010;
   // 4'b1011;
   // 4'b1001;
   // 4'b1000;
   
   // // Shutter states
   // localparam shutter_state_open   = 1'b0; // open shutter
   // localparam shutter_state_closed = 1'b1; // close shutter

   // include header file with localparams needed across modules or for sim
   `include "controller.vh"

   // Clock divider
   
   reg [23:0] 	clk_div = 0;

   always @(posedge clk) begin
      clk_div <= clk_div + 1;
   end

      
   // Synchronous FT245 Interface
   
   wire       data_to_ft_avail;
   wire       next_data_to_ft;
   wire [7:0] data_to_ft;
   wire       data_from_ft_avail;
   wire [7:0] data_from_ft;

   sync_ft245 sync_ft245 
     (
      .ft_bus(ft_bus),
      .ft_rxf_n(ft_rxf_n),
      .ft_txe_n(ft_txe_n),
      .ft_rd_n(ft_rd_n),
      .ft_wr_n(ft_wr_n),
      .ft_siwu_n(ft_siwu_n),
      .ft_clkout(ft_clkout),
      .ft_oe_n(ft_oe_n),
      .data_to_ft(data_to_ft),
      .data_to_ft_avail(data_to_ft_avail),
      .next_data_to_ft(next_data_to_ft),
      .data_from_ft(data_from_ft),
      .data_from_ft_avail(data_from_ft_avail)
      );

   
   // // FIFO for receiving data from FT245 interface

   // fifo #(8, 8) rx_fifo
   //   (
   //    .rdata(),
   //    .wfull(),
   //    .rempty(),
   //    .wdata(ad_data),
   //    .winc(),
   //    .wclk(fifo_write_clk),
   //    .wrst_n(),
   //    .rinc(),
   //    .rclk(ft_clkout),
   //    .rrst_n()
   //    );

   // FIFO for sending data to FT245 interface
   wire       tx_fifo_rempty;
   assign data_to_ft_avail = ! tx_fifo_rempty;
   wire	      tx_fifo_wfull;
   reg 	      tx_fifo_winc;
   reg 	      tx_fifo_wrst_n;
   reg 	      tx_fifo_rrst_n;
   reg [7:0]  tx_fifo_wdata;

   fifo #(8, 8) tx_fifo
     (
      .rdata(data_to_ft),
      .wfull(tx_fifo_wfull),
      .rempty(tx_fifo_rempty),
      .wdata(tx_fifo_wdata),
      .winc(tx_fifo_winc),
      .wclk(clk),
      .wrst_n(tx_fifo_wrst_n),
      .rinc(next_data_to_ft),
      .rclk(ft_clkout),
      .rrst_n(tx_fifo_rrst_n)
      );


   // MCP3008 ADC interface

   reg 	      mcp_sample = 0;
   wire       mcp_busy;
   wire [9:0] mcp_data;
   wire       mcp_dclk_internal;
`ifdef SYNTHESIS
   // 100 MHz / 2^(6+1) = 0.78 MHz
   assign mcp_dclk_internal = clk_div[6];
`else
   // Makes is easier to see in simulation
   assign mcp_dclk_internal = clk_div[6];
`endif
   // Only output the clock if needed
   assign mcp_dclk = (mcp_cs_n == 1'b0) ? mcp_dclk_internal : 1'b1;

   mcp3008_interface mcp3008
     (
      .sample(mcp_sample),       // sample on posedge
      .dclk(mcp_dclk_internal),  // mcp3008 data clock
      .dout(mcp_dout),           // mcp3008 data out
      .din(mcp_din),             // mcp3008 data in
      .cs_n(mcp_cs_n),           // mcp3008 active low chip select
      .busy(mcp_busy),           // this interface is busy
      .dout_reg(mcp_data)        // 10 bit output
      );



   // // Shutter PWM
   
   // localparam shutter_closed_duty_cycle = 8'h10;
   // localparam shutter_open_duty_cycle = 8'h20;
   // reg [7:0] pwm_shutter_duty_cycle = shutter_closed_duty_cycle;
  
   // assign pwm_shutter = clk_div[7:0] <= pwm_shutter_duty_cycle ? 1 : 0;


   // State-machine
   
   reg [3:0]   state = state_reset;
   // reg 	       shutter_state = shutter_state_closed;
   // reg [15:0]  ft_output_reg = 0;
   // reg [7:0]   command = 0;
   
   // state logic
   always @(posedge clk) begin

      case (state)

	state_reset:
	  state <= state_idle;
	
   	state_idle:
	  // wait for ft245 interface to tell the fpga what to do
	  if (ft_rxf_n == 1'b0) 
	    state <= state_get_cmd;
	
	state_get_cmd:
	  // wait for the sync_ft245 module to have recieved data
	  if (data_from_ft_avail == 1'b1)
	    state <= state_eval_cmd;

	state_eval_cmd: begin
	   // Take different actions. Go back to idle if the command is invalid
	   state <= state_idle;
	   if (data_from_ft == cmd_get_mcp)
	     state <= state_tx_write_mcp_msb;
	   // if (data_from_ft == cmd_read_ccd)
	   //   state <= state_toggle_ccd;
	   // if (data_from_ft == cmd_shutter_close)
	   //   shutter_state <= shutter_state_closed;
	   // if (data_from_ft == cmd_shutter_open)
	   //   shutter_state <= shutter_state_open;
	end

	// state_sample_mcp:
	//   if (mcp_busy == 1'b1)
	//     state <= state_mcp_wait;
	
	// state_mcp_wait:
	//   if (mcp_busy == 1'b0)
	//     state <= state_mcp_to_ft_bus;
	
	// state_toggle_ccd:
	//   if (ccd_busy == 1'b0)
	//     state <= state_ccd_wait_busy;
	
	// state_ccd_wait_busy:
	//   // while there is data in the fifo
	//   if (ccd_busy == 1'b1)
	//     state <= state_tx_write_lsb;

	state_tx_write_mcp_msb:
	  state <= state_tx_write_mcp_lsb;

	state_tx_write_mcp_lsb:
	  state <= state_idle;
	
	// state_shutter_open:
	//     state <= state_idle; 

	// state_shutter_close:
	//     state <= state_idle; 
	
   	default: state <= state_reset;
	
      endcase // case (state)
      
   end // always @ (posedge clk)
   

   // state task logic
   always @* begin

      tx_fifo_winc   = 1'b0;
      tx_fifo_wdata  = 8'b0;
      tx_fifo_wrst_n = 1'b0;
      tx_fifo_rrst_n = 1'b0;
	
      if(state == state_reset) begin
	 tx_fifo_wrst_n = 1'b1;
	 tx_fifo_rrst_n = 1'b1;
      end
      if(state == state_idle) begin
      end
      if(state == state_get_cmd) begin
      end
      if(state == state_eval_cmd) begin
      end
      if(state == state_tx_write_mcp_msb) begin
	 tx_fifo_wdata = mcp_data[7:0];
	 tx_fifo_winc  = 1'b1;
      end
      if(state == state_tx_write_mcp_lsb) begin
	 tx_fifo_wdata[1:0] = mcp_data[9:8];
	 tx_fifo_wdata[7:2] = 6'b0;
	 tx_fifo_winc  = 1'b1;
      end
      // if(state == state_toggle_ccd) begin
      // 	 ccd_toggle = 1'b1;
      // end
      // if(state == state_ccd_wait_busy) begin
      // 	 ccd_toggle = 1'b1;
      // end
      // // shutter states
      // if(shutter_state == shutter_state_open) begin
      // 	 pwm_shutter_duty_cycle = shutter_open_duty_cycle;
      // end
      // if(shutter_state == shutter_state_closed) begin
      // 	 pwm_shutter_duty_cycle = shutter_closed_duty_cycle;
      // end
   end // always @*


   // continuously sample the temperture sensors connected to the mcp
`ifdef SYNTHESIS
   wire mcp_sample_clk = clk_div[23]; // 100 MHz / 2^(23+1) = 5.96 Hz
`else
   // Makes is easier to see in simulation
   wire mcp_sample_clk = clk_div[7]; // 100 MHz / 2^(7+1) = 390 kHz
`endif
   
   always @(posedge mcp_sample_clk) begin
      // If the ADC is done converting, shift out the 16 bits
      mcp_sample <= !mcp_sample;
   end


   
endmodule // breadboard_tests
