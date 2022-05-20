module Lemmings1(clk, rst_n, bump_left, bump_right, walk_left, walk_right);
  input clk;
  input rst_n;
  input bump_left;
  input bump_right;
  output walk_left;
  output walk_right;
  
  localparam LEFT = 0,
            RIGHT = 1;
            
  reg present_state, next_state;
  
  always @(*) begin
    case(present_state)
      LEFT: next_state = (bump_left) ? RIGHT : LEFT;
      RIGHT: next_state = (bump_right) ? LEFT : RIGHT;
    endcase
  end
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) present_state <= LEFT;
    else       present_state <= next_state;
  end
  
  assign walk_left = (present_state == LEFT);
  assign walk_right = (present_state == RIGHT);
endmodule
