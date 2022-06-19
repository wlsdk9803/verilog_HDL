module Muxed_Galois_LFSR(clk, arst_n, r, L, LFSR);
  input clk;
  input arst_n;
  input [2:0] r;
  input L;
  output reg [2:0] LFSR;
  
  always @(posedge clk or negedge arst_n) begin
    if(!arst_n) LFSR <= 1;//LFSR �ʱ�ȭ
    else begin
      if(L) begin
        LFSR <= r;//L�� 1�̸� LFSR�� r
      end//if(L)
      else begin//if(!L)
        //L�� 0�̸� //2��, 3�� tap xor�ؼ� msb�� ����, shift left. lsb�� ������ msb ��
        LFSR <= {LFSR[2] ^ LFSR[1], LFSR[0], LFSR[2]};
      end
    end//else //if(arst_n)
  end//always
endmodule