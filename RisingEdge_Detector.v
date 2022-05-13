module RisingEdge_Detector(clk, rst_n, X, Y);
  input clk, rst_n;
  input X;
  output reg Y;
  
  localparam S0=2'b00,
             S1=2'b01,
             S2=2'b10;
             
  reg [1:0] present_state, next_state;
  
  //다음 상태 결정
  always @(present_state or X) begin//현재 상태나 입력이 바뀔 때
    case(present_state)
      S0: if(X) next_state=S1;//현재 상태가 S0일 때 1이 들어오면 S1
          else  next_state=S0;//0이 들어오면 그대로 S0
      S1: if(X) next_state=S2;//현재 상태가 S1일 때 1이 들어오면 S2
          else  next_state=S0;//0이 들어오면 S0
      S2: if(X) next_state=S2;//현재 상태가 S2일 때 1이 들어오면 그대로 S2
          else  next_state=S0;//0이 들어오면 S0
      default:  next_state=S0;//기본 값은 S0
    endcase
  end
  
  //현재 상태 결정
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) present_state <= S0;//rst_n이 0일 때 현재 상태 S0으로 초기화
    else       present_state <= next_state;//rst_n이 1이면 현재 상태는 다음 상태로
  end
  
  //출력 계산
  always @(present_state) begin
    case(present_state)
      S0: Y = 1'b0;
      S1: Y = 1'b1;//현재 상태가 S2일 때만 1, 나머지는 0
      S2: Y = 1'b0;
      default: Y = 1'b0;
    endcase
  end
endmodule