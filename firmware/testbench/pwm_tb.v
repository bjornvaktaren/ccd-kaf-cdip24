module pwm_tb();

   reg [15:0] counter;
   wire       pwm_out;

   reg [7:0]  duty_cycle;
   
   pwm dut
   (
    .counter(counter[7:0]),
    .duty_cycle(duty_cycle),
    .out(pwm_out)
    );

   reg 	      clk;
   
   always begin
      #1 clk <= !clk;
   end

   always @(posedge clk) begin
      counter = counter + 1;
   end
   
   initial begin
      clk <= 0;
      counter <= 0;
      $dumpfile("pwm_tb.vcd");
      $dumpvars;
      duty_cycle <= 1;
      #1024 duty_cycle <= 63;
      #1024 duty_cycle <= 127;
      #1024 duty_cycle <= 255;
      #1024 $finish;
   end

endmodule // pwm_tb

      
			
