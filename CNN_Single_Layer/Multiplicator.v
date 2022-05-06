`timescale 1ns / 1ps

module Multiplicator(Start, din0, din1, dout);
  input Start;
  input [3:0] din0, din1;
  output reg [7:0] dout;//4bit 두 수의 곱은 최대 8bit

  always @(*) begin
    if(!Start) dout = 8'b0;//Start가 0이면 dout 0으로 초기화
    else dout = din0 * din1;//Start가 1이면 dout은  din0*din1
  end//always
endmodule
