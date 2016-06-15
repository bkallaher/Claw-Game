
module claw_test;

reg clk, rst, down_limit, up_limit, 
left_limit, right_limit, forward_limit, 
back_limit, arcade_btn;

reg [1:0] x_direction, y_direction;

wire down_limit_out, up_limit_out,
right_limit_out, left_limit_out, forward_limit_out,
back_limit_out, arcade_btn_out;

wire [3:0] step_up_down, step_right_left, 
step_forward_back;

wire PWM;

claw_test_top uut(
    .clk(clk),
    .rst(rst),
    .down_limit(down_limit),
    .up_limit(up_limit),
    .left_limit(left_limit),
    .right_limit(right_limit),
    .forward_limit(forward_limit),
    .back_limit(back_limit),
    .arcade_btn(arcade_btn),
    .x_direction(x_direction), 
    .y_direction(y_direction),
    .down_limit_out(down_limit_out),
    .up_limit_out(up_limit_out),
    .right_limit_out(right_limit_out),
    .left_limit_out(left_limit_out),
    .forward_limit_out(forward_limit_out),
    .back_limit_out(back_limit_out),
    .arcade_btn_out(arcade_btn_out),
    .step_up_down(step_up_down),
    .step_right_left(step_right_left),
    .step_forward_back(step_forward_back),
    .PWM(PWM)
    );
    
    initial begin
    clk = 0;
    rst = 0; 
    down_limit = 0; 
    up_limit = 0;
    left_limit = 0; 
    right_limit = 0; 
    forward_limit = 0; 
    back_limit = 0; 
    arcade_btn = 0;
    x_direction = 0; 
    y_direction = 0;
    #100 rst = 1;
    #5 rst = 0;
    #10000 x_direction = 2'b01;
    #10000 x_direction = 2'b00;
    #10000 arcade_btn = 1;
    #10000 arcade_btn = 0;
    #10000 x_direction = 2'b01;
    #10000 x_direction = 2'b00;
    #10000 x_direction = 2'b01;
    #10000 x_direction = 2'b00;
        
    end
    
    always
    #5 clk = ~clk;
    
endmodule 