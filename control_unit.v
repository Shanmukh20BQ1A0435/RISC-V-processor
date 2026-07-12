`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 01:12:22 PM
// Design Name: 
// Module Name: control_unit
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


// RISC-V 32-bit Control Unit Module
//
// This module acts as the central decoder for the single-cycle processor.
// It inspects the 7-bit opcode of the current instruction to determine what operation
// needs to be executed. It outputs a 12-bit combined control word that enables or 
// disables specific hardware paths, such as register writes, memory accesses, 
// multiplexer selections, and the operational mode for the ALU.

module control_unit (
    input [6:0] opcode,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, LUI_en, AUIPC_en, JAL_en, JALr_en,
    output reg [1:0] ALUOp
);

    always @(*) begin
        case (opcode)
            7'b0110011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b001000000010;
            7'b0010011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b101000000011;
            7'b0000011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b111100000000;
            7'b0100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b100010000000;
            7'b1100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b000001000001;
            
            7'b0110111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b001000100000;
            7'b0010111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b001000010000;
            
            7'b1101111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b101000000110;
            7'b1100111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b101000000001;
            
            default:    {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} = 12'b000000000000;
        endcase
    end

endmodule
