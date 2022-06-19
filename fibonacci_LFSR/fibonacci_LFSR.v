module fibonacci_LFSR(clk, arst_n, LFSR);
  parameter BITWIDTH = 5;
  
  input clk;
  input arst_n;
  output reg [BITWIDTH - 1 : 0] LFSR;
  
  always @(posedge clk or negedge arst_n) begin
    if(!arst_n) begin
      LFSR <= 1;
    end
    else begin
      LFSR <= {LFSR[0] ^ LFSR[4], LFSR[BITWIDTH - 1 : 1]};
    end
  end
endmodule
