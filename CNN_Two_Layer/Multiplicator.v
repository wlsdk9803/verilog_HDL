`timescale 1ns / 1ps

module Multiplicator(Start, din0, din1, dout);
  parameter X = 4;
  input Start;
  input [X-1:0] din0;//Image�� ȭ�Ұ��̹Ƿ� ���
  input signed [X-1:0] din1;//Filter�� ���� �� ��� ����
  output reg signed [2*X-1:0] dout;//Xbit �� ���� ���� �ִ� 2*Xbit

  always @(*) begin
    if(!Start) dout = 0;//Start�� 0�̸� dout 0���� �ʱ�ȭ
    else dout = $signed({1'b0, din0}) * $signed(din1);//Start�� 1�̸� dout��  din0*din1
                                                      //unsigned�� din0�� signed bit�� 0 ����
  end//always
endmodule
