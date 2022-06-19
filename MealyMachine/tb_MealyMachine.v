`timescale 1ns / 1ps

module tb_MealyMachine();
  reg clk, rst_n;
  reg x;
  wire y;
  
  initial begin
    clk=0; rst_n = 0; x = 0;
    #5 rst_n=0;
    #5 rst_n=1;
    #10 x=1;
    #30 x=0;
    #10 x=1;
    #10 x=0;
    #10 x=1;
    #10 x=0;
    #10 $finish;
  end
  
  always #5 clk=~clk;
  
  MealyMachine mealy(clk, rst_n, x, y);
endmodule
