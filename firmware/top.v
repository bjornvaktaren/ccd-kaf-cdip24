`default_nettype none

`include "mcp3008_interface.v"
`include "ft245.v"
`include "fifo.v"
`include "ccd_readout.v"
`include "ad9826_config.v"

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
   kaf_amp        // CCD Amplifier supply on/off
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

   // Gray coded states
   // reset state for 1 clock 
   localparam state_reset             = 5'b00000; 
   // 
   localparam state_idle              = 5'b00001; 
   // get command from FT245 interface
   localparam state_get_cmd           = 5'b00011;
   // evaluate the recieved command
   localparam state_eval_cmd          = 5'b00010;
   // Toggle MCP to sample
   localparam state_mcp_toggle        = 5'b00110;
   // Check that MCP is not busy
   localparam state_mcp_busy_check    = 5'b00111;
   // send mcp bytes to tx_fifo
   localparam state_tx_write_mcp_b1   = 5'b00101;
   localparam state_tx_write_mcp_b1_2 = 5'b00100;
   localparam state_tx_write_mcp_b2   = 5'b01100;
   localparam state_tx_write_mcp_b2_2 = 5'b01101;
   localparam state_tx_write_mcp_b3   = 5'b01111;
   localparam state_tx_write_mcp_b3_2 = 5'b01110;
   localparam state_tx_write_mcp_b4   = 5'b01010;
   localparam state_tx_write_mcp_b4_2 = 5'b01000;
   // move rx fifo data to pwm duty cycle reg
   localparam state_peltier_1_rx_1    = 5'b10000;
   localparam state_peltier_1_rx_2    = 5'b10001;
   localparam state_peltier_2_rx_1    = 5'b10011;
   localparam state_peltier_2_rx_2    = 5'b10010;
   // wait for handshake
   localparam state_toggle_ccd        = 5'b11000;
   // read out the ccd
   localparam state_ccd_wait_busy     = 5'b11001;
   // write config to ad9826
   localparam state_adconf_rxb1_1     = 5'b11011;
   localparam state_adconf_rxb1_2     = 5'b11010;
   localparam state_adconf_rxb2_1     = 5'b11110;
   localparam state_adconf_rxb2_2     = 5'b11111;
   localparam state_adconf_toggle     = 5'b11101;
   localparam state_adconf_wait_busy  = 5'b11100;

   
   // Shutter states
   localparam shutter_state_open   = 1'b0; // open shutter
   localparam shutter_state_closed = 1'b1; // close shutter

   // include header file with localparams needed across modules or for sim
   `include "controller.vh"
   `include "ccd_readout.vh"

   // Clock divider
   
   reg [23:0] 	clk_div = 0;
   // wire 	clk = clk_in; // 100 MHz
   wire 	clk = clk_div[0]; // 50 MHz

   always @(posedge clk_in) begin
      clk_div <= clk_div + 1;
   end

      
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
   reg 	      tx_fifo_winc;
   reg 	      tx_fifo_wrst_n;
   reg [7:0]  tx_fifo_wdata;
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

   reg 	      mcp_sample;
   wire       mcp_busy;
   wire [31:0] mcp_data;
   wire       mcp_dclk_internal;
   // 100 MHz / 2^(6+1) = 0.78 MHz
   assign mcp_dclk_internal = clk_div[6];
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


   // CCD clocks and AD9826 sampling

   reg [1:0]  ccd_readout_mode;
   reg 	      ccd_readout_toggle;
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
      .toggle(ccd_readout_toggle),
      .mode(ccd_readout_mode)
      );

   
   // AD9826 configuration module

   // 1 r/w bit, 3 address bits, 3 zero bits, 9 config bits
   reg [15:0]  ad_config_in = 0;
   wire [15:0] ad_config_out;
   reg 	       ad_config_toggle;
   
   ad9826_config ad9826_config
     (
      .ad_config_in(ad_config_in),
      .ad_config_out(ad_config_out),
      .ad_sload(ad_sload),
      .ad_sclk(ad_sclk),
      .ad_sdata(ad_sdata),
      .toggle(ad_config_toggle),
      .counter(clk_div[7:0])
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
   reg 	     peltier_on = 1'b0;

   assign pwm_peltier_1 = ( clk_div[7:0] < peltier_1_duty_cycle
			    && peltier_on );
   assign pwm_peltier_2 = ( clk_div[7:0] < peltier_2_duty_cycle
			    && peltier_on );
   

   // State-machine
   
   reg [4:0]   state = state_reset;
   reg 	       shutter_state = shutter_state_closed;
   reg [7:0]   rx_reg = 8'h00;
   
   // state logic
   always @(posedge clk) begin

      case (state)

	state_reset:
	  state <= state_idle;
	
   	state_idle:
	  // wait for the rx fifo to have data
	  if (rx_fifo_rempty == 1'b0) 
	    state <= state_get_cmd;
	
	state_get_cmd: begin
	   // wait for the sync_ft245 module to have recieved data
	   state <= state_eval_cmd;
	   rx_reg <= rx_fifo_rdata;
	end
	

	state_eval_cmd: begin
	   // Take different actions. Go back to idle if the command is invalid
	   state <= state_idle;
	   if (rx_reg == cmd_get_mcp)
	     state <= state_mcp_toggle;
	   if (rx_reg == cmd_read_ccd)
	     state <= state_toggle_ccd;
	   if (rx_reg == cmd_shutter_close)
	     shutter_state <= shutter_state_closed;
	   if (rx_reg == cmd_shutter_open)
	     shutter_state <= shutter_state_open;
	   if (rx_reg == cmd_peltier_on)
	     peltier_on <= 1'b1;
	   if (rx_reg == cmd_peltier_off)
	     peltier_on <= 1'b0;
	   if (rx_reg == cmd_peltier_1_set)
	       state <= state_peltier_1_rx_1;
	   if (rx_reg == cmd_peltier_2_set)
	       state <= state_peltier_2_rx_1;
	   if (rx_reg == cmd_set_ccd_conf)
	       state <= state_adconf_rxb1_1;
	end // case: state_eval_cmd

	state_toggle_ccd:
	  if (ccd_readout_busy == 1'b1)
	    state <= state_ccd_wait_busy;
	state_ccd_wait_busy:
	  if (ccd_readout_busy == 1'b0)
	    state <= state_idle;

	state_mcp_toggle:
	  if (mcp_busy == 1'b1)
	    state <= state_mcp_busy_check;
	state_mcp_busy_check:
	  if (mcp_busy == 1'b0 && tx_fifo_wfull == 1'b0)
	    state <= state_tx_write_mcp_b1;
	
	state_tx_write_mcp_b1: begin
	   state  <= state_tx_write_mcp_b1_2;
	   tx_fifo_wdata <= mcp_data[7:0];
	end
	state_tx_write_mcp_b1_2:
	    state <= state_tx_write_mcp_b2;
	
	state_tx_write_mcp_b2: begin
	   state  <= state_tx_write_mcp_b2_2;
	   tx_fifo_wdata <= mcp_data[15:8];
	end
	state_tx_write_mcp_b2_2:
	    state <= state_tx_write_mcp_b3;
	
	state_tx_write_mcp_b3: begin
	   state  <= state_tx_write_mcp_b3_2;
	   tx_fifo_wdata <= mcp_data[23:16];
	end
	state_tx_write_mcp_b3_2:
	    state <= state_tx_write_mcp_b4;
	
	state_tx_write_mcp_b4: begin
	   state  <= state_tx_write_mcp_b4_2;
	   tx_fifo_wdata <= mcp_data[31:24];
	end
	state_tx_write_mcp_b4_2:
	    state <= state_idle;
	
	state_peltier_1_rx_1: begin
	   rx_reg <= rx_fifo_rdata;
	   state  <= state_peltier_1_rx_2;
	end
	state_peltier_1_rx_2: begin
	   peltier_1_duty_cycle <= rx_reg;
	   state <= state_idle;
	end
	state_peltier_2_rx_1: begin
	   rx_reg <= rx_fifo_rdata;
	   state  <= state_peltier_2_rx_2;
	end
	state_peltier_2_rx_2: begin
	   peltier_2_duty_cycle <= rx_reg;
	   state <= state_idle;
	end

	// States to fetch 2 bits of AD9826 config data
	state_adconf_rxb1_1: begin
	   rx_reg <= rx_fifo_rdata;
	   state <= state_adconf_rxb1_2;
	end
	state_adconf_rxb1_2: begin
	   ad_config_in[15:8] <= rx_reg;
	   state <= state_adconf_rxb2_1;
	end
	state_adconf_rxb2_1: begin
	   rx_reg <= rx_fifo_rdata;
	   state <= state_adconf_rxb2_2;
	end
	state_adconf_rxb2_2: begin
	   ad_config_in[7:0] <= rx_reg;
	   state <= state_adconf_toggle;
	end
	state_adconf_toggle:
	  if (ad_sload == 1'b0)
	    state <= state_adconf_wait_busy;
	state_adconf_wait_busy:
	  if (ad_sload == 1'b1)
	    state <= state_idle;

	
   	default: state <= state_reset;
	
      endcase // case (state)
      
   end // always @ (posedge clk)
   

   // state task logic
   always @* begin

      rx_fifo_rinc   = 1'b0;
      rx_fifo_rrst_n = 1'b1;
      rx_fifo_wrst_n = 1'b1;
      tx_fifo_rrst_n = 1'b1;
      tx_fifo_winc   = 1'b0;
      tx_fifo_wrst_n = 1'b1;

      mcp_sample     = 1'b0;

      ccd_readout_toggle = 1'b0;
      ccd_readout_mode   = ccd_mode_idle;
      
      ad_config_toggle = 1'b0;
	
      if(state == state_reset) begin
	 tx_fifo_wrst_n = 1'b0;
	 tx_fifo_rrst_n = 1'b0;
	 rx_fifo_wrst_n = 1'b0;
	 rx_fifo_rrst_n = 1'b0;
      end
      if(state == state_idle) begin
      end
      if(state == state_get_cmd) begin
	 rx_fifo_rinc   = 1'b1;
      end
      if(state == state_eval_cmd) begin
      end
      if(state == state_toggle_ccd) begin
	 ccd_readout_toggle = 1'b1;
	 ccd_readout_mode   = ccd_mode_readout_1x1;
      end
      if(state == state_ccd_wait_busy) begin
	 ccd_readout_mode   = ccd_mode_readout_1x1;
      end
      if(state == state_mcp_toggle) begin
	 mcp_sample     = 1'b1;
      end
      if(state == state_mcp_busy_check) begin
      end
      if(state == state_tx_write_mcp_b1) begin
      end
      if(state == state_tx_write_mcp_b1_2) begin
	 tx_fifo_winc  = 1'b1;
      end
      if(state == state_tx_write_mcp_b2) begin
      end
      if(state == state_tx_write_mcp_b2_2) begin
	 tx_fifo_winc  = 1'b1;
      end
      if(state == state_tx_write_mcp_b3) begin
      end
      if(state == state_tx_write_mcp_b3_2) begin
	 tx_fifo_winc  = 1'b1;
      end
      if(state == state_tx_write_mcp_b4) begin
      end
      if(state == state_tx_write_mcp_b4_2) begin
	 tx_fifo_winc  = 1'b1;
      end
      // if(state == state_toggle_ccd) begin
      // 	 ccd_toggle = 1'b1;
      // end
      // if(state == state_ccd_wait_busy) begin
      // 	 ccd_toggle = 1'b1;
      // end
      
	if(state == state_adconf_rxb1_1) begin
	   rx_fifo_rinc   = 1'b1;
	end
	if(state == state_adconf_rxb1_2) begin
	end
	if(state == state_adconf_rxb2_1) begin
	   rx_fifo_rinc   = 1'b1;
	end
	if(state == state_adconf_rxb2_2) begin
	end
	if(state == state_adconf_toggle) begin
	   ad_config_toggle = 1'b1;
	end
	if(state == state_adconf_wait_busy) begin
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
