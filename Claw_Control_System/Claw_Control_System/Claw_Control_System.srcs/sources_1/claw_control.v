`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2016 01:27:05 PM
// Design Name: 
// Module Name: claw_control
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


module claw_control(
    input claw_open,
    input clk,
    input clr,
    output PWM
    );
    
        wire [19:0] A_net;
        wire [19:0] value_net;
        wire [8:0] angle_net;
        
        open_close_to_angle a(
            .value(claw_open),
            .angle(angle_net)
            );
      
        
        // Convert the angle value to 
        // the constant value needed for the PWM.
        angle_decoder decode(
            .angle(angle_net),
            .value(value_net)
            );
        
        // Compare the count value from the
        // counter, with the constant value set by
        // the switches.
        comparator compare(
            .A(A_net),
            .B(value_net),
            .PWM(PWM)
            );
          
        // Counts up to a certain value and then resets.
        // This module creates the refresh rate of 20ms.   
        counter count(
            .clr(clr),
            .clk(clk),
            .count(A_net)
            );
            
    
endmodule
