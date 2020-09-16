`default_nettype none

`include "ad9826_config.v"
`include "ccd_readout.v"
`include "fifo.v"
`include "ft245.v"
`include "mcp3008_interface.v"
`include "tx_mux.v"
`include "sr_latch.v"

module top
  (clk_in,        // clock
   ft_bus,        // ft232h data bus
   ft_rxf_n,      // ft232h read fifo (active low)
   ft_txe_n,      // ft232h transmit enable (active low)
   ft_rd_n,       // ft232h read data (active low)
   ft_wr_n,       // ft232h write (active low)
   ft_siwu_n,     // ft232h send immediate / wake up (active low)
   ft_clkout,     // ft232h clock
   ft_oe_n,       // ft232h output enable (active low)
   mcp_dclk,      // mcp3008 data clock
   mcp_dout,      // mcp3008 data out
   mcp_din,       // mcp3008 data in
   mcp_cs_n,      // mcp3008 active low chip select
   pwm_shutter,   // PWM output for controlling the shutter servo
   pwm_peltier_1, // PWM output for controlling the peltier cooler number 1
   pwm_peltier_2, // PWM output for controlling the peltier cooler number 2
   ad_cdsclk1,    // AD9826 correlated double sampling clock input 1
   ad_cdsclk2,    // AD9826 correlated double sampling clock input 2
   ad_adclk,      // AD9826 clock
   ad_oeb_n,      // AD9826 output enable, active low
   ad_data,       // AD9826 output, 8 bits
   ad_sload,      // AD9826 serial interface slave select
   ad_sclk,       // AD9826 serial interface data clock
   ad_sdata,      // AD9826 serial interface data i/o
   kaf_r,         // CCD R clock
   kaf_h1,        // CCD H1 clock, H2 is simply not(H1)
   kaf_v1,        // CCD V1 clock
   kaf_v2,        // CCD V2 clock
   kaf_amp,       // CCD Amplifier supply on/off
   debug,         // debug port
   );
   
   input        clk_in;
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
   output wire 	pwm_shutter;
   output wire 	pwm_peltier_1;
   output wire 	pwm_peltier_2;
   output wire  ad_cdsclk1;
   output wire 	ad_cdsclk2;
   output wire 	ad_adclk;
   output wire 	ad_oeb_n;
   input [7:0] 	ad_data;
   output wire  ad_sload;
   output wire  ad_sclk;
   inout 	ad_sdata;
   output wire  kaf_r;
   output wire 	kaf_h1;
   output wire 	kaf_v1;
   output wire 	kaf_v2;
   output wire 	kaf_amp;
   output wire [4:0] debug;

   // include header file with localparams needed across modules or for sim
   `include "controller.vh"
   `include "ccd_readout.vh"

   // Clock divider
   
   reg [23:0] 	clk_div = 0;
   wire 	clk = clk_in; // 100 MHz
   // wire 	clk = clk_div[0]; // 50 MHz
   // wire 	clk = clk_div[1]; // 25 MHz

   always @(posedge clk_in) begin
      clk_div <= clk_div + 1;
   end

   // FPGA settings register
   reg [7:0] fpga_reg [1:0];
   
      
   // Synchronous FT245 Interface
   
   wire tx_fifo_rinc;
   wire tx_fifo_rempty;
   wire [7:0] tx_fifo_rdata;
   wire [7:0] rx_fifo_wdata;
   wire rx_fifo_wfull;
   wire rx_fifo_winc;

   ft245 ft245 
     (
      .ft_bus(ft_bus),
      .ft_rxf_n(ft_rxf_n),
      .ft_txe_n(ft_txe_n),
      .ft_rd_n(ft_rd_n),
      .ft_wr_n(ft_wr_n),
      .ft_siwu_n(ft_siwu_n),
      .ft_clkout(ft_clkout),
      .ft_oe_n(ft_oe_n),
      .tx_rinc(tx_fifo_rinc),
      .tx_rempty(tx_fifo_rempty),
      .tx_rdata(tx_fifo_rdata),
      .rx_wdata(rx_fifo_wdata),
      .rx_wfull(rx_fifo_wfull),
      .rx_winc(rx_fifo_winc)
      );

   
   // // FIFO for receiving data from FT245 interface

   reg 	rx_fifo_rinc;
   reg 	rx_fifo_rrst_n;
   reg 	rx_fifo_wrst_n;
   wire rx_fifo_rempty;
   wire [7:0] rx_fifo_rdata;
   
   fifo #(8, 8) rx_fifo
     (
      .rclk(clk),
      .rdata(rx_fifo_rdata),
      .rempty(rx_fifo_rempty),
      .rinc(rx_fifo_rinc),
      .rrst_n(rx_fifo_rrst_n),
      .wclk(ft_clkout),
      .wdata(rx_fifo_wdata),
      .wfull(rx_fifo_wfull),
      .winc(rx_fifo_winc),
      .wrst_n(rx_fifo_wrst_n)
      );

   // FIFO for sending data to FT245 interface
   reg 	      tx_fifo_rrst_n;
   wire	      tx_fifo_winc;
   reg 	      tx_fifo_wrst_n;
   wire [7:0] tx_fifo_wdata;
   wire	      tx_fifo_wfull;

   fifo #(8, 12) tx_fifo
     (
      .rclk(ft_clkout),
      .rdata(tx_fifo_rdata),
      .rempty(tx_fifo_rempty),
      .rinc(tx_fifo_rinc),
      .rrst_n(tx_fifo_rrst_n),
      .wclk(clk),
      .wdata(tx_fifo_wdata),
      .wfull(tx_fifo_wfull),
      .winc(tx_fifo_winc),
      .wrst_n(tx_fifo_wrst_n)
      );



   // MCP3008 ADC interface

   reg 	       mcp_toggle;
   wire        mcp_toggle_latch;
   wire        mcp_busy;
   wire [15:0] mcp_data;
   wire        mcp_dclk_internal;
   wire        mcp_data_avail;
   wire        mcp_data_accept;
   // 100 MHz / 2^(6+1) = 0.78 MHz
   assign mcp_dclk_internal = clk_div[6];
   // Only output the clock if needed
   assign mcp_dclk = (mcp_cs_n == 1'b0) ? mcp_dclk_internal : 1'b1;

   mcp3008_interface mcp3008
     (
      .sample(mcp_toggle_latch),     // sample on posedge
      .dclk(mcp_dclk_internal),      // mcp3008 data clock
      .dout(mcp_dout),               // mcp3008 data out
      .din(mcp_din),                 // mcp3008 data in
      .cs_n(mcp_cs_n),               // mcp3008 active low chip select
      .busy(mcp_busy),               // this interface is busy
      .dout_reg(mcp_data),           // 10 bit output
      .dout_avail(mcp_data_avail),   // data is available if this is high
      .dout_accept(mcp_data_accept)  // data has been accapted if this is high
      );
   sr_latch sr_mcp
     (
      .set(mcp_toggle),
      .rst(mcp_busy),
      .q(mcp_toggle_latch)
      );
   

   // CCD clocks and AD9826 sampling

   reg [1:0]  ccd_readout_mode;
   reg 	      ccd_readout_toggle;
   wire	      ccd_readout_toggle_latch;
   wire       ccd_readout_busy;
   
   ccd_readout ccd_readout
     (
      .ad_cdsclk1(ad_cdsclk1),
      .ad_cdsclk2(ad_cdsclk2),
      .ad_adclk(ad_adclk),
      .ad_oeb_n(ad_oeb_n),
      .kaf_r(kaf_r),
      .kaf_h1(kaf_h1),
      .kaf_v1(kaf_v1),
      .kaf_v2(kaf_v2),
      .kaf_amp(kaf_amp),
      .counter(clk_div[15:0]),
      .busy(ccd_readout_busy),
      .toggle(ccd_readout_toggle_latch),
      .mode(ccd_readout_mode)
      );
   sr_latch sr_ccd_readout
     (
      .set(ccd_readout_toggle),
      .rst(ccd_readout_busy),
      .q(ccd_readout_toggle_latch)
      );

   
   // AD9826 configuration module

   // 1 r/w bit, 3 address bits, 3 don't-care bits, 9 config bits = 16 total
   reg [15:0] ad_config_in = 16'h00;
   wire [15:0] ad_config_out;
   reg	       ad_config_toggle;
   wire	       ad_config_toggle_latch;
   wire        ad_config_data_avail;
   wire        ad_config_data_recieved;
   wire        ad_config_busy;
   
   ad9826_config ad9826_config
     (
      .ad_config_in(ad_config_in),
      .ad_config_out(ad_config_out),
      .ad_sload(ad_sload),
      .ad_sclk(ad_sclk),
      .ad_sdata(ad_sdata),
      .toggle(ad_config_toggle_latch),
      .counter(clk_div[7:0]),
      .config_out_avail(ad_config_data_avail),
      .config_out_recieved(ad_config_data_recieved),
      .busy(ad_config_busy)
      );
   sr_latch sr_adconf
     (
      .set(ad_config_toggle),
      .rst(ad_config_busy),
      .q(ad_config_toggle_latch)
      );

   
   // TX formatter. Attached a 8-bit header, then writes the input two bytes
   // to the tx fifo.

   wire        dummy_accept_1;
   wire        dummy_accept_2;
   tx_mux tx_mux
     (
      .clk(clk),
      .req({1'b0, 1'b0, ad_config_data_avail, mcp_data_avail}),
      .in_0(mcp_data), // priority input
      .in_1(ad_config_out), // priority input
      // .in_2(), // priority input
      // .in_3(), // priority input
      .wfull(tx_fifo_wfull), // tx fifo is full, active high
      .out(tx_fifo_wdata), // 8-bit output
      .winc(tx_fifo_winc), // tx figo write increase, active high
      .accept({dummy_accept_1, dummy_accept_2, ad_config_data_recieved, mcp_data_accept})
      );

   
   // Shutter PWM
   
   localparam shutter_closed_duty_cycle = 8'h96; // approx 1500 us
   localparam shutter_open_duty_cycle = 8'h50; // approx 800 us
   reg [7:0] pwm_shutter_duty_cycle;

   // The last equality makes the PWM skip all but every 4th pulse, so that 
   // there is approximately 20 us between pulses.
   assign pwm_shutter = ( clk_div[17:10] <= pwm_shutter_duty_cycle && 
			  clk_div[20:17] == 0 );


   // Peltier element control

   reg [7:0] peltier_1_duty_cycle = 8'h00;
   reg [7:0] peltier_2_duty_cycle = 8'h00;

   assign pwm_peltier_1 = ( clk_div[7:0] < peltier_1_duty_cycle );
   assign pwm_peltier_2 = ( clk_div[7:0] < peltier_2_duty_cycle );
   

   // State-machine
   
   // Shutter states
   localparam shutter_state_open   = 1'b0; // open shutter
   localparam shutter_state_closed = 1'b1; // close shutter

   // Main state machine
   localparam state_reset           = 4'b0000;
   localparam state_idle            = 4'b0001;
   localparam state_get_cmd         = 4'b0011;
   localparam state_eval_cmd        = 4'b0010;
   localparam state_setup_msb       = 4'b0110;
   localparam state_get_msb         = 4'b0111;
   localparam state_setup_lsb       = 4'b0101;
   localparam state_get_lsb         = 4'b0100;
   localparam state_toggle_mcp      = 4'b1100;
   localparam state_wait_adconf     = 4'b1101;
   localparam state_toggle_adconf   = 4'b1111;
   localparam state_toggle_read_ccd = 4'b1110;
   localparam state_set_register    = 4'b1010;

   reg [3:0]   state = state_reset;
   reg 	       shutter_state = shutter_state_closed;
   reg [7:0]   rx_cmd = 8'h00;
   reg [7:0]   rx_msb = 8'h00;
   reg [7:0]   rx_lsb = 8'h00;

   assign debug = state;
   
   
   // state logic
   always @(posedge clk) begin

      state <= state_reset;

      case (state)

	state_reset:
	  state <= state_idle;
	
	state_idle: begin
	   state <= state_idle;
	   // wait for the rx fifo to have data
	   if (rx_fifo_rempty == 1'b0) begin
	      state <= state_get_cmd;
	   end
	end
	
	state_get_cmd: begin
	   // wait for the sync_ft245 module to have recieved data
	   state  <= state_eval_cmd;
	   rx_cmd <= rx_fifo_rdata;
	end
	
	state_eval_cmd: begin
	   
	   // Take different actions. Go back to idle if the command is invalid
	   state <= state_idle;
	   
	   if (rx_cmd == cmd_toggle_mcp)
	     state <= state_toggle_mcp;
	   
	   if (rx_cmd == cmd_toggle_read_ccd)
	     state <= state_toggle_read_ccd;
	   
	   if (rx_cmd == cmd_close_shutter)
	     shutter_state <= shutter_state_closed;
	   if (rx_cmd == cmd_open_shutter)
	     shutter_state <= shutter_state_open;
	   
	   if (rx_cmd == cmd_set_register || rx_cmd == cmd_rw_adconf)
	     if (rx_fifo_rempty == 1'b0)
	       state <= state_setup_msb;
	     else
	       state <= state_eval_cmd;

	   if (rx_cmd == cmd_reset)
	     state <= state_reset;
	   
	end // case: state_eval_cmd
	
	state_setup_msb: begin
	   // wait for the rx fifo to have more data
	   if (rx_fifo_rempty == 1'b0)
	     state <= state_get_msb;
	   else
	     state <= state_setup_msb;
	end
	
	state_get_msb: begin
	   rx_msb <= rx_fifo_rdata;
	   state  <= state_setup_lsb;
	end
	
	state_setup_lsb: begin
	   // wait for the rx fifo to have more data
	   if (rx_fifo_rempty == 1'b0)
	     state <= state_get_lsb;
	   else
	     state <= state_setup_lsb;
	end
	state_get_lsb: begin
	   rx_lsb <= rx_fifo_rdata;
	   if ( rx_cmd == cmd_set_register )
	     state <= state_set_register;
	   else if ( rx_cmd == cmd_rw_adconf )
	     state <= state_wait_adconf;
	end
	
	state_toggle_mcp:
	  state <= state_idle;
	
	state_wait_adconf:
	  if ( ad_config_busy == 1'b0 && ad_config_toggle_latch == 1'b0) begin
	     state <= state_toggle_adconf;
	     ad_config_in <= {rx_msb, rx_lsb};
	  end
	  else
	    state <= state_wait_adconf;
	
	state_toggle_adconf:
	  state <= state_idle;
	
	state_toggle_read_ccd:
	  state <= state_idle;
	
	state_set_register: begin
	   fpga_reg[rx_msb[1:0]] <= rx_lsb;
	   state <= state_idle;
	end
	
      endcase // case (state)
      
   end // always @ (posedge clk)
   
   // state task logic
   always @* begin

      ad_config_toggle   = 1'b0;
      mcp_toggle         = 1'b0;
      ccd_readout_toggle = 1'b0;
      
      rx_fifo_rinc   = 1'b0;
      rx_fifo_rrst_n = 1'b1;
      rx_fifo_wrst_n = 1'b1;
      tx_fifo_rrst_n = 1'b1;
      tx_fifo_wrst_n = 1'b1;

      if ( state == state_reset ) begin
	 tx_fifo_wrst_n = 1'b0;
	 tx_fifo_rrst_n = 1'b0;
	 rx_fifo_wrst_n = 1'b0;
	 rx_fifo_rrst_n = 1'b0;
      end
      if ( state == state_idle ) begin
      end
      if ( state == state_get_cmd ) begin
	 rx_fifo_rinc   = 1'b1;
      end
      if ( state == state_eval_cmd ) begin
      end
      if ( state == state_setup_msb ) begin
	 rx_fifo_rinc   = 1'b1;
      end
      if ( state == state_get_msb ) begin
      end
      if ( state == state_setup_lsb ) begin
	 rx_fifo_rinc   = 1'b1;
      end
      if ( state == state_get_lsb ) begin
      end
      if ( state == state_toggle_mcp ) begin
	 mcp_toggle = 1'b1;
      end
      if ( state == state_wait_adconf ) begin
      end
      if ( state == state_toggle_adconf ) begin
	 ad_config_toggle = 1'b1;
      end
      if ( state == state_toggle_read_ccd ) begin
	 // Disabled for now
	 // ccd_readout_toggle = 1'b1;
      end
      if ( state == state_set_register ) begin
      end
      
   end // always @*


   // shutter state task logic
   always @* begin
      pwm_shutter_duty_cycle = shutter_closed_duty_cycle;
      if(shutter_state == shutter_state_open) begin
      	 pwm_shutter_duty_cycle = shutter_open_duty_cycle;
      end
   end

   
endmodule // top
