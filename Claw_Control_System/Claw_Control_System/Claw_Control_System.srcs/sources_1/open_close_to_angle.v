`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Kaitlyn Franz
// 
// Create Date: 02/01/2016 01:32:45 PM
// Design Name: Servo control with the CON3
// Module Name: sw_to_angle
// Project Name: The Claw
// Target Devices: Basys 3 with PmodCON3
// Tool Versions: 2015.4
// Description: 
//      This module takes the switch values as an input
//      and converts them to a degree value. 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Convert from switch value to angle
// Each switch provides a different angle in degrees, starting
// at 0, incrementing by 24 degrees each time. 
module open_close_to_angle(
    input value,
    output reg [8:0] angle
    );
    
    // Run when the value of the switches
    // changes
    always @ (value)
    begin
        case (value)
        // Close
        0:
        angle = 9'd110;
        // Open
        1:
        angle = 9'd130;      
        endcase                 
    end
endmodule
