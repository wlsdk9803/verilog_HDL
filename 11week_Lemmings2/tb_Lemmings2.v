`timescale 1ns / 1ps

module tb_Lemmings2();
  reg clk;
  reg rst_n;
  reg bump_left;
  reg bump_right;
  reg ground;
  wire walk_left;
  wire walk_right;
  wire aaah;
  
  initial begin
    clk = 1; rst_n = 1; bump_left = 0; bump_right = 0; ground = 1;
    #2 rst_n = 0;
    #2 rst_n = 1;
    #38 bump_left = 1;
    #20 bump_left = 0; bump_right = 1;
    #20 bump_right = 0;
    #40 bump_left = 1; ground = 0;
    #80 ground = 1;
    #80 $finish;
  end
    
    always #10 clk=~clk;
    
    Lemmings2 game2(clk, rst_n, bump_left, bump_right, ground, walk_left, walk_right, aaah);
endmodule
