// Company: NIT SURAT 
// Engineer: CH. Shanmukha Varma 
// 
// Module Name: riscv_top
// Description: Top-level structural module for the pipelined RISC-V processor. 
//              Interconnects Fetch, Decode, Execute, and Memory stages, along 
//              with the Hazard Unit for data forwarding and the Write-Back multiplexer.

module riscv_top(
    input clk,
    input rst
);

    // -------------------------------------------------------------------------
    // Internal Wire Declarations
    // -------------------------------------------------------------------------

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

    // Write-Back Stage Wires
    wire [31:0] ResultW;

    // Hazard Unit Wires
    wire [1:0] ForwardA_E, ForwardB_E;

    // Module Instantiations

    // 1. Fetch Stage
    fetch_cycle fetch_stage (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // 2. Decode Stage
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

    // 3. Execute Stage
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

    // 4. Memory Stage
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

    // 5. Hazard Unit
    hazard_unit hz_unit (
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RD_M(RD_M),
        .RD_W(RD_W),
        .Rs1_E(RS1_E),
        .Rs2_E(RS2_E),
        .ForwardAE(ForwardA_E),
        .ForwardBE(ForwardB_E)
    );

    // Write-Back Logic
  
    
    assign ResultW = (ResultSrcW == 1'b1) ? ReadDataW : ALU_ResultW;

endmodule