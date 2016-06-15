`timescale 1ns / 1ps

module transmitter (
    input clk,
    input reset,
    input transmit,
    input [7:0] data,
    output reg Tx
);

reg [3:0] bitcounter;
reg [12:0] counter;
reg state, nextstate;
reg [10:0] rightshiftreg;
reg shift, load, clear;

always @ (posedge(clk))
begin
    if (reset)
    begin
        state <= 0;
        counter <= 0;
        bitcounter <= 0;
    end
    else
    begin
        counter <= counter + 1;
        if (counter >= 5207) //baud of 9600 at 50MHz clk
        begin
            state <= nextstate;
            counter <= 0;
            if (load) rightshiftreg <= {1'b1, ^data, data, 1'b0};
            if (clear) bitcounter <= 0;
            if (shift)
            begin
                rightshiftreg <= rightshiftreg >> 1;
                bitcounter <= bitcounter + 1;
            end
        end
    end
end

always @ (state or bitcounter or transmit)
begin
    load <= 0;
    shift <= 0;
    clear <= 0;
    Tx <= 1;
    
    case (state)
        0:
        begin
            if (transmit == 1)
            begin
                nextstate <= 1;
                load <= 1;
                shift <= 0;
                clear <= 0;
            end
            else
            begin
                nextstate <= 0;
                Tx <= 1;
            end
        end
        1:
        begin
            if (bitcounter >= 10)
            begin
                nextstate <= 0;
                clear <= 1;
            end
            else
            begin
                nextstate <= 1;
                shift <= 1;
                Tx <= rightshiftreg[0];
            end
        end
    endcase
end

endmodule