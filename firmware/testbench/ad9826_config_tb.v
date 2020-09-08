module ad9826_config_tb();

   reg clk;
   
   reg [15:0]  ad_config_in;
   wire [15:0] ad_config_out;
   wire        ad_sclk;
   wire        ad_sload;
   inout       ad_sdata;
   reg 	       toggle;
   reg [7:0]   counter;

   reg 	       read;
   reg 	       d_bit;
   
   assign ad_sdata = read ? d_bit : 1'bz;

   ad9826_config dut
     (
      .ad_config_in(ad_config_in),
      .ad_config_out(ad_config_out),
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
   reg [8:0] conf_mem [2:0];
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
	   addr_in[bit_count - 1] <= ad_sdata;
	 else if ( !read && bit_count > 6 )
	   conf_mem[addr_in][bit_count - 7] <= ad_sdata;
	 bit_count <= bit_count + 1;
      end
   end // always @ (posedge ad_sclk)

   always @(negedge ad_sclk) begin
      if (read && bit_count > 6)
	d_bit <= conf_mem[addr_in][bit_count - 7];
   end
   
   task timeout;
      begin
	 
	 fork : f // implement a wait until ad_sload goes high
	    begin
	       // timeout check
	       #2000000 $display("%t : timeout", $time);
	       disable f;
	    end
	    begin
	       @(posedge ad_sload);
	       disable f;
	    end
	 join
	    
      end
   endtask // mcp_wait

   initial begin
      
      clk     <= 1'b0;
      counter <= 0;

      // write config to 000
      ad_config_in <= 16'b00000000_11011000;
      toggle <= 1'b0;
      read <= 1'b0;
      d_bit <= 1'b0;
      
      $dumpfile("ad9826_config_tb.vcd");
      $dumpvars;
      
      #10
      
      toggle <= 1'b1;
      timeout();
      
      // write config to 101
      ad_config_in <= 16'b01010000_11011000;
      timeout();
      
      // read config from 000
      ad_config_in <= 16'b10000000_11011000;
      timeout();
      
      // read config from 101
      ad_config_in <= 16'b10000000_11011000;
      timeout();
	
      $finish;

   end
   
   
endmodule // ad9826_config_tb

