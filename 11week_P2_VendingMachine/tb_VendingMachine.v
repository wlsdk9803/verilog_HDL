`timescale 1ns / 1ps

module tb_VendingMachine();
  reg clk;
  reg rst_n;
  reg coin;
  reg buy;
  wire coffee;
  wire return;
  
  initial begin
    clk=1; rst_n = 0; coin = 0; buy = 0;
    #2 rst_n=1;
    #5  coin = 1; buy = 0;
    #10 coin = 1; buy = 1;
    #10 coin = 1; buy = 0;
    #30 coin = 0; buy = 1;
    #10 coin = 1; buy = 0;
    #30 coin = 0; buy = 1;
    #10 coin = 0; buy = 0;
    #10 $finish;
  end
  
  always #5 clk=~clk;
  
  VendingMachine coffee_vendingMachine(clk, rst_n, coin, buy, coffee, return);
endmodule
