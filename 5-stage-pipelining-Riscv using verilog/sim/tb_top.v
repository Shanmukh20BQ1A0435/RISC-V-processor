`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/14/2026 06:25:00 PM
// Design Name: 
// Module Name: tb_riscv_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for the top-level structural RISC-V pipelined processor.
//              Generates system clock, handles global reset synchronization, 
//              and manages simulation waveform dumping.
// 
// Dependencies: riscv_top.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_riscv_top();

    reg clk;
    reg rst;

    riscv_top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        
        #20;
        rst = 1;
        
        #500;
        $finish;
    end

endmodule