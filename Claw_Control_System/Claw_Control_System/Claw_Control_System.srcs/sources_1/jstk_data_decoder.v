`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Kaitlyn Franz
// 
// Create Date: 01/26/2016 11:04:33 AM
// Design Name: PmodJSTKservocontrol
// Module Name: jstk_data_decoder
// Project Name: Claw
// Target Devices: Basys 3
// Tool Versions: 2015.4
// Description: This module decodes data from the PmodJSTK and 
// outputs direction signals for both x and y. 10 and 01 are 
// directions while 00 is hold. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jstk_data_decoder(
    input [9:0] x_data,
    input [9:0] y_data,
    output reg [1:0] x_direction,
    output reg [1:0] y_direction
    );
    

    
    // Run whenever the x or y data change
    always @ (x_data, y_data)
    begin
        begin
        // if the data is between 0 and 300(left) set direction to 01
        if ( x_data <= 10'd300 && x_data >= 10'd0 )
            x_direction = 2'b01;
        // if the data is between 700 and 1023 (right) set direction to 10
        else if (x_data <=10'd1023 && x_data >= 10'd700)
            x_direction = 2'b10;
        // otherwise the joystick is in the middle and the servo 
        // should hold
        else 
            x_direction = 2'b00;
           
        end
        begin
        // if the data is between 0 and 300(down) set direction to 01
        if (y_data <=10'd300 && y_data >= 20'd0)
            y_direction = 2'b01;
        // if the data is between 700 and 1023(up) set direction to 01
        else if (y_data <=10'd1023 && y_data >= 10'd700)
            y_direction = 2'b10;
        // otherwise the joystick is in the middle and the servo 
        // should hold
        else 
            y_direction = 2'b00;
        end    
    end
endmodule
