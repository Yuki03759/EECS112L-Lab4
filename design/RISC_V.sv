`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, RegWrite, MemRead, MemWrite, 
        Branch, JumpMux, Umux, JumpRMux;
logic [1:0] MemtoReg;
logic [1:0] ALUop;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop, JumpMux, Umux,  JumpRMux);
    
    ALUController ac(ALUop, Funct7, Funct3, Operation);

    Datapath dp(clk, reset, RegWrite , ALUSrc , MemWrite, MemRead, Umux, JumpMux, Branch, JumpRMux, MemtoReg, Operation, opcode, Funct7, Funct3, WB_Data);
        
endmodule
