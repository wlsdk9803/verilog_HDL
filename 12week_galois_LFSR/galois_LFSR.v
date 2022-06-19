module galois_LFSR(
clk, arst_n, LFSR
    );
    parameter BITWIDTH=5;
    input clk;
    input arst_n;
    output reg [BITWIDTH-1:0] LFSR;
    
    always @(posedge clk or negedge arst_n) begin
        if(!arst_n) LFSR <= 1;
        else        LFSR <= {LFSR[0], LFSR[4]^LFSR[0], LFSR[3], LFSR[2] ^ LFSR[0], LFSR[1]};
    end
endmodule
