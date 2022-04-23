module Nbit_PRPG(//���� ���� ����� Nbit_PRPG
seed,
reset, 
load, 
clk, 
count, 
num, 
sequence, 
valid);
  parameter n = 4;//parameter n�� default ��: 4bits
  input [n-1:0] seed;
  input reset, load, clk;
  output [n-1:0] count, num;
  output sequence, valid;
  
  reg nextbit;//state_out�� msb�� �־��־� shift�ϱ� ���� nextbit
  reg [n-1:0] state_out;
  wire [n-1:0] state_in;
  wire [n-1:0] count_time;
  
  counter_time #(.n(4)) nbit_counter_time(clk, reset, load, count_time);
  //counter_time(clk, reset, load, count_time)
  counter #(.n(4)) nbit_mycounter(sequence, clk, reset, load, count_time, count, num, valid);
  //counter(sign, clk, reset, load, count_time, count, num, valid)
  
  always @ (posedge clk or posedge reset) begin//clk�� 1�� �ǰų� reset�� 1�� �� ��
    if(reset) state_out <= 0;//reset�� 1�̸� state_out�� 0
    else state_out <= state_in;//reset�� 10�̸� state_out�� state_in ����
  end
  
  always @ (state_out) begin
    case(n)//parpameter n�� ���� ���� case �з�
      4: nextbit = state_out[0] ^ state_out[1];//n�� 4�� �� nextbit
      8: nextbit = state_out[0] ^ state_out[2] ^ state_out[3] ^ state_out[5];//n�� 8�� �� nextbit
      16: nextbit = state_out[0] ^ state_out[4] ^ state_out[9] ^ state_out[14];//n�� 16�� �� nextbit
      32: nextbit = state_out[0] ^ state_out[10] ^ state_out[30] ^ state_out[31];//n�� 32�� �� nextbit
      default: nextbit = 1'bx;//�⺻ ���� unknown���� ����
    endcase
  end
  
  assign state_in = load ? seed: {nextbit, state_out[n-1:1]};//load�� 1�̸� state_in�� seed, load�� 0�̸� state_in�� {nextbit, state_out[n-1:1]}
  assign sequence = state_out[0];//sequenc�� flipflop�� output�� state_out�� lsb
endmodule

  

module counter_time(clk, reset, load, count_time);//0���� (2^n - 1)���� �ݺ������� count�ϴ� ��� counter_time
  parameter n = 4;//parameter n�� default ��: 4bits
  input load, clk, reset;//1bit�� input load, clk, reset
  output reg [n-1:0] count_time;//nbit�� output count_time
  
  always@ (posedge clk or posedge reset) begin//clk�� 1�� �ǰų� reset�� 1�� �� ��
   if(reset) count_time <= 0;//reset�� 1�̸� count_time�� 0
   else begin//reset�� 0�̸�
     if(load) count_time <= 0;//load�� 1�� �� count_time�� 0
     else begin//load�� 0�� ��
       if(count_time == 2**n -1) count_time <= 0;//count_time�� (2^n - 1)�̸� count_time�� 0
       else count_time <= count_time + 1;//count_time�� (2^n - 1)�� �ƴϸ� count_time�� 1 ����
     end//else //if(!load)
   end//else //if(!reset)
  end//always
endmodule
  
  
 
module counter(sign, clk, reset, load, count_time, count, num, valid);//�� ���ϵ��� 1�� ������ ���� ���� ��� counter
  parameter n = 4;//parameter n�� default ��: 4bits
  input sign, clk, reset, load;
  input [n-1:0] count_time;
  output reg valid;
  output reg [n-1:0] count, num;
  
  always @(posedge clk or posedge reset) begin//clk�� 1�� �ǰų� reset�� 1�� �� ��
    if(reset) begin count <= 0; num <= 0; valid <= 1'b0; end//reset�� 1�̸� count, num, valid ��� 0
    else begin//reset�� 0�� ��
      if(load) begin count <= 0; num <= 0; valid <= 1'b0; end//load�� 1�̸� count, num, valid ��� 0
      else begin//load�� 0�̸�
        if(count_time < 2**n-1) begin//count_time�� (2^n - 1)���� ������
          num <= 0;//num�� 0
          count <= sign ? (count+1) : count;//count�� sign�� 1�̸� 1 ����, 0�̸� ����
          valid <= 1'b0;//valid�� 0
        end//if(count_time < 2**n-1)
        else begin//count_time�� (2^n - 1) �̻��̸�, �� (2^n - 1)�̸�
          num <= count;//num�� count �� ����
          count <= 0;//count�� 0���� �ʱ�ȭ
          valid <= 1'b1;//valid�� 1
        end//else //if(count_time >= 2**n-1)
      end//else //if(!load)
    end//else //if(!reset)
  end//always
endmodule

