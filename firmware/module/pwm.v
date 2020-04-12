`default_nettype none

module pwm
  (
   counter,
   duty_cycle,
   out
   );
   
   input [7:0] counter;
   input [7:0] duty_cycle;
   
   output      out;
   assign out = counter <= duty_cycle ? 1 : 0;
   
endmodule // pwm

  
