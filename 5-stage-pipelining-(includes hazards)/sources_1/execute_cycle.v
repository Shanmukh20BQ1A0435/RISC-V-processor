`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/14/2026 06:05:00 PM
// Design Name: 
// Module Name: execute_cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Executes arithmetic and logic operations using the ALU, 
//              computes branch target addresses, and handles source operand 
//              forwarding for hazard mitigation.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module execute_cycle(clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, ALUControlE, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, PCSrcE, PCTargetE, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM, ALU_ResultM, ResultW, ForwardA_E, ForwardB_E);

    input clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    input [2:0] ALUControlE;
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardA_E, ForwardB_E;

    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    output [4:0] RD_M; 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output [31:0] PCTargetE;

    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE;

    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    // 3-to-1 Multiplexer for Operand A Forwarding
    mux_3to1 srca_mux (
        .in0(RD1_E),
        .in1(ResultW),
        .in2(ALU_ResultM),
        .sel(ForwardA_E),
        .out(Src_A)
    );

    // 3-to-1 Multiplexer for Operand B Forwarding
    mux_3to1 srcb_mux (
        .in0(RD2_E),
        .in1(ResultW),
        .in2(ALU_ResultM),
        .sel(ForwardB_E),
        .out(Src_B_interim)
    );

    // 2-to-1 Multiplexer to select between Register Operand or Immediate
    mux alu_src_mux (
        .sel(ALUSrcE),
        .in0(Src_B_interim),
        .in1(Imm_Ext_E),
        .out(Src_B)
    );

    // Execution Arithmetic Logic Unit (ALU)
    alu alu_unit (
        .in_a(Src_A),
        .in_b(Src_B),
        .alu_control(ALUControlE),
        .alu_result(ResultE),
        .zero(ZeroE)
    );

    // PC Target Adder for Branching
    pc_adder branch_target_adder (
        .a(PCE),
        .b(Imm_Ext_E),
        .y(PCTargetE)
    );

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteE_r  <= 1'b0; 
            MemWriteE_r  <= 1'b0; 
            ResultSrcE_r <= 1'b0;
            RD_E_r       <= 5'h00;
            PCPlus4E_r   <= 32'h00000000; 
            RD2_E_r      <= 32'h00000000; 
            ResultE_r    <= 32'h00000000;
        end
        else begin
            RegWriteE_r  <= RegWriteE; 
            MemWriteE_r  <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r       <= RD_E;
            PCPlus4E_r   <= PCPlus4E; 
            RD2_E_r      <= Src_B_interim; 
            ResultE_r    <= ResultE;
        end
    end

    assign PCSrcE      = ZeroE & BranchE;
    assign RegWriteM   = RegWriteE_r;
    assign MemWriteM   = MemWriteE_r;
    assign ResultSrcM  = ResultSrcE_r;
    assign RD_M        = RD_E_r;
    assign PCPlus4M    = PCPlus4E_r;
    assign WriteDataM  = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule
