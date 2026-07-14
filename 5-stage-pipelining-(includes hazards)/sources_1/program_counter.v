`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA
// 
// Create Date: 07/08/2026 06:55:48 PM
// Design Name: 
// Module Name: program_counter
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
module program_counter (
    input clk,
    input rst,
    input [31:0] PC_in,
    output reg [31:0] PC_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            PC_out <= 32'h0;
        else
            PC_out <= PC_in;
    end

endmodule