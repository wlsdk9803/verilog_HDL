module Lemmings2(clk, rst_n, bump_left, bump_right, ground, walk_left, walk_right, aaah);
  input clk;
  input rst_n;
  input bump_left;
  input bump_right;
  input ground;
  output walk_left;
  output walk_right;
  output aaah;
  
  localparam WALK_LEFT = 2'b00,
            WALK_RIGHT = 2'b01,
             FALL_LEFT = 2'b10,
            FALL_RIGHT = 2'b11;
            
  reg [1:0] present_state, next_state;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) present_state <= WALK_LEFT;
    else       present_state <= next_state;
  end
  
  always @(*) begin
    case(present_state)
      WALK_LEFT:
          if(ground == 0) next_state = FALL_LEFT;
          else            next_state = (bump_left) ? WALK_RIGHT : WALK_LEFT;
      WALK_RIGHT:
          if(ground == 0) next_state = FALL_RIGHT;
          else            next_state = (bump_right) ? WALK_LEFT : WALK_RIGHT;
      FALL_LEFT:
          if(ground == 1) next_state = WALK_LEFT;
          else            next_state = FALL_LEFT;
      FALL_RIGHT:
          if(ground == 1) next_state = WALK_RIGHT;
          else            next_state = FALL_RIGHT;
      default:
          next_state = WALK_LEFT;
    endcase
  end
  
  assign walk_left = (present_state == WALK_LEFT);
  assign walk_right = (present_state == WALK_RIGHT);
  assign aaah = (present_state == FALL_LEFT) || (present_state == FALL_RIGHT);
endmodule
