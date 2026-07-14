`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/12/2026 01:08:48 PM
// Design Name: 
// Module Name: ImmGen
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


// RISC-V 32-bit Immediate Generator Module
//
// This module takes different types of instructions and extracts their immediate values.
// Because RISC-V scatters immediate bits across different positions depending on the 
// instruction format (I, S, B, U, J), this block rearranges them into the correct order.
// It also sign-extends the highest bit (bit 31) to expand the value into a full 32-bit number.

module ImmGen (
    input [6:0] opcode,
    input [31:0] instruction,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case (opcode)
            7'b0010011: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
            7'b0000011: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
            7'b1100111: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
            7'b0100011: ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            7'b0110111: ImmExt = {instruction[31:12], 12'b0};
            7'b0010111: ImmExt = {instruction[31:12], 12'b0};
            7'b1101111: ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default:    ImmExt = 32'b0;
        endcase
    end

endmodule
