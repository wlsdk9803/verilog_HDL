module Nbit_program_counter(PCdata, clk, rst_n, PCload, PCinc, PCout);
  parameter n = 32;//parameter�� default ��: 32bits
  input [n-1:0] PCdata;//n-bit input PCdata
  input clk, rst_n, PCload, PCinc;//1bit input clk, rst_n, PCload, PCinc
  output reg [n-1:0] PCout;//n-bit output PCout
  
  always @(posedge clk or negedge rst_n) begin//clk�� ����ϰų� rst_n�� �ϰ��� ��
    if(!rst_n) PCout <= 0;//rst_n�� 0�̸� PCout�� 0���� �ʱ�ȭ
    else begin//rst_n�� 1�� ��
      if(PCload) PCout <= PCdata;//PCload�� 1�̸� PCout�� PCdata �Է�
      else begin//PCload�� 0�� ��
        if(PCinc) PCout <= PCout+1;//PCinc�� 1�̸� PCout�� 1 ����
        else PCout <= PCout;//PCinc�� 0�̸� PCout �� ����
      end
    end
  end
endmodule
