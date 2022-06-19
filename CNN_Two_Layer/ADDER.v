`timescale 1ns / 1ps

module ADDER(clk, rst_n, data1, data2, data3, out);
  parameter Y = 8;
  input clk, rst_n;
  input signed [Y-1:0] data1, data2, data3;
  output reg signed [Y+1:0] out;//Ybit �� ���� ���� �ִ� (Y+2)bit
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) out <= 0;//rst_n�� 0�̸� out�� 0���� �ʱ�ȭ
    else out <= data1 + data2 + data3;//rst_n�� 1�̸� out�� data1, data2, data3�� ��
  end
endmodule
