`default_nettype none

`include "ad9826_config.v"
`include "ccd_readout.v"
`include "fifo.v"
`include "ft245.v"
`include "mcp3008_interface.v"
`include "tx_mux.v"

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
   // debug,         // debug port
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
   // output wire [4:0] debug;

   // include header file with localparams needed across modules or for sim
   `include "controller.vh"
   `include "ccd_readout.vh"

   // Clock divider
   
   reg [23:0] 	clk_div = 0;
   // wire 	clk = ft_clkout; // 60 MHz
   wire 	clk = clk_in; // 100 MHz

   always @(posedge clk) begin
      clk_div <= clk_div + 1;
   end

   // FPGA settings register
   reg [7:0] fpga_reg [2:0];
   wire [7:0] peltier_1_duty_cycle = fpga_reg[0];
   wire [7:0] peltier_2_duty_cycle = fpga_reg[1];
   wire [7:0] fpga_reg2 = fpga_reg[2];
   wire [1:0] ccd_readout_mode = fpga_reg2[1:0];
   
      
   // Synchronous FT245 Interface
   
   wire tx_fifo_rinc;
   wire tx_fifo_rempty;
   wire [7:0] tx_fifo_rdata;
   wire [7:0] rx_fifo_wdata;
   wire rx_fifo_wfull;
   wire rx_fifo_winc;
   wire [3:0] ft_state_out;
   wire       ft_busy;

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
      .rx_winc(rx_fifo_winc),
      .busy(ft_busy)
      );

   
   // // FIFO for receiving data from FT245 interface

   reg 	rx_fifo_rinc;
   reg 	rx_fifo_rrst_n;
   reg 	rx_fifo_wrst_n;
   wire rx_fifo_rempty;
   wire [7:0] rx_fifo_rdata;
   
   fifo #(8, 4) rx_fifo
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

   `ifdef SYNTHESIS
   fifo #(8, 4) tx_fifo
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
   `else
   fifo #(8, 4) tx_fifo
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
   `endif   



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
   assign mcp_dclk = (mcp_busy == 1'b1) ? mcp_dclk_internal : 1'b1;

   mcp3008_interface mcp3008
     (
      .clk(clk),                     // system clock
      .sample(mcp_toggle),           // sample on posedge
      .dclk(mcp_dclk_internal),      // mcp3008 data clock
      .dout(mcp_dout),               // mcp3008 data out
      .din(mcp_din),                 // mcp3008 data in
      .cs_n(mcp_cs_n),               // mcp3008 active low chip select
      .busy(mcp_busy),               // this interface is busy
      .dout_reg(mcp_data),           // 10 bit output
      .dout_avail(mcp_data_avail),   // data is available if this is high
      .dout_accept(mcp_data_accept)  // data has been accapted if this is high
      );
   

   // CCD clocks and AD9826 sampling

   reg 	      ccd_readout_toggle;
   wire       ccd_readout_busy;
   wire	      ccd_readout_data_accept;
   wire       ccd_readout_data_avail;
   wire [15:0] ccd_readout_data;
   
   ccd_readout ccd_readout
     (
      .clk(clk),
      .ad_cdsclk1(ad_cdsclk1),
      .ad_cdsclk2(ad_cdsclk2),
      .ad_adclk(ad_adclk),
      .ad_oeb_n(ad_oeb_n),
      .ad_data(ad_data),
      .kaf_r(kaf_r),
      .kaf_h1(kaf_h1),
      .kaf_v1(kaf_v1),
      .kaf_v2(kaf_v2),
      .kaf_amp(kaf_amp),
      .module_clk(clk_div[2]),
      .busy(ccd_readout_busy),
      .toggle(ccd_readout_toggle),
      .mode(ccd_readout_mode),
      .data_out(ccd_readout_data),
      .data_avail(ccd_readout_data_avail),
      .data_accept(ccd_readout_data_accept)
      );

   
   // AD9826 configuration module

   // 1 r/w bit, 3 address bits, 3 don't-care bits, 9 config bits = 16 total
   reg [15:0] ad_config_in = 16'h00;
   wire [15:0] ad_config_out;
   reg	       ad_config_toggle;
   wire        ad_config_data_avail;
   wire        ad_config_data_recieved;
   wire        ad_config_busy;
   // 100 MHz / 2^(3+1) = 6.25 MHz (Maximum is 10 MHz)
   wire        ad_clk = clk_div[3];
   
   ad9826_config ad9826_config
     (
      .clk(clk),
      .ad_config_in(ad_config_in),
      .ad_config_out(ad_config_out),
      .ad_sload(ad_sload),
      .ad_sclk(ad_sclk),
      .ad_sdata(ad_sdata),
      .ad_clk(ad_clk),
      .toggle(ad_config_toggle),
      .config_out_avail(ad_config_data_avail),
      .config_out_recieved(ad_config_data_recieved),
      .busy(ad_config_busy)
      );

   
   // TX formatter. Attached a 8-bit header, then writes the input two bytes
   // to the tx fifo.

   wire        dummy_accept_1;
   tx_mux tx_mux
     (
      .clk(clk),
      .req({
	    1'b0, 
	    ad_config_data_avail, 
	    mcp_data_avail, 
	    ccd_readout_data_avail
	    }),
      .in_0(ccd_readout_data), // priority 1 input
      .in_1(mcp_data), // priority 2 input
      .in_2(ad_config_out), // priority 3 input
      // .in_3(), // priority input
      .wfull(tx_fifo_wfull), // tx fifo is full, active high
      .out(tx_fifo_wdata), // 8-bit output
      .winc(tx_fifo_winc), // tx fifo write increase, active high
      .accept({
	       dummy_accept_1, 
	       ad_config_data_recieved, 
	       mcp_data_accept,
	       ccd_readout_data_accept
	       })
      );

   
   // Shutter PWM
   
   localparam shutter_closed_duty_cycle = 8'h79; // for 100 MHz clock
   localparam shutter_open_duty_cycle = 8'h40; // for 100 MHz clock
   // localparam shutter_closed_duty_cycle = 8'h49; // for 60 MHz clock
   // localparam shutter_open_duty_cycle = 8'h26; // for 60 MHz clock
   reg [7:0] pwm_shutter_duty_cycle;

   // The last equality makes the PWM skip all but every 4th pulse, so that 
   // there is approximately 20 us between pulses.
   assign pwm_shutter = ( clk_div[17:10] <= pwm_shutter_duty_cycle && 
			  clk_div[20:17] == 0 );


   // Peltier element control

   assign pwm_peltier_1 = ( clk_div[12:5] < peltier_1_duty_cycle );
   assign pwm_peltier_2 = ( clk_div[12:5] < peltier_2_duty_cycle );
   

   // State-machine
   
   // Shutter states
   localparam shutter_state_open   = 1'b0; // open shutter
   localparam shutter_state_closed = 1'b1; // close shutter

   // Main state machine
   localparam state_reset             = 5'b00000;
   localparam state_idle              = 5'b00001;
   localparam state_get_cmd           = 5'b00011;
   localparam state_eval_cmd          = 5'b00010;
   localparam state_setup_msb         = 5'b00110;
   localparam state_get_msb           = 5'b00111;
   localparam state_wait_lsb          = 5'b00101;
   localparam state_setup_lsb         = 5'b00100;
   localparam state_get_lsb           = 5'b01100;
   localparam state_toggle_mcp_1      = 5'b01101;
   localparam state_toggle_mcp_2      = 5'b01111;
   localparam state_wait_adconf       = 5'b01110;
   localparam state_toggle_adconf_1   = 5'b01010;
   localparam state_toggle_adconf_2   = 5'b01011;
   localparam state_toggle_read_ccd_1 = 5'b01001;
   localparam state_toggle_read_ccd_2 = 5'b01000;
   localparam state_set_register      = 5'b11000;

   reg [4:0] state = state_reset;
   reg 	     shutter_state = shutter_state_closed;
   reg [7:0] rx_cmd = 8'h00;
   reg [7:0] rx_msb = 8'h00;
   reg [7:0] rx_lsb = 8'h00;

   
   // state logic
   always @(posedge clk) begin

      state <= state_reset;

      case (state)

	state_reset: begin
	   state <= state_idle;
	   fpga_reg[0] <= 8'h00;
	   fpga_reg[1] <= 8'h00;
	   fpga_reg[2] <= 8'h00;
	end
	
	
	state_idle: begin
	   state <= state_idle;
	   // wait for the rx fifo to have data
	   if (rx_fifo_rempty == 1'b0 && ft_busy == 1'b0) begin
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
	     state <= state_toggle_mcp_1;
	   
	   if (rx_cmd == cmd_toggle_read_ccd)
	     state <= state_toggle_read_ccd_1;
	   
	   if (rx_cmd == cmd_close_shutter)
	     shutter_state <= shutter_state_closed;
	   if (rx_cmd == cmd_open_shutter)
	     shutter_state <= shutter_state_open;
	   
	   if (rx_cmd == cmd_set_register || rx_cmd == cmd_rw_adconf)
	     // wait for the rx fifo to have more data and make sure that the
	     // ft245 interface is not busy fetching data.
	     if (rx_fifo_rempty == 1'b0 && ft_busy == 1'b0)
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
	   state  <= state_wait_lsb;
	end

	state_wait_lsb: begin
	   // wait for the rx fifo to have more data and make sure that the
	   // ft245 interface is not busy fetching data.
	   if (rx_fifo_rempty == 1'b0 && ft_busy == 1'b0)
	     state <= state_setup_lsb;
	   else
	     state <= state_wait_lsb;
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
	
	state_toggle_mcp_1:
	  state <= state_toggle_mcp_2;
	state_toggle_mcp_2:
	  state <= state_idle;
	
	state_wait_adconf:
	  if ( ad_config_busy == 1'b0) begin
	     state <= state_toggle_adconf_1;
	     ad_config_in <= {rx_msb, rx_lsb};
	  end
	  else
	    state <= state_wait_adconf;
	
	state_toggle_adconf_1:
	  state <= state_toggle_adconf_2;
	state_toggle_adconf_2:
	  state <= state_idle;
	
	state_toggle_read_ccd_1:
	  state <= state_toggle_read_ccd_2;
	state_toggle_read_ccd_2:
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
      if ( state == state_toggle_mcp_1 ) begin
	 mcp_toggle = 1'b1;
      end
      if ( state == state_toggle_mcp_2 ) begin
	 mcp_toggle = 1'b1;
      end
      if ( state == state_wait_adconf ) begin
      end
      if ( state == state_toggle_adconf_1 ) begin
	 ad_config_toggle = 1'b1;
      end
      if ( state == state_toggle_adconf_2 ) begin
	 ad_config_toggle = 1'b1;
      end
      if ( state == state_toggle_read_ccd_1 ) begin
	 ccd_readout_toggle = 1'b1;
      end
      if ( state == state_toggle_read_ccd_2 ) begin
	 ccd_readout_toggle = 1'b1;
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

   
   // assign debug = {ad_config_busy, ad_config_toggle, ad_sclk, ad_sload};
   
endmodule // top
