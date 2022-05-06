`timescale 1ns / 1ps

module ADDER(clk, rst_n, data1, data2, data3, out);
  input clk, rst_n;
  input [7:0] data1, data2, data3;
  output reg [9:0] out;//8bit 세 수의 합은 최대 10bit
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) out <= 10'b0;//rst_n이 0이면 out은 0으로 초기화
    else out <= data1 + data2 + data3;//rst_n이 1이면 out은 data1, data2, data3의 합
  end
endmodule