`timescale 1ns / 1ps

module tb_Muxed_Galois_LFSR();
  reg clk;
  reg arst_n;
  reg [2:0] r;
  reg L;
  wire [2:0] LFSR;
  
  initial begin
    clk = 1; arst_n = 1; r=3'b111; L=0;
    #1 arst_n = 0;
    #1 arst_n = 1;
    #50 L=1;
    #20 L=0;
    #98 $finish;
  end
  
  always #5 clk = ~clk;
  
  Muxed_Galois_LFSR Muxed_Galois(clk, arst_n, r, L, LFSR);
endmodule