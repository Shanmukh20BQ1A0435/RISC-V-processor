`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/14/2026 06:15:00 PM
// Design Name: 
// Module Name: riscv_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top-level module for the pipelined RISC-V processor. It 
//              interconnects the Fetch, Decode, Execute, and Memory stages, 
//              implements the Write-Back multiplexing logic, and contains 
//              the bypass/forwarding hazard unit.
// 
// Dependencies: fetch_cycle.v, decode_cycle.v, execute_cycle.v, memory_cycle.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module riscv_top(
    input clk,
    input rst
);

    // Fetch Stage Wires
    wire [31:0] InstrD, PCD, PCPlus4D;

    // Decode Stage Wires
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;

    // Execute Stage Wires
    wire PCSrcE;
    wire [31:0] PCTargetE;
    wire RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

    // Memory Stage Wires
    wire RegWriteW, ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

    // Write-Back Wires
    wire [31:0] ResultW;

    // Hazard Unit Wires
    reg [1:0] ForwardA_E, ForwardB_E;

    // =========================================================================
    // 1. FETCH STAGE
    // =========================================================================
    fetch_cycle fetch_stage (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // =========================================================================
    // 2. DECODE STAGE
    // =========================================================================
    decode_cycle decode_stage (
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .RDW(RD_W),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E)
    );

    // =========================================================================
    // 3. EXECUTE STAGE
    // =========================================================================
    execute_cycle execute_stage (
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .ResultW(ResultW),
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E)
    );

    // =========================================================================
    // 4. MEMORY STAGE
    // =========================================================================
    memory_cycle memory_stage (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RD_W),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW)
    );

    // =========================================================================
    // 5. WRITE-BACK STAGE (Mux Selection)
    // =========================================================================
    // ResultSrcW selects between ALU Result (0) and Read Data from Memory (1)
    assign ResultW = (ResultSrcW == 1'b1) ? ReadDataW : ALU_ResultW;

    // =========================================================================
    // 6. HAZARD FORWARDING UNIT LOGIC
    // =========================================================================
    always @(*) begin
        // Operand A Forwarding Mux Logic
        if (((RS1_E == RD_M) && RegWriteM) && (RS1_E != 5'b00000)) begin
            ForwardA_E = 2'b10; // Forward from Memory Stage (ALU_ResultM)
        end 
        else if (((RS1_E == RD_W) && RegWriteW) && (RS1_E != 5'b00000)) begin
            ForwardA_E = 2'b01; // Forward from Write-Back Stage (ResultW)
        end 
        else begin
            ForwardA_E = 2'b00; // No Forwarding (Use RD1_E from Register File)
        end

        // Operand B Forwarding Mux Logic
        if (((RS2_E == RD_M) && RegWriteM) && (RS2_E != 5'b00000)) begin
            ForwardB_E = 2'b10; // Forward from Memory Stage (ALU_ResultM)
        end 
        else if (((RS2_E == RD_W) && RegWriteW) && (RS2_E != 5'b00000)) begin
            ForwardB_E = 2'b01; // Forward from Write-Back Stage (ResultW)
        end 
        else begin
            ForwardB_E = 2'b00; // No Forwarding (Use RD2_E from Register File)
        end
    end

endmodule

// =========================================================================
// Complementary Fetch Stage Companion Module Template
// =========================================================================
module fetch_cycle(
    input clk, rst,
    input PCSrcE,
    input [31:0] PCTargetE,
    output [31:0] InstrD,
    output [31:0] PCD,
    output [31:0] PCPlus4D
);

    wire [31:0] PC_Next, PCF, PCPlus4F, InstrF;
    reg [31:0] InstrF_r, PCF_r, PCPlus4F_r;

    // Mux choosing next PC value based on Branch Decision
    assign PC_Next = PCSrcE ? PCTargetE : PCPlus4F;

    // Program Counter Register
    reg [31:0] PC_reg;
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0)
            PC_reg <= 32'h00000000;
        else
            PC_reg <= PC_Next;
    end
    assign PCF = PC_reg;

    // PC Incrementer
    assign PCPlus4F = PCF + 32'd4;

    // Instruction Memory Instance Stub
    // (Ensure your design's Instruction Memory module matches this port layout)
    inst_mem imem (
        .a(PCF),
        .rd(InstrF)
    );

    // Fetch-to-Decode (F/D) Pipeline Register
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            InstrF_r   <= 32'h00000000;
            PCF_r      <= 32'h00000000;
            PCPlus4F_r <= 32'h00000000;
        end 
        else begin
            InstrF_r   <= InstrF;
            PCF_r      <= PCF;
            PCPlus4F_r <= PCPlus4F;
        end
    end

    assign InstrD   = InstrF_r;
    assign PCD      = PCF_r;
    assign PCPlus4D = PCPlus4F_r;

endmodule
