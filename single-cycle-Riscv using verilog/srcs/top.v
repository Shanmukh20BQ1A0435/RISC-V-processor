`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:NIT SURAT 
// Engineer: CH.SHANMUKH VARMA
// 
// Create Date: 07/12/2026 04:22:41 PM
// Design Name: 
// Module Name: top
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

// RISC-V Single-Cycle Top Module
//
// This is the main wrapper that connects every individual block of the processor.
// It uses internal wires to route data out of the Program Counter, fetch instructions
// from memory, decode control flags, read/write from registers, perform ALU math,
// and access data memory in a single clock cycle.

module top (
    input clk,
    input rst
);

    // Internal wire definitions
    wire [31:0] Pc_top;
    wire [31:0] NextPC;
    wire [31:0] PC4_top;
    wire [31:0] instruction_top;
    
    wire RegWrite_top;
    wire MemtoReg_top;
    wire MemWrite_top;
    wire MemRead_top;
    wire ALUSrc_top;
    wire Branch_top;
    wire [1:0] ALUOp_top;
    
    wire [31:0] RD1_top;
    wire [31:0] RD2_top;
    wire [31:0] ImmExt_top;
    wire [3:0]  ALU_ctrl_top;
    
    wire [31:0] ALU_in2_top;
    wire [31:0] ALU_res_top;
    wire Zero_top;
    
    wire [31:0] MemReadData_top;
    wire [31:0] mux_out_write_data;
    wire [31:0] BT_top;
    wire PCSrc;

    // 1. Program Counter & Adders
    program_counter PC_mod (
        .clk(clk),
        .rst(rst),
        .pc_in(NextPC),
        .pc_out(Pc_top)
    );

    PC_inc PC_adder (
        .pc_out(Pc_top),
        .pc_plus4(PC4_top)
    );

    Branch_adder Imm_adder (
        .plus4_addr(Pc_top),
        .ImmAddr(ImmExt_top),
        .mux_in_addr(BT_top)
    );

    // 2. Instruction Memory
    instruction_mem inst_mem (
        .read_address(Pc_top),
        .instruction_out(instruction_top)
    );

    // 3. Control Unit & Immediate Generator
    control_unit ctrl_unit (
        .opcode(instruction_top[6:0]),
        .reg_write(RegWrite_top),
        .mem_to_reg(MemtoReg_top),
        .mem_write(MemWrite_top),
        .alu_src(ALUSrc_top),
        .branch(Branch_top),
        .alu_op(ALUOp_top),
        .mem_read(MemRead_top)
    );

    ImmGen Imm (
        .opcode(instruction_top[6:0]),
        .instruction(instruction_top),
        .ImmExt(ImmExt_top)
    );

    // 4. Register File
    reg_file regFile (
        .clk(clk),
        .rst(rst),
        .reg_write(RegWrite_top),
        .rs1(instruction_top[19:15]),
        .rs2(instruction_top[24:20]),
        .rd(instruction_top[11:7]),
        .write_data(mux_out_write_data),
        .read_data_1(RD1_top),
        .read_data_2(RD2_top)
    );

    // 5. ALU Control & ALU Execution Unit
    ALU_control ALUctrl (
        .ALUOp(ALUOp_top),
        .fun7(instruction_top[30]),
        .fun3(instruction_top[14:12]),
        .control_out(ALU_ctrl_top)
    );

    mux Mux1 (
        .sel(ALUSrc_top),
        .in0(RD2_top),
        .in1(ImmExt_top),
        .out(ALU_in2_top)
    );

    ALU_unit ALU (
        .A(RD1_top),
        .B(ALU_in2_top),
        .control_in(ALU_ctrl_top),
        .zero(Zero_top),
        .ALU_out(ALU_res_top)
    );

    // 6. Data Memory
    data_mem DM (
        .clk(clk),
        .rst(rst),
        .MemRead(MemRead_top),
        .MemWrite(MemWrite_top),
        .address(ALU_res_top),
        .write_data(RD2_top),
        .read_data(MemReadData_top)
    );

    mux Mux2 (
        .sel(MemtoReg_top),
        .in0(ALU_res_top),
        .in1(MemReadData_top),
        .out(mux_out_write_data)
    );

    // 7. Next PC Selection Logic
    assign PCSrc = Branch_top & Zero_top;

    mux Mux3 (
        .sel(PCSrc),
        .in0(PC4_top),
        .in1(BT_top),
        .out(NextPC)
    );

endmodule
