`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 01:20:53 PM
// Design Name: 
// Module Name: data_mem
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


// RISC-V 32-bit Data Memory Module
//
// This module acts as the RAM (Data Memory) for the single-cycle processor.
// It stores data using a 64-word array, where each word is 32 bits wide.
// On reset, all memory locations are cleared to zero. Writes occur on the 
// rising clock edge if MemWrite is active. Reads happen asynchronously 
// when MemRead is high, using bits of the address to align to 4-byte words.

module data_mem (
    input clk, rst, MemRead, MemWrite,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] D_mem[63:0];
    integer k;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (k = 0; k < 64; k = k + 1) begin
                D_mem[k] <= 32'b0;
            end
        end else if (MemWrite) begin
            D_mem[address] <= write_data;
        end
    end

    assign read_data = (MemRead) ? D_mem[address] : 32'b0;

endmodule
