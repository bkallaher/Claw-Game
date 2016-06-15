`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Kaitlyn Franz
// 
// Create Date: 01/26/2016 10:10:29 AM
// Design Name: PmodJSTKservocontrol
// Module Name: jstksteptop
// Project Name: claw
// Target Devices: Basys 3
// Tool Versions: 2015.4
// Description: This project takes input from the pmodJSTK and moves
// two servos accordingly. It also has two switches to enable each
// of the servos individually. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


    module jstk_controller(
    input clk,
    input rst,
    output jstk_input_ss_0,
    input jstk_input_miso_2,
    output jstk_input_sclk_3,
    output reg [2:0] direction
    //output [1:0] x_direction,
    //output [1:0] y_direction
    );
    wire [1:0] x_direction;
    wire [1:0] y_direction;
    // wire to connect the joystick data bewtween the Joystick 
    // interface and the decoder
    wire [9:0] x_data_net, y_data_net;
    
    // Instatiation of a joystick controller
    // connects the SPI connections to Pmod 
    // connector JA. Outputs the joystick values
    // to the seven segment display. Outputs the joystick 
    // data.
    PmodJSTK_Demo joystick_input(
        .CLK(clk),
        .RST(rst),
        .MISO(jstk_input_miso_2),
        .SS(jstk_input_ss_0),
        .SCLK(jstk_input_sclk_3),
         .x_data(x_data_net),
         .y_data(y_data_net)
        );
        
    // Decoder that decodes the joystick data into 
    // the x and y direction signals.    
    jstk_data_decoder decode(
        .x_data(x_data_net),
        .y_data(y_data_net),
        .x_direction(x_direction),
        .y_direction(y_direction)
        );
        
    always@(posedge(clk))
    begin
        if (x_direction == 2'b01)
            direction <= 3'b010;
        else if (x_direction == 2'b10)
            direction <= 3'b001;
        else if (y_direction == 2'b01)
            direction <= 3'b000;
        else if (y_direction == 2'b10)
            direction <= 3'b011;
        else
            direction <= 3'b100;
    end
       
endmodule
