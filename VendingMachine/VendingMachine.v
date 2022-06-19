module VendingMachine(clk, rst_n, coin, buy, coffee, return);
  input clk;
  input rst_n;
  input coin;
  input buy;
  output coffee;
  output return;
  
  localparam S0 = 3'b000,//초기화 상태(대기 상태)
             S1 = 3'b001,//100원이 들어온 상태
             S2 = 3'b010,//200원이 들어온 상태
             S3 = 3'b011,//300원이 들어오고 커피는 사지 않은 상태
             S4 = 3'b100;//300원이 들어오고 커피를 구매한 상태
                   
  reg [2:0] present_state, next_state;
  
  //다음 상태 결정
  always @(present_state or coin or buy) begin
    case(present_state)
      //현재 상태가 S0일 때
      S0: if(coin && !buy) next_state=S1;//coin이 들어오고 사지 않으면 S1
          else next_state=S0;//그 외의 상황은 모두 S0 유지
      //현재 상태가 S1일 때
      S1: if(!coin && !buy) next_state=S1;//coin도 들어오지 않고 사지 않으면 S1 유지
          else if(coin && !buy) next_state=S2;//coin이 들어오고 사지 않으면 S2
          else next_state=S0;//그 외의 상황은 모두 S0
      //현재 상태가 S2일 때
      S2: if(!coin && !buy) next_state=S2;//coin도 들어오지 않고 사지 않으면 S2 유지
          else if(!coin && buy) next_state=S0;//coin이 들어오지 않았는데 구매하면 S0
          else if(coin && !buy) next_state=S3;//coin이 들어오고 사지 않으면 S3
          else next_state=S4;//coin이 들어오고 사면 S4
      //현재 상태가 S3일 때
      S3: if(!coin && !buy) next_state=S3;//coin도 들어오지 않고 사지 않으면 S3 유지
          else if(!coin && buy) next_state=S4;//coin이 들어오지 않고 구매하면 S4
          else next_state=S0;//그 외의 상황은 모두 S0
      //현재 상태가 S4일 때
      S4: if(coin && !buy) next_state=S1;//coin이 들어오고 사지 않으면 S1
          else next_state=S0;//그 외의 상황은 모두 S0
      default:  next_state=S0;//기본 값은 S0
    endcase
  end
  
  //현재 상태 결정
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) present_state <= S0;//rst_n이 0이면 현재 상태 S0으로 초기화
    else       present_state <= next_state;//rst_n이 1이면 현재 상태는 다음 상태.
  end
  
  //출력 계산
  assign coffee = (present_state == S4);//coffee는 현재 상태가 S4일 때만 1, 그 외의 경우에는 0
  assign return = (present_state == S0);//return은 현재 상태가 S0일 때만 1, 그 외의 경우에는 0
endmodule