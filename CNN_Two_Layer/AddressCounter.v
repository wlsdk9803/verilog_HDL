`timescale 1ns / 1ps

module AddressCounter (
clk, rst_n, Start, WriteReg, ReadEn, ReadReg1, ReadReg2, ReadReg3);

  input clk, rst_n;
  input Start;
  input ReadEn;
  output [3:0] WriteReg;
  output [3:0] ReadReg1, ReadReg2, ReadReg3;
  
  WriteAddressCounter WriteAddress (.clk(clk), .rst_n(rst_n), .Start(Start), .WriteReg(WriteReg));
  ReadAddressCounter #(.init(14)) ReadAddress1 (.clk(clk), .rst_n(rst_n), .ReadEn(ReadEn), .ReadReg(ReadReg1));
  ReadAddressCounter #(.init(0)) ReadAddress2 (.clk(clk), .rst_n(rst_n), .ReadEn(ReadEn), .ReadReg(ReadReg2));
  ReadAddressCounter #(.init(1)) ReadAddress3 (.clk(clk), .rst_n(rst_n), .ReadEn(ReadEn), .ReadReg(ReadReg3));
endmodule



module WriteAddressCounter(clk, rst_n, Start, WriteReg);
  input clk, rst_n;
  input Start;
  output [3:0] WriteReg;
  
  wire [14:0] count;
  
  RingCounter WriteCounter(.clk(clk), .rst_n(rst_n), .en(Start), .count(count));
  AddressEncoder WriteAddress(.Addrin(count), .AddrOut(WriteReg));
endmodule



module RingCounter(clk, rst_n, en, count);
  input clk, rst_n;
  input en;
  output reg [14:0] count;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) count <= {1'b1, 14'b0};//rst_n�� 0�̸� count�� 100_0000_0000_0000���� �ʱ�ȭ
    else begin//if(rst_n)
      if(en) begin//rst_n�� 1�� �� en�� 1�̸�
        if(count == {1'b1, 14'b0}) count <= {14'b0, 1'b1};//count�� 100_0000_0000_0000�̸�
                                                          //000_0000_0000_0001����
        else count <= count << 1;//�� ���� ��쿡�� 1��ŭ shift left
      end//if(en)
    end//else //if(rst_n)
  end//always
endmodule



module AddressEncoder(Addrin, AddrOut);
  input [14:0] Addrin;
  output reg [3:0] AddrOut;
  
  always @(Addrin) begin
    case(Addrin)//Addrin�� ���� ���� AddrOut ����
      15'b000_0000_0000_0001 : AddrOut = 4'd1;
      15'b000_0000_0000_0010 : AddrOut = 4'd2;
      15'b000_0000_0000_0100 : AddrOut = 4'd3;
      15'b000_0000_0000_1000 : AddrOut = 4'd4;
      15'b000_0000_0001_0000 : AddrOut = 4'd5;
      15'b000_0000_0010_0000 : AddrOut = 4'd6;
      15'b000_0000_0100_0000 : AddrOut = 4'd7;
      15'b000_0000_1000_0000 : AddrOut = 4'd8;
      15'b000_0001_0000_0000 : AddrOut = 4'd9;
      15'b000_0010_0000_0000 : AddrOut = 4'd10;
      15'b000_0100_0000_0000 : AddrOut = 4'd11;
      15'b000_1000_0000_0000 : AddrOut = 4'd12;
      15'b001_0000_0000_0000 : AddrOut = 4'd13;
      15'b010_0000_0000_0000 : AddrOut = 4'd14;
      15'b100_0000_0000_0000 : AddrOut = 4'd0;
      default : AddrOut = 4'bx;//default ���� unknown����
    endcase
  end//always
endmodule



module ReadAddressCounter(clk, rst_n, ReadEn, ReadReg);
  parameter init = 14;
  input clk, rst_n;
  input ReadEn;
  output [3:0] ReadReg;
  
  wire [14:0] count;
  
  RingCounterX3 #(.init(init)) ReadCounter(.clk(clk), .rst_n(rst_n), .en(ReadEn), .count(count));
  AddressEncoder ReadAddress(.Addrin(count), .AddrOut(ReadReg));
endmodule



module RingCounterX3(clk, rst_n, en, count);
  parameter init = 14;
  input clk, rst_n;
  input en;
  output reg [14:0] count;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) count <= 1 << init;//rst_n�� 0�̸� count�� 1�� init��ŭ shift left�� ������ �ʱ�ȭ
    else begin//if(rst_n)
      if(en) begin//rst_n�� 1�� �� en�� 1�̸�
        if(count == {1'b1, 14'b0}) count <= {12'b0, 1'b1, 2'b0};//count�� 100_0000_0000_0000�̸� 000_0000_0000_0100����
        else if(count == {1'b0, 1'b1, 13'b0}) count <= {13'b0, 1'b1, 1'b0};//count�� 010_0000_0000_0000�̸� 000_0000_0000_0010����
        else if(count == {2'b0, 1'b1, 12'b0}) count <= {14'b0, 1'b1};//count�� 001_0000_0000_0000�̸� 000_0000_0000_0001����
        else count <= count << 3;//�� ���� ��쿡�� 3��ŭ shift left
      end//if(en)
    end//else //if(rst_n)
  end//always
endmodule
