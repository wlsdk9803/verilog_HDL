`timescale 1ns / 1ps

module tb_RisingEdge_Detector();
  reg clk, rst_n;
  reg X;
  wire Y;
  
  initial begin
    clk=1; rst_n = 0; X = 0;
    #5 rst_n=1;
    #10 X=1;
    #10 X=0;
    #20 X=1;
    #10 X=0;
    #20 X=1;
    #10 X=0;
    #10 $finish;
  end
  
  always #5 clk=~clk;
  
  RisingEdge_Detector risingEdge(clk, rst_n, X, Y);
endmodule
