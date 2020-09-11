localparam cmd_none            = 8'b00000000; // no command
localparam cmd_toggle_mcp      = 8'b00000001; // get the latest ADC values
localparam cmd_toggle_read_ccd = 8'b00000010; // read out the ccd
localparam cmd_open_shutter    = 8'b00000100; // open the shutter
localparam cmd_close_shutter   = 8'b00001000; // close the shutter
localparam cmd_rw_adconf       = 8'b00010000; // read/write from/to ad9826 conf
localparam cmd_set_register    = 8'b00100000; // set fpga register
localparam cmd_reset           = 8'b11111111; // reset
