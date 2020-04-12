module sync_ft245_tb();

   reg clk              = 0;
   reg ft_rxf_n         = 1;
   reg ft_txe_n         = 1;
   reg ft_clkout        = 1;
   reg data_to_ft_avail = 0;
   reg [7:0] data_to_ft = 8'h00;
   wire ft_rd_n, ft_wr_n, ft_siwu_n, ft_oe_n, data_from_ft_avail;
   wire [7:0] data_from_ft;
   
   inout [7:0] ft_bus;
   reg [7:0] 	out_reg = 8'h00;
   assign ft_bus = (ft_oe_n == 1'b0) ? out_reg : 8'bZ;

   sync_ft245 dut 
     (
      .ft_bus(ft_bus), 
      .ft_rxf_n(ft_rxf_n), 
      .ft_txe_n(ft_txe_n), 
      .ft_rd_n(ft_rd_n),
      .ft_wr_n(ft_wr_n), 
      .ft_siwu_n(ft_siwu_n),
      .ft_clkout(clk), 
      .ft_oe_n(ft_oe_n), 
      .data_to_ft(data_to_ft),
      .data_to_ft_avail(data_to_ft_avail),
      .data_from_ft(data_from_ft),
      .data_from_ft_avail(data_from_ft_avail)
      );

   
   always begin
      #1 clk <= !clk;
   end

   initial begin
      clk <= 0;
      $dumpfile("sync_ft245_tb.vcd");
      $dumpvars;

      // #2 data_to_ft  <= 8'hAB;
      // data_to_ft_avail  <= 1'b1;
      
      #2 out_reg  <= 8'hAB;
      ft_rxf_n <= 0;
      
      #4 out_reg  <= 8'hAC;
      #2 out_reg  <= 8'hAD;
      #2 out_reg  <= 8'hAE;
      
      #1 ft_rxf_n <= 1;

      #8 ft_txe_n <= 0;
      data_to_ft_avail <= 1;
      #1 data_to_ft <= 8'hF1;
      #2 data_to_ft <= 8'hE2;
      #2 data_to_ft <= 8'hD3;
      ft_txe_n <= 1;
      #2 data_to_ft <= 8'hC4;
      
      
      #10000 $finish;
   end // initial begin

   // always @(negedge ft_rxf_n)

		 
endmodule // sync_ft245_tb
