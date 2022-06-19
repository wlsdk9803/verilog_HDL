`timescale 1ns / 1ps

module tb_CNN_Two_Layer();
    
    reg clk;
    reg rst_n;
    // Layer 1 input signal
    reg Start1;
    reg [3:0] Image;
    reg signed [3:0] Filter1;
    reg ReadEn1;
    // Layer 2 input signal
    reg Start2;
    reg signed [9:0] Filter2;
    reg ReadEn2;
    // Layer 2 output signal
    wire signed [21:0] ConvResult;
    
    initial begin
    clk = 0; rst_n = 1;
    Image = 0;  Filter1 = 0;    Start1 = 0; ReadEn1 = 0;
                Filter2 = 0;    Start2 = 0; ReadEn2 = 0;  
    #10; rst_n = 0;
    #10; rst_n = 1;
        // Layer1 연산 시작  
   #10; Image = 4'd1;     Filter1 = 4'd1;  Start1 = 1;
   #10; Image = 4'd2;     Filter1 = 4'd2;
   #10; Image = 4'd3;     Filter1 = 4'd3;
                                 
   #10; Image = 4'd2;     Filter1 = 4'b1101;
   #10; Image = 4'd3;     Filter1 = 4'b1110;
   #10; Image = 4'd4;     Filter1 = 4'b1111;
                                 
   #10; Image = 4'd3;     Filter1 = 4'd1;
   #10; Image = 4'd4;     Filter1 = 4'd2;
   #10; Image = 4'd5;     Filter1 = 4'd3;
                                 
   #10; Image = 4'd4;     Filter1 = 4'b1011;
   #10; Image = 4'd5;     Filter1 = 4'b0101;
   #10; Image = 4'd6;     Filter1 = 4'b1001;
                                 
   #10; Image = 4'd5;     Filter1 = 4'd1;
   #10; Image = 4'd6;     Filter1 = 4'd2;
   #10; Image = 4'd7;     Filter1 = 4'd3;
   
   #10; Image = 4'd0;     Filter1 = 4'd0;  Start1 = 0;
   #10; ReadEn1 = 1;
   // Layer 1 연산 끝
   #10; 
//   // Layer 2 연산 시작
    @(posedge clk) Filter2 = 10'd1; #1   Start2 = 1;       
    @(posedge clk) Filter2 = 10'd2;
    @(posedge clk) Filter2 = 10'd3;
              
    @(posedge clk) Filter2 = 10'd1023;
    @(posedge clk) Filter2 = 10'd1022;
    @(posedge clk) Filter2 = 10'd1021;

    @(posedge clk) Filter2 = 10'd4;
    @(posedge clk) Filter2 = 10'd5;
    @(posedge clk) Filter2 = 10'd6;

    @(posedge clk) Filter2 = 10'd1020;
    @(posedge clk) Filter2 = 10'd1019;
    @(posedge clk) Filter2 = 10'd1018;

    @(posedge clk) Filter2 = 10'd7;
    @(posedge clk) Filter2 = 10'd8;
    @(posedge clk) Filter2 = 10'd9;

    @(posedge clk) Filter2 = 10'd0; #10;   Start2 = 0;
    @(posedge clk) ReadEn2 = 1;
    // Layer 2 연산 끝
   #100; $finish;
    end
    
    always #5 clk = ~clk;
    
    CNN_Two_Layer uut(
    .clk(clk),
    .rst_n(rst_n),
    
    .Start1(Start1),
    .Image(Image),
    .Filter1(Filter1),
    .ReadEn1(ReadEn1),

    .Start2(Start2),
    .Filter2(Filter2),
    .ReadEn2(ReadEn2),
    .ConvResult(ConvResult)
    );

endmodule