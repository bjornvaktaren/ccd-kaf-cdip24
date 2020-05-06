localparam cmd_none          = 8'h00; // no command
localparam cmd_get_mcp       = 8'h01; // get the latest temperature value
localparam cmd_read_ccd      = 8'h02; // read out the ccd
localparam cmd_shutter_open  = 8'h03; // open the shutter
localparam cmd_shutter_close = 8'h04; // close the shutter
localparam cmd_set_ccd_mode  = 8'h05; // set the ccd readout mode
localparam cmd_peltier_on    = 8'h06; // turn on peltier cooling
localparam cmd_peltier_off   = 8'h07; // turn off peltier cooling
localparam cmd_peltier_1_set = 8'h08; // set pwm value for peltier 1
localparam cmd_peltier_2_set = 8'h09; // set pwm value for peltier 2

