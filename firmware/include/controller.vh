localparam cmd_none          = 8'b00000000; // no command
localparam cmd_get_mcp       = 8'b00000001; // get the latest temperature value
localparam cmd_read_ccd      = 8'b00000010; // read out the ccd
localparam cmd_shutter_open  = 8'b00000100; // open the shutter
localparam cmd_shutter_close = 8'b00001000; // close the shutter
localparam cmd_set_ccd_conf  = 8'b00010000; // set the ccd config register
localparam cmd_peltier_on    = 8'b00100000; // turn on peltier cooling
localparam cmd_peltier_off   = 8'b01000000; // turn off peltier cooling
localparam cmd_peltier_1_set = 8'b10000000; // set pwm value for peltier 1
localparam cmd_peltier_2_set = 8'b11000000; // set pwm value for peltier 2

