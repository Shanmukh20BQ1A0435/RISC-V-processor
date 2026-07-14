`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NIT SURAT 
// Engineer: CH.SHANMUKH VARMA 
// 
// Create Date: 07/12/2026 01:08:48 PM
// Design Name: 
// Module Name: fetch_cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Fetches instructions from memory, increments the program counter, 
//              and registers the signals to interface with the decode stage.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fetch_cycle(clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);

    input clk, rst;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD;
    output [31:0] PCD, PCPlus4D;

    wire [31:0] PC_F, PCF, PCPlus4F;
    wire [31:0] InstrF;

    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    mux PC_MUX (
        .sel(PCSrcE),
        .in0(PCPlus4F),
        .in1(PCTargetE),
        .out(PC_F)
    );

    program_counter Program_Counter (
        .clk(clk),
        .rst(rst),
        .pc_in(PC_F),
        .pc_out(PCF)
    );

    instruction_mem IMEM (
        .read_address(PCF),
        .instruction_out(InstrF)
    );

    PC_inc PC_adder (
        .pc_out(PCF),
        .pc_plus4(PCPlus4F)
    );

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    assign  InstrD = (rst == 1'b0) ? 32'h00000000 : InstrF_reg;
    assign  PCD = (rst == 1'b0) ? 32'h00000000 : PCF_reg;
    assign  PCPlus4D = (rst == 1'b0) ? 32'h00000000 : PCPlus4F_reg;

endmodule
