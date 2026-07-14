`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/14/2026 06:10:00 PM
// Design Name: 
// Module Name: memory_cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Manages data memory access operations for load and store instructions 
//              and pipes execution attributes to the Write-Back stage.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module memory_cycle(clk, rst, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM, ALU_ResultM, RegWriteW, ResultSrcW, RD_W, PCPlus4W, ALU_ResultW, ReadDataW);
    
    input clk, rst, RegWriteM, MemWriteM, ResultSrcM;
    input [4:0] RD_M; 
    input [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

    output RegWriteW, ResultSrcW; 
    output [4:0] RD_W;
    output [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

    wire [31:0] ReadDataM;

    reg RegWriteM_r, ResultSrcM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r, ALU_ResultM_r, ReadDataM_r;

    // Central Data Memory Unit
    data_mem dmem_unit (
        .clk(clk),
        .rst(rst),
        .we(MemWriteM),
        .wd(WriteDataM),
        .a(ALU_ResultM),
        .rd(ReadDataM)
    );

    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            RegWriteM_r   <= 1'b0; 
            ResultSrcM_r  <= 1'b0;
            RD_M_r        <= 5'h00;
            PCPlus4M_r    <= 32'h00000000; 
            ALU_ResultM_r <= 32'h00000000; 
            ReadDataM_r   <= 32'h00000000;
        end
        else begin
            RegWriteM_r   <= RegWriteM; 
            ResultSrcM_r  <= ResultSrcM;
            RD_M_r        <= RD_M;
            PCPlus4M_r    <= PCPlus4M; 
            ALU_ResultM_r <= ALU_ResultM; 
            ReadDataM_r   <= ReadDataM;
        end
    end 

    assign RegWriteW   = RegWriteM_r;
    assign ResultSrcW  = ResultSrcM_r;
    assign RD_W        = RD_M_r;
    assign PCPlus4W    = PCPlus4M_r;
    assign ALU_ResultW = ALU_ResultM_r;
    assign ReadDataW   = ReadDataM_r;

endmodule
