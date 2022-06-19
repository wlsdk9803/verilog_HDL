module Muxed_Galois_LFSR(clk, arst_n, r, L, LFSR);
  input clk;
  input arst_n;
  input [2:0] r;
  input L;
  output reg [2:0] LFSR;
  
  always @(posedge clk or negedge arst_n) begin
    if(!arst_n) LFSR <= 1;//LFSR 초기화
    else begin
      if(L) begin
        LFSR <= r;//L이 1이면 LFSR은 r
      end//if(L)
      else begin//if(!L)
        //L이 0이면 //2번, 3번 tap xor해서 msb에 넣음, shift left. lsb는 기존의 msb 값
        LFSR <= {LFSR[2] ^ LFSR[1], LFSR[0], LFSR[2]};
      end
    end//else //if(arst_n)
  end//always
endmodule