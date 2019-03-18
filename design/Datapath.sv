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
    parameter PC_W = 9, // Program Counter
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

`include "structs.sv"

logic [PC_W-1:0] PC, PCPlus4, newPC;
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
logic [31:0] SrcA_toForwardMux, SrcB_toForwardMux;
logic [1:0] ForwardA, ForwardB;
logic stall;

//initialization
if_id_t if_id;
id_ex_t id_ex;
ex_mem_t ex_mem;
mem_wb_t mem_wb;

//if_id
always @(posedge clk) begin
    if(reset || {bmux || id_ex.jumpmux ,  id_ex.jumprmux} != 2'b00)
        begin
            if_id.pc        <= 0;
            if_id.pcplus4   <= 0;
            if_id.instr     <= 0;
        end
    else if (!stall)
        begin
            if_id.pc        <= PC;
            if_id.pcplus4   <= PCPlus4;
            if_id.instr     <= Instr;
        end
end

//id_ex
always @(posedge clk) begin
    if(reset || stall || {bmux || id_ex.jumpmux ,  id_ex.jumprmux} != 2'b00)
        begin
            id_ex.alusrc        <= 0;
            id_ex.memtoreg      <= 0;  
            id_ex.regwrite      <= 0;
            id_ex.memread       <= 0; 
            id_ex.memwrite      <= 0;
            id_ex.branch        <= 0;
            
            id_ex.funct3        <= 0;
            id_ex.alu_cc        <= 0;
            id_ex.jumpmux       <= 0;
            id_ex.jumprmux      <= 0;
            id_ex.umux          <= 0;
            
            id_ex.regwriteaddress <= 0;
            id_ex.readdata1     <= 0;
            id_ex.readdata2     <= 0;
            id_ex.readaddr1       <= 0;
            id_ex.readaddr2       <= 0;
            id_ex.ext_imm       <= 0;
            
            id_ex.pc            <=  0;
            id_ex.pcplus4       <=  0;
        end
    else
        begin
            id_ex.alusrc    <= ALUsrc;
            id_ex.memtoreg  <= MemtoReg; 
            id_ex.regwrite  <= RegWrite;
            id_ex.memread   <= MemRead; 
            id_ex.memwrite  <= MemWrite;
            id_ex.branch    <= Branch;
            
            id_ex.funct3    <= Funct3;
            id_ex.alu_cc    <= ALU_CC;
            id_ex.jumpmux   <= JumpMux;
            id_ex.jumprmux  <= JumpRMux;
            id_ex.umux      <= Umux;
            
            id_ex.regwriteaddress   <= if_id.instr[11:7];
            id_ex.readaddr1         <= if_id.instr[19:15];
            id_ex.readaddr2         <= if_id.instr[24:20];
            id_ex.readdata1         <= Reg1;
            id_ex.readdata2         <= Reg2;
            id_ex.ext_imm           <= ExtImm; 
            
            id_ex.pc                <=  if_id.pc;
            id_ex.pcplus4           <=  if_id.pcplus4;
            
        end
end

//ex_mem
always @(posedge clk) begin
    if(reset)
        begin
            ex_mem.memtoreg     <= 0;  
            ex_mem.regwrite     <= 0;
            ex_mem.memread      <= 0; 
            ex_mem.memwrite     <= 0; 
            
            ex_mem.regwriteaddress  <= 0;
            ex_mem.aluresult    <= 0;
            ex_mem.readdata2        <= 0;
            ex_mem.funct3       <= 0;
            ex_mem.pcplus4      <= 0;
            
        end
    else
        begin
            ex_mem.memtoreg         <= id_ex.memtoreg;  
            ex_mem.regwrite         <= id_ex.regwrite;
            ex_mem.memread          <= id_ex.memread; 
            ex_mem.memwrite         <= id_ex.memwrite;
            
            ex_mem.regwriteaddress  <= id_ex.regwriteaddress;
            ex_mem.aluresult        <= ALUResult;
            ex_mem.readdata2        <= id_ex.readdata2;
            ex_mem.funct3           <= id_ex.funct3;
            ex_mem.pcplus4          <= id_ex.pcplus4;
            
        end
end

//mem_wb
always @(posedge clk) begin
    if(reset)
        begin
            mem_wb.memtoreg         <= 0;
            mem_wb.regwrite         <= 0;
        
            mem_wb.regwriteaddress  <= 0;
            mem_wb.aluresult           <= 0;
            mem_wb.pcplus4          <= 0;
            mem_wb.readdata        <= 0;
        end
    else
        begin
            mem_wb.memtoreg         <= ex_mem.memtoreg;
            mem_wb.regwrite         <= ex_mem.regwrite;
            
            mem_wb.regwriteaddress  <= ex_mem.regwriteaddress;
            mem_wb.aluresult        <= ex_mem.aluresult;
            mem_wb.pcplus4          <= ex_mem.pcplus4;
            mem_wb.readdata         <= ReadData;
        end
end

// ------------------------------------------//
//              Module                       //
// ------------------------------------------//


    adder #(9) pcadd (PC, 9'b100, PCPlus4);
    flopr #(9) pcreg(clk, reset, newPC, PC);
    mux2 #(9) pcmux( jmuxresult[8:0] , PC , stall, newPC); 
    instructionmemory instr_mem (PC, Instr);
    
// ------------- IF_ID -----------------------------------    

    assign opcode = if_id.instr[6:0];
    assign Funct7 = if_id.instr[31:25];
    assign Funct3 = if_id.instr[14:12];
    
    hazard_Detection_Unit hu (if_id.instr[19:15], if_id.instr[24:20], id_ex.regwriteaddress, id_ex.memread, stall); 
     
    RegFile rf(clk, reset, mem_wb.regwrite, mem_wb.regwriteaddress, if_id.instr[19:15], if_id.instr[24:20],
            Result, Reg1, Reg2);
    
    imm_Gen Ext_Imm (if_id.instr, ExtImm);

// ------------- ID_Ex -----------------------------------    

    mux2 #(32) umux(id_ex.readdata1, {23'b0, id_ex.pc}, id_ex.umux, SrcA_toForwardMux);
    mux2 #(32) srcbmux(id_ex.readdata2, id_ex.ext_imm, id_ex.alusrc, SrcB_toForwardMux);
    alu alu_module(SrcA, SrcB, id_ex.alu_cc, ALUResult);
    
    branch_flag bf(id_ex.funct3, SrcA, SrcB, id_ex.branch , bmux);
    adder #(32) bradder( {23'b0, id_ex.pc}, id_ex.ext_imm, PCPlusImm);
    adder #(32) brmuxPlusImm(.a(id_ex.ext_imm), .b(SrcA), .y(srcAPlusImm));
    mux3 #(32) jumpmux ( {23'b0, PCPlus4}, srcAPlusImm, PCPlusImm, {bmux || id_ex.jumpmux ,  id_ex.jumprmux}, jmuxresult);
    
    mux3 #(32) forwardA_Mux( SrcA_toForwardMux, Result, ex_mem.aluresult, ForwardA, SrcA);
    mux3 #(32) forwardB_Mux( SrcB_toForwardMux, Result, ex_mem.aluresult, ForwardB, SrcB);

    
    forwarding_Unit fu( id_ex.readaddr1, id_ex.readaddr2, mem_wb.regwriteaddress , ex_mem.regwriteaddress, id_ex.umux, id_ex.alusrc, mem_wb.regwrite ,ex_mem.regwrite , ForwardA, ForwardB);
// ----------- EX_Mem ----------------------------------       
    
    assign WB_Data = Result;
	datamemory data_mem (clk, ex_mem.memread, ex_mem.memwrite, ex_mem.aluresult[DM_ADDRESS-1:0], ex_mem.readdata2, ex_mem.funct3 , ReadData);

// --------- MEM_WB -----------------------------------    
    mux3 #(32) resmux(mem_wb.aluresult, {23'b0, mem_wb.pcplus4} , mem_wb.readdata, mem_wb.memtoreg, Result); 
endmodule