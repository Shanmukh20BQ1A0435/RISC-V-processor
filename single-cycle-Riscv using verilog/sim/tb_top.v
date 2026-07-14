`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH
// 
// Create Date: 07/12/2026 06:44:25 PM
// Design Name: 
// Module Name: tb_top
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


module tb_top;

    reg clk;
    reg rst;

    top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #15;
        rst = 0;
        #200;
        $finish;
    end

    initial begin
        $monitor("Time = %0t | PC = 0x%h | Instruction = 0x%h | ALU Result = 0x%h", 
                 $time, uut.Pc_top, uut.instruction_top, uut.ALU_res_top);
    end

endmodule
