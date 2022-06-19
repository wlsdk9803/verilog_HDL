`timescale 1ns / 1ps

module tb_101pattern_Detector();
  reg clk, rst_n;
  reg X;
  wire Y;
  
  initial begin
    clk=1; rst_n = 0; X = 0;
    #2 rst_n=1;
    #5  X=1;
    #10 X=0;
    #20 X=1;
    #10 X=0;
    #10 X=1;
    #10 X=0;
    #20 X=1;
    #10 X=0;
    #20 X=1;
    #20 X=0;
    #10 X=1;
    #10 X=0;
    #10 $finish;
  end
  
  always #5 clk=~clk;
  
  101pattern_Detector patternDetector(clk, rst_n, X, Y);
endmodule
