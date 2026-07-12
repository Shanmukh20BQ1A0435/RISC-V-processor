`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 01:24:27 PM
// Design Name: 
// Module Name: PC_inc
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


// RISC-V Program Counter Incrementer Module
//
// This module calculates the next sequential instruction address for the CPU.
// Since each RISC-V instruction is 32 bits (which takes up 4 bytes of memory),
// the hardware continuously adds a constant value of 4 to the current Program 
// Counter (PC) value to point to the very next instruction in line.

module PC_inc (
    input [31:0] fromPC,
    output [31:0] toPC
);

    assign toPC = fromPC + 4;

endmodule
