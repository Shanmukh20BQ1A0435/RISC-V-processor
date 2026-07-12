`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 01:15:14 PM
// Design Name: 
// Module Name: ALU_control
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


// RISC-V ALU Control Decoder Module
//
// This module generates the final 4-bit operation code for the execution unit (ALU).
// It combines the 2-bit ALUOp signal from the main control unit with the function 
// fields from the instruction (fun3 and a specific bit from fun7). By checking these 
// signals together, it determines whether the ALU should perform an addition, 
// subtraction, bitwise AND, or bitwise OR operation.

module ALU_control (
    input [1:0] ALUOp,
    input fun7,
    input [2:0] fun3,
    output reg [3:0] control_out
);

    always @(*) begin
        case ({ALUOp, fun7, fun3})
            6'b00_0_000: control_out = 4'b0010;
            6'b01_0_000: control_out = 4'b0110;
            6'b10_0_000: control_out = 4'b0010;
            6'b10_1_000: control_out = 4'b0110;
            6'b10_0_111: control_out = 4'b0000;
            6'b10_0_110: control_out = 4'b0001;
            default:     control_out = 4'b0000;
        endcase
    end

endmodule
