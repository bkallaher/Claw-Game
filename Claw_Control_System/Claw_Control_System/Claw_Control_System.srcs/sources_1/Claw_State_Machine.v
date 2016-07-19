`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2016 02:37:40 PM
// Design Name: 
// Module Name: Claw_State_Machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Claw_State_Machine(
    input clk,
    input rst, 
    input start_drop_claw_btn, 
    input [2:0] direction, 
    //input times_up, 
    input down_limit, 
    input up_limit, 
    input left_limit, 
    input forward_limit, 
    input right_limit, 
    input back_limit,
    output reg right_motor_en,
    output reg left_motor_en,
    output reg forward_motor_en,
    output reg back_motor_en,
    output reg up_motor_en,
    output reg down_motor_en,
    output reg claw,
    output [4:0] state_out
    //,
    ///output start_timer

    );
    
    localparam wait_state = 5'b0000;
    localparam start_state = 5'b0001;
    localparam right_state = 5'b0010;
    localparam left_state = 5'b0011;
    localparam forward_state = 5'b0100;
    localparam back_state = 5'b0101;
    localparam open_claw_one = 5'b0110;
    localparam move_down = 5'b0111;
    localparam close_claw_one = 5'b1000;
    localparam move_up = 5'b1001;
    localparam move_left = 5'b1010;
    localparam move_forward = 5'b1011;
    localparam open_claw_two = 5'b1100;
    localparam db_state = 5'b10000;
    
    localparam timer_seconds = 4;
    
    integer timer=0;

    reg [4:0] present_state, next_state;
    assign state_out = present_state;
    reg timer_en=0;
    reg times_up=0;
    initial present_state = wait_state;
    initial next_state = wait_state;
    
    wire start_drop_claw_btn_db;
    wire back_limit_db;
    wire forward_limit_db;
    wire left_limit_db;
    wire right_limit_db;
    wire up_limit_db;
    wire down_limit_db;
    
    debounce drop_claw_db(
    .clk(clk),
    .signal(start_drop_claw_btn),
    .db_signal(start_drop_claw_btn_db)
    );
    debounce back_db(
    .clk(clk),
    .signal(back_limit),
    .db_signal(back_limit_db)
    );
    debounce fwd_db(
    .clk(clk),
    .signal(forward_limit),
    .db_signal(forward_limit_db)
    );
    debounce left_db(
    .clk(clk),
    .signal(left_limit),
    .db_signal(left_limit_db)
    );
    debounce right_db(
    .clk(clk),
    .signal(right_limit),
    .db_signal(right_limit_db)
    );
    debounce up_db(
    .clk(clk),
    .signal(up_limit),
    .db_signal(up_limit_db)
    );
    debounce down_db(
    .clk(clk),
    .signal(down_limit),
    .db_signal(down_limit_db)
    );
    
    always @ (posedge(clk))
    begin
        if (timer_en==1)
        begin
            if(timer>=timer_seconds*100000000)
                times_up=1;
            else
            begin
                timer = timer+1;
                times_up=0;
            end
        end 
        else
        begin
            timer = 0;
            times_up=0;
        end
           
    end
    
    always @ (posedge(clk)
    /*present_state, 
                rst, 
                start_drop_claw_btn, 
                direction, 
                //times_up, 
                
                down_limit, 
                up_limit, 
                left_limit, 
                forward_limit, 
                right_limit, 
                back_limit*/)
                
            begin
            case(present_state)
                wait_state:
                    begin
                    if (start_drop_claw_btn_db == 1'b0 && rst == 1'b0)
                        begin
                            
//                            timer_en=1;
                            next_state = db_state;
                        end
                    else
                        begin
//                            timer_en=0;
                            next_state = wait_state;
                        end
                    end
                db_state:
                    begin
                        if (start_drop_claw_btn_db == 1'b1)
                        begin
                          next_state = start_state;
                        end
                    end
                start_state:
                    begin
//                    if (times_up==1)
//                        next_state = open_claw_one;
                    /*else*/ if (direction == 3'b001 && right_limit_db)
                        next_state = right_state;
                    else if (direction == 3'b010 && left_limit_db)
                        next_state = left_state;
                    else if (direction == 3'b000 && forward_limit_db)
                        next_state = forward_state;
                    else if (direction == 3'b011 && back_limit_db)
                        next_state = back_state;
                    else if (start_drop_claw_btn_db == 1'b0 /*|| times_up == 1'b1*/)
                        next_state = open_claw_one;
                    //else if (down_limit || ~up_limit || left_limit || forward_limit || right_limit || back_limit)
                       // next_state = start_state;
                    else 
                        next_state = start_state;
                    end
                right_state:
                    begin
//                        if (times_up==1)
//                            next_state = open_claw_one;
                        /*else */if (direction != 3'b001 || ~right_limit_db)
                            next_state = start_state;
                    end
                left_state:
                    begin
//                        if (times_up==1)
//                            next_state = open_claw_one;
                         if (direction != 3'b010 || ~left_limit_db)
                            next_state = start_state;
                    end
                forward_state:
                    begin
//                        if (times_up==1)
//                             next_state = open_claw_one;
                        if (direction != 3'b000 || ~forward_limit_db)
                             next_state = start_state;
                    end
                back_state:
                    begin
//                        if (times_up==1)
//                            next_state = open_claw_one;
                      if (direction != 3'b011 || ~back_limit_db)
                            next_state = start_state;
                    end
                open_claw_one:
                    begin
                        timer_en=1;
                        next_state = move_down;
                    end
                move_down:
                    begin
                        if (down_limit_db == 1'b1 || times_up == 1)
                        begin
                            timer_en = 0;
                            next_state = close_claw_one;
                        end        
                    end
                close_claw_one:
                    next_state = move_up;
                move_up:
                    begin
                    if (up_limit_db == 1'b0)
                        next_state = move_left;
                    else
                        next_state = move_up;
                    end
                move_left:
                    begin
                    if (left_limit_db ==1'b0)
                        next_state = move_forward;
                    else
                        next_state = move_left;
                    end
                move_forward:
                    begin
                    if (forward_limit_db == 1'b0)
                        next_state = open_claw_two;
                    else
                        next_state = move_forward;
                    end
                open_claw_two:
                    next_state = wait_state;


            endcase
            
            end
            
        always @ (posedge clk)
                begin
                    if (present_state == wait_state)
                        begin 
                        right_motor_en = 1'b0;
                        left_motor_en = 1'b0;
                        forward_motor_en = 1'b0;
                        back_motor_en = 1'b0;
                        up_motor_en = 1'b0;
                        down_motor_en = 1'b0;
                        end
                    else if (present_state == start_state)
                        begin 
                        right_motor_en = 1'b0;
                        left_motor_en = 1'b0;
                        forward_motor_en = 1'b0;
                        back_motor_en = 1'b0;
                        up_motor_en = 1'b0;
                        down_motor_en = 1'b0;
                        //start_timer = 1'b1;
                        end
                    else if (present_state == right_state)
                        begin
                        right_motor_en = 1'b1;
                        end
                    else if (present_state == left_state)
                        begin
                        left_motor_en = 1'b1;
                        end
                    else if (present_state == forward_state)
                        begin
                        forward_motor_en = 1'b1;
                        end
                    else if (present_state == back_state)
                        begin
                        back_motor_en = 1'b1;
                        end
                    else if (present_state == open_claw_one)
                        begin
                        claw = 1'b1;
                        end
                    else if (present_state == move_down)
                        begin
                        down_motor_en = 1'b1;
                        end
                    else if (present_state == close_claw_one)
                        begin
                        claw = 1'b0;
                        down_motor_en = 1'b0;
                        end
                    else if (present_state == move_up)
                        begin
                        up_motor_en = 1'b1;
                        end
                    else if (present_state == move_left)
                        begin
                        up_motor_en = 1'b0;
                        left_motor_en = 1'b1;
                        end
                    else if (present_state == move_forward)
                        begin
                        forward_motor_en = 1'b1;
                        left_motor_en = 1'b0;
                        end                                 
                     else if (present_state == open_claw_two)
                         begin
                         forward_motor_en = 1'b1;
                         claw = 1'b1;
                         end                                      
                  
                   
                    else
                        begin 
                        right_motor_en = 1'b0;
                        left_motor_en = 1'b0;
                        forward_motor_en = 1'b0;
                        back_motor_en = 1'b0;
                        up_motor_en = 1'b0;
                        down_motor_en = 1'b0;
                        claw = 1'b1;
                        end
                end
    
         always @ (posedge clk)
            begin
                if (rst == 1'b1)
                    present_state = wait_state;
                else 
                    present_state = next_state;
            end
endmodule
