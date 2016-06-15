`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2016 10:50:52 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,
    input signal,
    output reg db_signal
    );
    
    initial db_signal=1;
    integer db_count=0;
    
    always @(posedge(clk))
        begin
            if (signal!=db_signal)
            begin    
                if (db_count>=200000)
                    db_signal=signal;
                else
                begin
                    db_count= db_count + 1;
                end
            end
            else
            begin
                db_signal=db_signal;
                db_count=0;
            end
        end
    
endmodule
