`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2016 03:03:54 PM
// Design Name: 
// Module Name: direction_decoder
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


module direction_decoder(
    input [1:0] x_direction,
    input [1:0] y_direction,
    output reg [1:0] direction
    );
    
    always @ (x_direction, y_direction)
    begin
    if (x_direction == 2'b01)
        direction <= 2'b10;
    else if (x_direction == 2'b10)
        direction <= 2'b01;
    if (y_direction == 2'b01)
        direction <= 2'b00;
    else if (y_direction == 2'b10)
        direction <= 2'b11;
    end
    
endmodule
