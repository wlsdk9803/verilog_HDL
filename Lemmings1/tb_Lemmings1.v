`timescale 1ns / 1ps

module tb_Lemmings1();
  reg clk;
  reg rst_n;
  reg bump_left;
  reg bump_right;
  wire walk_left;
  wire walk_right;
  
  initial begin
    clk = 1; rst_n = 1; bump_left = 0; bump_right = 0;
    #2 rst_n = 0;
    #2 rst_n = 1;
    #38 bump_right = 1;
    #20 bump_right = 0;
    #40 bump_left = 1;
    #20 bump_left = 0;
    #60 bump_right = 1; bump_left = 1;
    #40 bump_right = 0; bump_left = 0;
    #80 $finish;
  end
    
    always #10 clk=~clk;
    
    Lemmings1 game1(clk, rst_n, bump_left, bump_right, walk_left, walk_right);
endmodule
