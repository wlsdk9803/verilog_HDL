`timescale 1ns / 1ps

module ReLU(d_in, d_out);
  parameter Z = 10;
  input signed [Z-1:0] d_in;
  output [Z-1:0] d_out;
  
  assign d_out = (d_in[Z-1] == 0) ? d_in : 0;//d_in�� ������ d_out�� 0, �ƴϸ� �״�� d_in ���
endmodule
