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
/*Program Storage: It acts as the "memory" for your CPU, holding 256 instructions (1KB total) that the processor needs to execute.
Automatic Loading: It automatically pulls your machine code from a file named program.txtthe moment the simulation starts.
Address Conversion: It converts the CPU's memory address into a line number by dividing by 4 (using the >> 2shift), which helps it find the right instruction quickly.
Instant Access: It provides the instruction instantly to the processor without waiting for a clock cycle, making the "fetch" stage very fast.*/
module instruction_mem (
    input clk,
    input rst,
    input [31:0] read_address,
    output [31:0] instruction_out
);

    reg [31:0] mem [0:255];
    initial begin
        $readmemh("program.txt", mem);
    end

    assign instruction_out = mem[read_address >> 2];

 

endmodule

