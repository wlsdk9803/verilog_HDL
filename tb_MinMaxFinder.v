`timescale 1ns / 1ps

module tb_MinMaxFinder();
  reg clk;
  reg WriteEn;
  reg [2:0] WriteReg;
  reg [15:0] WriteData;
  wire [15:0] Max;
  wire [15:0] Min;
  wire Valid;
  
  MinMaxFinder min_max(clk, WriteEn, WriteReg, WriteData, Max, Min, Valid);
  
  initial begin
    clk = 0; WriteEn = 0; WriteReg = 3'b0; WriteData = 16'b0000_0010_0000_0000;
    #5 WriteEn = 1; 
       WriteReg = 3'b0;   WriteData = 16'b0000_0010_0000_0000;
    #5 WriteReg = 3'b001; WriteData = 16'b0001_0000_0010_0011;
    #5 WriteReg = 3'b010; WriteData = 16'b0000_0011_0000_0110;
    #5 WriteReg = 3'b011; WriteData = 16'b0000_0000_0000_1111;
    #5 WriteReg = 3'b100; WriteData = 16'b0100_0000_0001_0000;
    #5 WriteReg = 3'b101; WriteData = 16'b0000_1100_0011_1110;
    #5 WriteReg = 3'b110; WriteData = 16'b0011_0000_0111_1001;
    #5 WriteReg = 3'b111; WriteData = 16'b0000_0110_0001_1111;
    #100 $finish;
  end
  
  always #2 clk <= ~clk;
endmodule
