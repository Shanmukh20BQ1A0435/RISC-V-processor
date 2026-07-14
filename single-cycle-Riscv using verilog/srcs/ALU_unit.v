`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT
// Engineer:CH.SHANMUKH 
// 
// Create Date: 07/12/2026 01:16:50 PM
// Design Name: 
// Module Name: ALU_unit
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


// RISC-V 32-bit ALU Unit Module
//
// This module performs the core arithmetic and logical operations for the CPU.
// It takes two 32-bit inputs (A and B) and selects an operation based on the 4-bit 
// control signal. It handles bitwise AND, bitwise OR, addition, and subtraction.
// It also generates a zero flag during subtraction to help the control unit determine 
// if a conditional branch condition is met.

module ALU_unit (
    input [31:0] A, B,
    input [3:0] control_in,
    output reg zero,
    output reg [31:0] ALU_out
);

    always @(*) begin
        ALU_out = 32'b0;
        zero = 1'b0;

        case (control_in)
            4'b0000: ALU_out = A & B;
            4'b0001: ALU_out = A | B;
            4'b0010: ALU_out = A + B;
            4'b0110: begin
                ALU_out = A - B;
                zero = (A == B);
            end
            default: begin
                ALU_out = 32'b0;
                zero = 1'b0;
            end
        endcase
    end

endmodule
