`timescale 1ns / 1ps

module RegisterFile(
clk, rst_n, WriteEn, WriteReg, WriteData,
ReadEn, ReadReg1, ReadReg2, ReadReg3,
ReadData1, ReadData2, ReadData3);

  parameter M = 4;
  parameter N = 16;//N=2**M
  parameter W = 8;
  
  input clk, rst_n;
  input WriteEn;
  input [M-1:0] WriteReg;
  input signed [W-1:0] WriteData;
  input ReadEn;
  input [M-1:0] ReadReg1, ReadReg2, ReadReg3;
  output reg signed [W-1:0] ReadData1, ReadData2, ReadData3;
  
  reg signed [W-1:0] reg_file [0:N-1];//NxWbit�� reg_file

  //�б� ���
  always @(posedge clk or negedge rst_n)
  begin
    if(!rst_n) begin//rst_n�� 0�� ��
       ReadData1 <= {W{1'b0}};//�� output ��� 0���� �ʱ�ȭ
       ReadData2 <= {W{1'b0}};
       ReadData3 <= {W{1'b0}};
    end
    else begin//if(rst_n)
      if(ReadEn) begin//rst_n�� 1�� �� ReadEn�� 1�̸�
        ReadData1 <= reg_file[ReadReg1];//ReadData1�� reg_file[ReadReg1]
        ReadData2 <= reg_file[ReadReg2];//ReadData2�� reg_file[ReadReg2]
        ReadData3 <= reg_file[ReadReg3];//ReadData2�� reg_file[ReadReg2]
      end//if(ReadEn)
    end//else //if(rst_n)
  end//always

  //���� ���
  always @(posedge clk or negedge rst_n)
  begin
    if(!rst_n) reg_file[WriteReg] <= {W{1'bx}};//rst_n�� 0�̸� reg_file[WriteReg]�� unknown���� �ʱ�ȭ
    else begin//rst_n�� 1�� ��
      if(WriteEn) reg_file[WriteReg] <= WriteData;//WriteEn�� 1�̸� reg_file[WriteReg]�� WriteData �Է�
    end//else //if(rst_n)
  end

endmodule


