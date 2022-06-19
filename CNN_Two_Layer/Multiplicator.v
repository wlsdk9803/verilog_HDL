`timescale 1ns / 1ps

module Multiplicator(Start, din0, din1, dout);
  parameter X = 4;
  input Start;
  input [X-1:0] din0;//Image는 화소값이므로 양수
  input signed [X-1:0] din1;//Filter는 음수 및 양수 가능
  output reg signed [2*X-1:0] dout;//Xbit 두 수의 곱은 최대 2*Xbit

  always @(*) begin
    if(!Start) dout = 0;//Start가 0이면 dout 0으로 초기화
    else dout = $signed({1'b0, din0}) * $signed(din1);//Start가 1이면 dout은  din0*din1
                                                      //unsigned인 din0는 signed bit에 0 삽입
  end//always
endmodule
