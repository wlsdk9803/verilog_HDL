`timescale 1ns / 1ps

module tb_registerFile_logic();
  reg clk, rst, start;
  reg WriteEnA;
  reg [3:0] WriteDataA;
  reg [2:0] ReadRegA1, ReadRegA2;
  reg [2:0] WriteRegA;
  reg WriteEnB;
  reg [7:0] WriteDataB;
  reg [3:0] ReadRegB;
  reg [3:0] WriteRegB;
  
  wire [3:0] out1, out2;

  registerFile_logic registerFlieLogic(clk, rst, start,
                                           ReadRegA1, ReadRegA2, WriteRegA, WriteEnA, WriteDataA, 
                                           ReadRegB, WriteRegB, WriteEnB, WriteDataB,
                                           out1, out2);

  initial begin
    clk = 0; 
       rst = 1; start = 0;
       WriteEnA = 0; ReadRegA1 = 0; ReadRegA2 = 0; WriteRegA = 0; WriteDataA = 0;
       WriteEnB = 0; ReadRegB = 0;                 WriteRegB = 0; WriteDataB = 0;
    #5 rst = 0; start = 1;
       ReadRegA1 = 3'b011; ReadRegA2 = 3'b010; 
       ReadRegB = 4'b0011;
    #8 WriteEnA = 1'b1; WriteRegA = 3'b100;  WriteDataA = 4'b1000;
       WriteEnB = 1'b1; WriteRegB = 4'b1000; WriteDataB = 8'b1100_1111;
    #8 WriteRegA = 3'b110; WriteDataA = 4'b000;
    #8 WriteEnA = 1'b0; ReadRegA1 = 3'b100; ReadRegA2 = 3'b110;
       WriteEnB = 1'b0; ReadRegB = 4'b1000;
    #20 $finish;
  end
  
  always #2 clk <= ~clk;//clk period 4ns


endmodule
