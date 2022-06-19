module Nbit_PRPG(//가장 상위 모듈인 Nbit_PRPG
seed,
reset, 
load, 
clk, 
count, 
num, 
sequence, 
valid);
  parameter n = 4;//parameter n의 default 값: 4bits
  input [n-1:0] seed;
  input reset, load, clk;
  output [n-1:0] count, num;
  output sequence, valid;
  
  reg nextbit;//state_out의 msb로 넣어주어 shift하기 위한 nextbit
  reg [n-1:0] state_out;
  wire [n-1:0] state_in;
  wire [n-1:0] count_time;
  
  counter_time #(.n(4)) nbit_counter_time(clk, reset, load, count_time);
  //counter_time(clk, reset, load, count_time)
  counter #(.n(4)) nbit_mycounter(sequence, clk, reset, load, count_time, count, num, valid);
  //counter(sign, clk, reset, load, count_time, count, num, valid)
  
  always @ (posedge clk or posedge reset) begin//clk이 1이 되거나 reset이 1이 될 때
    if(reset) state_out <= 0;//reset이 1이면 state_out은 0
    else state_out <= state_in;//reset이 10이면 state_out에 state_in 대입
  end
  
  always @ (state_out) begin
    case(n)//parpameter n의 값에 따라 case 분류
      4: nextbit = state_out[0] ^ state_out[1];//n이 4일 때 nextbit
      8: nextbit = state_out[0] ^ state_out[2] ^ state_out[3] ^ state_out[5];//n이 8일 때 nextbit
      16: nextbit = state_out[0] ^ state_out[4] ^ state_out[9] ^ state_out[14];//n이 16일 때 nextbit
      32: nextbit = state_out[0] ^ state_out[10] ^ state_out[30] ^ state_out[31];//n이 32일 때 nextbit
      default: nextbit = 1'bx;//기본 값은 unknown으로 지정
    endcase
  end
  
  assign state_in = load ? seed: {nextbit, state_out[n-1:1]};//load가 1이면 state_in은 seed, load가 0이면 state_in은 {nextbit, state_out[n-1:1]}
  assign sequence = state_out[0];//sequenc는 flipflop의 output인 state_out의 lsb
endmodule

  

module counter_time(clk, reset, load, count_time);//0부터 (2^n - 1)까지 반복적으로 count하는 모듈 counter_time
  parameter n = 4;//parameter n의 default 값: 4bits
  input load, clk, reset;//1bit의 input load, clk, reset
  output reg [n-1:0] count_time;//nbit의 output count_time
  
  always@ (posedge clk or posedge reset) begin//clk이 1이 되거나 reset이 1이 될 때
   if(reset) count_time <= 0;//reset이 1이면 count_time은 0
   else begin//reset이 0이면
     if(load) count_time <= 0;//load가 1일 때 count_time은 0
     else begin//load가 0일 때
       if(count_time == 2**n -1) count_time <= 0;//count_time이 (2^n - 1)이면 count_time은 0
       else count_time <= count_time + 1;//count_time이 (2^n - 1)이 아니면 count_time은 1 증가
     end//else //if(!load)
   end//else //if(!reset)
  end//always
endmodule
  
  
 
module counter(sign, clk, reset, load, count_time, count, num, valid);//한 패턴동안 1의 개수를 세기 위한 모듈 counter
  parameter n = 4;//parameter n의 default 값: 4bits
  input sign, clk, reset, load;
  input [n-1:0] count_time;
  output reg valid;
  output reg [n-1:0] count, num;
  
  always @(posedge clk or posedge reset) begin//clk이 1이 되거나 reset이 1이 될 때
    if(reset) begin count <= 0; num <= 0; valid <= 1'b0; end//reset이 1이면 count, num, valid 모두 0
    else begin//reset이 0일 때
      if(load) begin count <= 0; num <= 0; valid <= 1'b0; end//load가 1이면 count, num, valid 모두 0
      else begin//load가 0이면
        if(count_time < 2**n-1) begin//count_time이 (2^n - 1)보다 작으면
          num <= 0;//num은 0
          count <= sign ? (count+1) : count;//count는 sign이 1이면 1 증가, 0이면 유지
          valid <= 1'b0;//valid는 0
        end//if(count_time < 2**n-1)
        else begin//count_time이 (2^n - 1) 이상이면, 즉 (2^n - 1)이면
          num <= count;//num에 count 값 대입
          count <= 0;//count는 0으로 초기화
          valid <= 1'b1;//valid는 1
        end//else //if(count_time >= 2**n-1)
      end//else //if(!load)
    end//else //if(!reset)
  end//always
endmodule

