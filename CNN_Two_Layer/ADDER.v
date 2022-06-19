`timescale 1ns / 1ps

module ADDER(clk, rst_n, data1, data2, data3, out);
  parameter Y = 8;
  input clk, rst_n;
  input signed [Y-1:0] data1, data2, data3;
  output reg signed [Y+1:0] out;//Ybit 세 수의 합은 최대 (Y+2)bit
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) out <= 0;//rst_n이 0이면 out은 0으로 초기화
    else out <= data1 + data2 + data3;//rst_n이 1이면 out은 data1, data2, data3의 합
  end
endmodule
