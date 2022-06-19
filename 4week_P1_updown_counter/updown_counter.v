module updown_counter(clk, rst_n, data, load, enable, select, out);//updown counter module
  input clk, rst_n, load, enable, select;//1bit�� input clk, rst_n, load, enable, select
  input [3:0] data;//4bit�� input data
  output reg [3:0] out;//4bit�� output out. always �� �ȿ��� ���� �־��� ���̹Ƿ� reg�� ����
  
  always @(posedge clk or negedge rst_n) begin//clk�� ����ϰų� rst_n�� �ϰ��� ��
    if(!rst_n) out <= 4'b0000;//rst_n�� 0�̸� out�� 0000���� �ʱ�ȭ. non-blocking
    else begin//rst_n�� 1�� ��
      if(load) out <= data;//load�� 1�̸� out�� data �Է�
      else begin//load�� 0�̸�
        if(enable) out <= select? out+1 : out -1;//enable�� 1�� ��
                                                 //select�� 1�̸� out�� 1 ���ϰ�, 0�̸� 1�� ��
        else out <= out;//enable�� 0�̸� out�� �� ����
      end
    end
  end
endmodule
