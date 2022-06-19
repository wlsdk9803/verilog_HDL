module 101pattern_Detector(clk, rst_n, X, Y);
  input clk, rst_n;
  input X;
  output reg Y;
  
  localparam S0=2'b00,//0
             S1=2'b01,//1
             S2=2'b10,//10
             S3=2'b11;//101
             
  reg [1:0] present_state, next_state;
  
  //다음 상태 결정
  always @(present_state or X) begin
    case(present_state)
      S0: if(X) next_state=S1;//현재 상태가 0일 때 1이 들어오면 1이 되므로 S1
          else  next_state=S0;//0이 들어오면 그대로 0이므로 S0
      S1: if(X) next_state=S1;//현재 상태가 1일 때 1이 들어오면 11이므로 1로 간주 가능.즉, 그대로 S1
          else  next_state=S2;//0이 들어오면 10이므로 S2
      S2: if(X) next_state=S3;//현재 상태가 10일 때 1이 들어오면 101이므로 S3
          else  next_state=S0;//0이 들어오면 100이고 이는 0으로 간주 가능하므로 S0
      S3: if(X) next_state=S1;//현재 상태가 101일 때 1이 들어오면 1011이고 이는 1로 간주 가능하므로 S1
          else  next_state=S2;//0이 들어오면 1010이므로 10으로 간주 가능. 따라서 S2
      default:  next_state=S0;//기본 값은 S0
    endcase
  end
  
  //현재 상태 결정
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) present_state <= S0;//rst_n이 0이면 현재 상태 S0으로 초기화
    else       present_state <= next_state;//rst_n이 1이면 현재 상태에 다음 상태를 넣는다.
  end
  
  //출력 계산
  always @(present_state) begin
    case(present_state)
      S0: Y = 1'b0;
      S1: Y = 1'b0;
      S2: Y = 1'b0;
      S3: Y = 1'b1;//현재 상태가 S3일 때만 1, 나머지는 0
      default: Y = 1'b0;
    endcase
  end
endmodule
