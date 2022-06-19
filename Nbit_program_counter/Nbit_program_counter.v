module Nbit_program_counter(PCdata, clk, rst_n, PCload, PCinc, PCout);
  parameter n = 32;//parameter의 default 값: 32bits
  input [n-1:0] PCdata;//n-bit input PCdata
  input clk, rst_n, PCload, PCinc;//1bit input clk, rst_n, PCload, PCinc
  output reg [n-1:0] PCout;//n-bit output PCout
  
  always @(posedge clk or negedge rst_n) begin//clk이 상승하거나 rst_n이 하강할 때
    if(!rst_n) PCout <= 0;//rst_n이 0이면 PCout은 0으로 초기화
    else begin//rst_n이 1일 때
      if(PCload) PCout <= PCdata;//PCload가 1이면 PCout에 PCdata 입력
      else begin//PCload가 0일 때
        if(PCinc) PCout <= PCout+1;//PCinc가 1이면 PCout에 1 더함
        else PCout <= PCout;//PCinc가 0이면 PCout 값 유지
      end
    end
  end
endmodule
