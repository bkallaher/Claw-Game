//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Wed Jun 15 09:29:02 2016
//Host        : WK56 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (led_out,
    push_buttons_4bits_tri_i,
    reset,
    sys_clock);
  output led_out;
  input [3:0]push_buttons_4bits_tri_i;
  input reset;
  input sys_clock;

  wire led_out;
  wire [3:0]push_buttons_4bits_tri_i;
  wire reset;
  wire sys_clock;

  system system_i
       (.led_out(led_out),
        .push_buttons_4bits_tri_i(push_buttons_4bits_tri_i),
        .reset(reset),
        .sys_clock(sys_clock));
endmodule
