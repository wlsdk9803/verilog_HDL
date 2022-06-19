module updown_counter(clk, rst_n, data, load, enable, select, out);//updown counter module
  input clk, rst_n, load, enable, select;//1bit의 input clk, rst_n, load, enable, select
  input [3:0] data;//4bit의 input data
  output reg [3:0] out;//4bit의 output out. always 문 안에서 값을 넣어줄 것이므로 reg로 선언
  
  always @(posedge clk or negedge rst_n) begin//clk이 상승하거나 rst_n이 하강할 때
    if(!rst_n) out <= 4'b0000;//rst_n이 0이면 out은 0000으로 초기화. non-blocking
    else begin//rst_n이 1일 때
      if(load) out <= data;//load가 1이면 out에 data 입력
      else begin//load가 0이면
        if(enable) out <= select? out+1 : out -1;//enable이 1일 때
                                                 //select가 1이면 out에 1 더하고, 0이면 1을 뺌
        else out <= out;//enable이 0이면 out은 값 유지
      end
    end
  end
endmodule
