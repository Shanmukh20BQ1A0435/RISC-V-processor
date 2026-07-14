`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA
// 
// Create Date: 07/12/2026 01:29:50 PM
// Design Name: 
// Module Name: mux
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


// RISC-V 2-to-1 Multiplexer Module
//
// This module acts as a simple hardware data selector or routing switch.
// It takes two 32-bit data streams (A and B) and uses a single selection signal (sel)
// to determine which path goes forward. When the selection signal is low (0), 
// it passes input A directly to the output, and when it is high (1), it routes input B.

module mux (
    input sel,
    input [31:0] A, B,
    output [31:0] mux_out
);

    assign mux_out = (sel == 1'b0) ? A : B;

endmodule