module ad9826_config_tb();

   reg clk;
   
   reg [15:0]  ad_config_in;
   wire [15:0] ad_config_out;
   wire        config_out_avail;
   reg 	       config_out_recieved;
   wire        busy;
   wire        ad_sclk;
   wire        ad_sload;
   inout       ad_sdata;
   reg 	       toggle;
   reg [7:0]   counter;

   reg 	       read;
   reg 	       d_bit;
   assign ad_sdata = (read && bit_count > 6) ? d_bit : 1'bz;

   ad9826_config dut
     (
      .ad_config_in(ad_config_in),
      .ad_config_out(ad_config_out),
      .config_out_avail(config_out_avail),
      .config_out_recieved(config_out_recieved),
      .busy(busy),
      .ad_sload(ad_sload),
      .ad_sclk(ad_sclk),
      .ad_sdata(ad_sdata),
      .toggle(toggle),
      .counter(counter)
      );

   always begin
      #1 clk <= !clk;
   end
   always @(posedge clk)
     counter <= counter + 1;

   reg [3:0] bit_count = 0;
   reg [2:0] addr_in;
   reg [8:0] conf_mem [8:0];
   wire [8:0] mem000 = conf_mem[3'b000];
   wire [8:0] mem001 = conf_mem[3'b001];
   wire [8:0] mem010 = conf_mem[3'b010];
   wire [8:0] mem011 = conf_mem[3'b011];
   wire [8:0] mem100 = conf_mem[3'b100];
   wire [8:0] mem101 = conf_mem[3'b101];
   wire [8:0] mem110 = conf_mem[3'b110];
   wire [8:0] mem111 = conf_mem[3'b111];
   
   always @(posedge ad_sclk) begin
      if ( ad_sload == 1'b0 ) begin
	 if (bit_count == 0)
	   read <= ad_sdata;
	 else if ( bit_count > 0 && bit_count < 4 )
	   addr_in[3 - bit_count] <= ad_sdata;
	 else if ( !read && bit_count > 6 )
	   conf_mem[addr_in][8 + 7 - bit_count] <= ad_sdata;
	 bit_count <= bit_count + 1;
      end
   end // always @ (posedge ad_sclk)

   always @(negedge ad_sclk) begin
      if (read && bit_count > 6)
	d_bit <= conf_mem[addr_in][8 + 7 - bit_count]; // msb first
   end
   
   task wait_busy_low;
      begin
	 
	 fork : f // implement a wait until busy goes high
	    begin
	       // wait_busy check
	       #2000000 $display("%t : wait_busy", $time);
	       disable f;
	    end
	    begin
	       @(negedge busy);
	       disable f;
	    end
	 join
	    
      end
   endtask // mcp_wait
   
   task wait_avail;
      begin
	 
	 fork : f2 // implement a wait until config_out_avail goes high
	    begin
	       #2000000 $display("%t : wait_avail", $time);
	       disable f2;
	    end
	    begin
	       @(posedge config_out_avail);
	       disable f2;
	    end
	 join
	    
      end
   endtask // mcp_wait

   initial begin
      
      clk     <= 1'b0;
      counter <= 0;
      config_out_recieved <= 1'b0;

      // write config to 000
      ad_config_in <= 16'b0000000_011011000;
      toggle <= 1'b0;
      read <= 1'b0;
      d_bit <= 1'b0;
      
      $dumpfile("ad9826_config_tb.vcd");
      $dumpvars;
      
      #10
      
      #1 toggle <= 1'b1;
      #1 wait_busy_low();
      #1 toggle <= 1'b0;

      // write config to 001
      #1 ad_config_in <= 16'b0001000_000011110;
      #1 toggle <= 1'b1;
      #1 wait_busy_low();
      #1 toggle <= 1'b0;
      
      // read config from 000
      #1 ad_config_in <= 16'b1000000_000000000;
      #1 toggle <= 1'b1;
      #1 wait_avail();
      #1 toggle <= 1'b0;
      #1 config_out_recieved <= 1'b1;
      #1 wait_busy_low();
      #1 config_out_recieved <= 1'b0;
			       
      
      // read config from 001
      #1 ad_config_in <= 16'b1001000_000000000;
      #1 toggle <= 1'b1;
      #1 wait_avail();
      #1 toggle <= 1'b0;
      #1 config_out_recieved <= 1'b1;
      #1 wait_busy_low();
      #1 config_out_recieved <= 1'b0;

      #10000 $finish;

   end
   
   
endmodule // ad9826_config_tb

