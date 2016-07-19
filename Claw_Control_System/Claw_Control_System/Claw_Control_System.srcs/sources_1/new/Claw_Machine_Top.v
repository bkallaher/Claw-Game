`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2016 03:41:39 PM
// Design Name: 
// Module Name: Claw_Machine_Top
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


module Claw_Machine_Top(
    input clk,
    input rst,
    input jstk_miso_2,
    input down_limit,
    input up_limit,
    input left_limit,
    input right_limit,
    input forward_limit,
    input back_limit,
    input arcade_btn,
    output down_limit_out,
    output up_limit_out,
    output right_limit_out,
    output left_limit_out,
    output forward_limit_out,
    output back_limit_out,
    output arcade_btn_out,
    output [3:0] step_up_down,
    output [3:0] step_right_left,
    output [3:0] step_forward_back,
    output PWM,
    output jstk_sclk_3,
    output jstk_ss_0,
    output [4:0]state,
    output [15:13] direction_leds,
    output tx,
    output uart_status,
    output [4:0] last_state_status
    );
    
    wire [2:0] direction_net; //x_direction_net, y_direction_net, direction_net;
    wire right_motor_en_net, left_motor_en_net, up_motor_en_net, down_motor_en_net, forward_motor_en_net, back_motor_en_net;
    wire claw_net;
    
        
    //UART registers and wires
    wire tx_clk;
    wire [4:0] last_state;
    wire uart_transmit;
    wire uart_busy;
    assign uart_status = uart_busy;
    assign last_state_status = last_state;
    assign direction_leds=direction_net;
    
    assign uart_transmit = (state != last_state && tx_clk == 1'b1 ? 1 : 0);
    assign last_state = (uart_busy == 1'b0 && tx_clk == 1'b1 ? state : last_state);
    
    jstk_controller joystick(
        .clk(clk),
        .rst(rst),
        .jstk_input_ss_0(jstk_ss_0),
        .jstk_input_miso_2(jstk_miso_2),
        .jstk_input_sclk_3(jstk_sclk_3),
        .direction(direction_net)
        //.x_direction(x_direction_net),
        //.y_direction(y_direction_net)
        );
        
     clk_wiz_0 txClk (
         .clk_in1(clk),
         .clk_out1(tx_clk),
         .reset(rst)
     );
     
     transmitter t (
        .clk(tx_clk),
        .reset(rst),
        .transmit(~uart_transmit),
        .data({3'b0, last_state}),
        .Tx(tx)
     );
     
   /* direction_decoder change_direction(
        .x_direction(x_direction_net),
        .y_direction(y_direction_net),
        .direction(direction_net)
        );*/
        
    Claw_State_Machine brain(
            .clk(clk),
            .rst(rst), 
            .start_drop_claw_btn(arcade_btn), 
            .direction(direction_net), 
            //input times_up, 
            .down_limit(down_limit), 
            .up_limit(up_limit), 
            .left_limit(left_limit), 
            .forward_limit(forward_limit), 
            .right_limit(right_limit), 
            .back_limit(back_limit),
            .right_motor_en(right_motor_en_net),
            .left_motor_en(left_motor_en_net),
            .forward_motor_en(forward_motor_en_net),
            .back_motor_en(back_motor_en_net),
            .up_motor_en(up_motor_en_net),
            .down_motor_en(down_motor_en_net),
            .claw(claw_net),
            .state_out(state)
            //,
            ///output start_timer
        
            );
            
        claw_control servo_control(
            .claw_open(~claw_net),
            .clk(clk),
            .clr(rst),
            .PWM(PWM)
            );
                
        pmod_step_interface up_down(
            .clk(clk),
            .rst(rst),
            .direction({up_motor_en_net,down_motor_en_net}),
            .en(up_motor_en_net||down_motor_en_net),
            .signal_out(step_up_down)
            );
            
        pmod_step_interface right_left(
            .clk(clk),
            .rst(rst),
            .direction({right_motor_en_net,left_motor_en_net}),
            .en(right_motor_en_net||left_motor_en_net),
            .signal_out(step_right_left)
            );
                                        
        pmod_step_interface forward_back(
            .clk(clk),
            .rst(rst),
            .direction({forward_motor_en_net,back_motor_en_net}),
            .en(back_motor_en_net||forward_motor_en_net),
            .signal_out(step_forward_back)
            );
            
            assign down_limit_out=1'b0;
            assign up_limit_out=1'b0;
            assign right_limit_out=1'b0;
            assign left_limit_out=1'b0;
            assign forward_limit_out=1'b0;
            assign back_limit_out=1'b0;
            assign arcade_btn_out=1'b0;

endmodule
