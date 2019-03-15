`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

module Datapath #(
    parameter PC_W = 32, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite ,      // Register file writing enable   
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead ,                 // Memroy Reading Enable
    Umux, JumpMux, Branch, JumpRMux,
    input logic [1:0] MemtoReg , // Memory or ALU MUX or PC + 4
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2, SrcA;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] SrcB, ALUResult;
logic [DATA_W-1:0] ExtImm;
logic bmux;
logic [31:0] PCPlusImm;
logic [31:0] brresult;
logic [31:0] srcAPlusImm;
logic [31:0] rmuxresult;
logic [31:0] jmuxresult;


// next PC
    adder #(32) pcadd (PC, 32'b100, PCPlus4);
    flopr #(32) pcreg(clk, reset, jmuxresult, PC);

 //Instruction memory
    instructionmemory instr_mem (PC, Instr);
    
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];
      
// //Register File
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20],
            Result, Reg1, Reg2);
    
    mux2 #(32) umux(Reg1, PC, Umux, SrcA);
    //mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
           
//// sign extend
    imm_Gen Ext_Imm (Instr,ExtImm);

//// ALU
    mux2 #(32) srcbmux(Reg2, ExtImm, ALUsrc, SrcB);
    alu alu_module(SrcA, SrcB, ALU_CC, ALUResult);
    
    assign WB_Data = Result;

///// brmux
    branch_flag bf(Funct3, SrcA, SrcB, Branch, bmux);
    
    adder #(32) bradder(PC, ExtImm, PCPlusImm);
    adder #(32) brmuxPlusImm(.a(ExtImm), .b(SrcA), .y(srcAPlusImm));
    
    mux3 #(32) jumpmux ( PCPlus4, srcAPlusImm, PCPlusImm, {bmux || JumpMux ,  JumpRMux}, jmuxresult);
    
////// Data memory 
	datamemory data_mem (clk, MemRead, MemWrite, ALUResult[DM_ADDRESS-1:0], Reg2, Funct3, ReadData);
    //mux2 #(32) pcmux(Result, PCPlus4, PCMux, pcm);
    mux3 #(32) resmux(ALUResult, PCPlus4, ReadData, MemtoReg, Result); 
endmodule