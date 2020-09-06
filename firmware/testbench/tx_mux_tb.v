module tx_mux_tb();

   reg 	      clk;
   reg [3:0]  req;
   reg [15:0] in_0;
   reg [15:0] in_1;
   reg [15:0] in_2;
   reg [15:0] in_3;
   reg 	      wfull;
   wire       winc;
   wire [7:0] out;
   wire [3:0] accept;
   
   tx_mux dut
     (
      .clk(clk),
      .req(req),      // request to send 
      .in_0(in_0),    // priority input
      .in_1(in_1),    // priority input
      .in_2(in_2),    // priority input
      .in_3(in_3),    // priority input
      .wfull(wfull),  // tx fifo is full, active high
      .out(out),      // 8-bit output
      .winc(winc),    // tx figo write increase, active high
      .accept(accept) // mux accepted data, active high, low when done
      );

   always begin
      #1 clk <= !clk;
   end

   initial begin
      clk   <= 0;
      req   <= 4'b0000;
      in_0 <= 16'h0000;
      in_1 <= 16'h0000;
      in_2 <= 16'h0000;
      in_3 <= 16'h0000;
      wfull <= 1'b1;
      
      $dumpfile("tx_mux_tb.vcd");
      $dumpvars;
      
      #1;
      in_0 <= 16'h1234;
      in_1 <= 16'hABCD;
      in_2 <= 16'h5678;
      in_3 <= 16'h1111;
      req  <= 4'b0100;
      #12;
      wfull <= 1'b0;
      #20;
      req  <= 4'b0000;
      
      #10000;
      $finish;
   end

endmodule // pwm_tb

      
			
