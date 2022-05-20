`timescale 1ns / 1ps

module tb_Lemmings3();
  reg clk;
  reg areset;
  reg bump_left;
  reg bump_right;
  reg ground;
  reg dig;
  wire walk_left;
  wire walk_right;
  wire aaah;
  wire digging;
  
  initial begin
    clk = 1; areset = 1; bump_left = 0; bump_right = 0; ground = 1; dig = 0;
    #1 areset = 0;
    #1 areset = 1;
    #20 dig = 1;
    #10 dig = 0;
    #10 bump_left = 1;
    #10 bump_left = 0;
    #10 ground = 0;
    #30 ground = 1; dig = 1;
    #10 dig = 0;
    #40 $finish;
  end
    
    always #5 clk=~clk;
    
    Lemmings3 lem3(clk, areset, bump_left, bump_right, ground, dig, walk_left, walk_right, aaah, digging);
endmodule

