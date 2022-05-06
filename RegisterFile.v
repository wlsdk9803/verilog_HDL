`timescale 1ns / 1ps

module RegisterFile(
clk, rst_n, WriteEn, WriteReg, WriteData,
ReadEn, ReadReg1, ReadReg2, ReadReg3,
ReadData1, ReadData2, ReadData3);

  parameter M = 4;
  parameter N = 15;
  parameter W = 8;
  
  input clk, rst_n;
  input WriteEn;
  input [M-1:0] WriteReg;
  input [W-1:0] WriteData;
  input ReadEn;
  input [M-1:0] ReadReg1, ReadReg2, ReadReg3;
  output reg [W-1:0] ReadData1, ReadData2, ReadData3;
  
  reg [W-1:0] reg_file [0:N-1];//NxWbit의 reg_file

  //읽기 모드
  always @(posedge clk or negedge rst_n)
  begin
    if(!rst_n) begin//rst_n이 0일 때
       ReadData1 <= {W{1'bx}};//세 output 모두 unknown값으로 초기화
       ReadData2 <= {W{1'bx}};
       ReadData3 <= {W{1'bx}};
    end
    else begin//if(rst_n)
      if(ReadEn) begin//rst_n이 1일 때 ReadEn이 1이면
        ReadData1 <= reg_file[ReadReg1];//ReadData1은 reg_file[ReadReg1]
        ReadData2 <= reg_file[ReadReg2];//ReadData2은 reg_file[ReadReg2]
        ReadData3 <= reg_file[ReadReg3];//ReadData2은 reg_file[ReadReg2]
      end//if(ReadEn)
    end//else //if(rst_n)
  end//always

  //쓰기 모드
  always @(posedge clk or negedge rst_n)
  begin
    if(!rst_n) reg_file[WriteReg] <= {W{1'bx}};//rst_n이 0이면 reg_file[WriteReg]을 unknown으로 초기화
    else begin//rst_n이 1일 때
      if(WriteEn) reg_file[WriteReg] <= WriteData;//WriteEn이 1이면 reg_file[WriteReg]에 WriteData 입력
    end//else //if(rst_n)
  end
endmodule