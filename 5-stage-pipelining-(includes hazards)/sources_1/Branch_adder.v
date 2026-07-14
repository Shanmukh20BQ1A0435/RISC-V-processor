`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/12/2026 01:26:59 PM
// Design Name: 
// Module Name: Branch_adder
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


// RISC-V Branch Target Address Adder Module
//
// This module calculates the physical target address for branch and jump instructions.
// It takes the base reference address (plus4_addr) and adds the sign-extended 
// immediate offset value (ImmAddr). The resulting address is sent to the program 
// counter multiplexer to determine the next instruction location if a jump or branch is taken.

module Branch_adder (
    input [31:0] plus4_addr, ImmAddr,
    output [31:0] mux_in_addr
);

    assign mux_in_addr = plus4_addr + ImmAddr;

endmodule
