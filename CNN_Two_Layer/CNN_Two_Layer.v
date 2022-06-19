`timescale 1ns / 1ps

module CNN_Two_Layer(//top module
clk, rst_n,
Start1, Image, Filter1, ReadEn1,
Start2, Filter2, ReadEn2,
ConvResult
    );
    input clk;
    input rst_n;
    //Layer 1 input signals
    input Start1;
    input [3:0] Image;
    input signed [3:0] Filter1;
    input ReadEn1;
    //Layer 2 input signals
    input Start2;
    input signed [9:0] Filter2;
    input ReadEn2;
    //Layer 2 output signal
    output signed [21:0] ConvResult;
    
    wire [9:0] layer1_to_layer2;
    
    CNN_Single_Layer #(.M(4)) Layer1(.clk(clk), .rst_n(rst_n), .Start(Start1), .Image(Image), .Filter(Filter1), .ReadEn(ReadEn1), .ConvResult(layer1_to_layer2));
    CNN_Single_Layer #(.M(10)) Layer2(.clk(clk), .rst_n(rst_n), .Start(Start2), .Image(layer1_to_layer2), .Filter(Filter2), .ReadEn(ReadEn2), .ConvResult(ConvResult));
endmodule
