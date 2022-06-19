`timescale 1ns / 1ps

module tb_random_LFSR();
  reg clk;
  reg arst_n;
  wire [4:0] LFSR;
  
  initial begin
    clk = 1; arst_n = 1;
    #1 arst_n = 0;
    #1 arst_n = 1;
    #338 $finish;
  end
  
  always #5 clk = ~clk;
  
  random_LFSR randomGenerator(clk, arst_n, LFSR);
endmodule