`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA
// 
// Create Date: 07/08/2026 07:25:02 PM
// Design Name: 
// Module Name: reg_file
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


// RISC-V 32-bit Register File Module
//
// This module manages the 32 general-purpose registers for the single-cycle CPU core.
// On a system reset, all registers are automatically cleared back to zero.
// Data is saved into the destination register (rd) on the rising clock edge, but a
// safety check prevents register x0 from being changed so it always stays zero.
// Reading from the source registers (rs1 and rs2) happens instantly, and any attempt
// to read from register x0 is hardwired to automatically output a solid zero.

module reg_file (
    input clk, rst, reg_write,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data_1, read_data_2
);

    reg [31:0] registers[31:0];
    integer k;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (k = 0; k < 32; k = k + 1) begin
                registers[k] <= 32'b0;
            end
        end else if (reg_write && (rd != 5'b0)) begin
            registers[rd] <= write_data;
        end
    end

    assign read_data_1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign read_data_2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

endmodule