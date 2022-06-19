`timescale 1ns / 1ps

module CNN_Single_Layer(clk, rst_n, Start, Image, Filter, ReadEn, ConvResult);
    parameter M = 4;//Layer1: M=4, Layer2: M=10
    input clk;
    input rst_n;
    input Start;
    input [M-1:0] Image;
    input signed [M-1:0] Filter;
    input ReadEn;
    output signed [2*M + 1:0] ConvResult;//ConvResultÀÇ bit ¼ö = 2*M + 2

    wire signed [2*M-1:0] MultValue;
   
    wire [3:0] WriteReg;
    
    wire [3:0] ReadReg1, ReadReg2, ReadReg3;
    wire signed [2*M-1:0] ReadData1, ReadData2, ReadData3;
    
    wire signed [2*M+1:0] Conv_to_ReLU;

    Multiplicator #(.X(M)) Multiplicator (.Start(Start), .din0(Image), .din1(Filter), .dout(MultValue));
    
    AddressCounter AddressCounter (.clk(clk), .rst_n(rst_n), .Start(Start), .WriteReg(WriteReg), .ReadEn(ReadEn),
        .ReadReg1(ReadReg1), .ReadReg2(ReadReg2), .ReadReg3(ReadReg3));
        
    RegisterFile #(.M(4), .N(15), .W(2*M))
        RegisterFile (.clk(clk), .rst_n(rst_n), .WriteEn(Start), .WriteReg(WriteReg), .WriteData(MultValue),
        .ReadEn(ReadEn), .ReadReg1(ReadReg1), .ReadReg2(ReadReg2), .ReadReg3(ReadReg3),
        .ReadData1(ReadData1), .ReadData2(ReadData2), .ReadData3(ReadData3));
    
    ADDER #(.Y(2*M)) ADDER(.clk(clk), .rst_n(rst_n), .data1(ReadData1), .data2(ReadData2), .data3(ReadData3), .out(Conv_to_ReLU));
    
    ReLU #(.Z(2*M+2)) ReLU (.d_in(Conv_to_ReLU), .d_out(ConvResult));
endmodule
