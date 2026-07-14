`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA
// 
// Create Date: 07/08/2026 07:20:56 PM
// Design Name: 
// Module Name: instruction_mem
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
module instruction_mem (
    input clk,
    input rst,
    input [31:0] read_address,
    output [31:0] instruction_out
);

    reg [7:0] mem [0:255];

    assign instruction_out = mem[read_address >> 2];

 

endmodule

