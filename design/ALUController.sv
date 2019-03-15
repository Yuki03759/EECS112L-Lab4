`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  // 7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    output logic [3:0] Operation //operation selection for ALU
);
 
 /*
    add = 0000
    sub = 0001
    and = 0010
    or  = 0011
    xor = 0100
    sll = 0101
    srl = 0110
    sra = 0111
    slt = 1000
    sltu= 1001
    
 */
 //sub, or, sll, sra, sltu, ori, slli, srai
 assign Operation[0]=( 
                        ( (ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b000) )  || //sub
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b110) )  || //or
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b001) )  || //sll
                        ( (ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b101) )  || //sra
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b011) )  || //sltu
                        ( (ALUOp==2'b11) && (Funct3==3'b011) )                          || //sltiu
                        ( (ALUOp==2'b11) && (Funct3==3'b110) )                          || //ori
                        ( (ALUOp==2'b11) && (Funct7==7'b0000000) && (Funct3==3'b001) )  || //slli
                        ( (ALUOp==2'b11) && (Funct7==7'b0100000) && (Funct3==3'b101) )    //srai
                        
                        
                    );
                    
 //and, or, srl, sra, ori, andi, srli, srai
 assign Operation[1]=(
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b111) )  || //and
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b110) )  || //or
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b101) )  || //srl
                        ( (ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b101) )  || //sra
                        ( (ALUOp==2'b11) && (Funct3==3'b110) )                          || // ori
                        ( (ALUOp==2'b11) && (Funct3==3'b111) )                          || // andi
                        ( (ALUOp==2'b11) && (Funct7==7'b0000000) && (Funct3==3'b101) )  || // srli
                        ( (ALUOp==2'b11) && (Funct7==7'b0100000) && (Funct3==3'b101) )  || // srai
                        ( (ALUOp==2'b01) ) //lui
 
                     );
                     
 //xor, sll, srl, sra, xori, slli, srli, srai
 assign Operation[2]=(
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b100))   || //xor
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b001))   || //sll
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b101))   || //srl
                        ( (ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b101))   || //sra
                        ( (ALUOp==2'b11) && (Funct3==3'b100))                           || //xori 
                        ( (ALUOp==2'b11) && (Funct7==7'b0000000) && (Funct3==3'b001))   || //slli 
                        ( (ALUOp==2'b11) && (Funct7==7'b0000000) && (Funct3==3'b101))      //srli 
                    );
 
 //slt, sltu, slti
 assign Operation[3]=(
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b010))   || //slt
                        ( (ALUOp==2'b10) && (Funct7==7'b0000000) && (Funct3==3'b011))   || ///sltu
                        ( (ALUOp==2'b11) && (Funct3==3'b011))                           || //sltiu
                        ( (ALUOp==2'b11) && (Funct3==3'b010))                           || //slti
                        ( (ALUOp==2'b11) && (Funct7==7'b0100000) && (Funct3==3'b101))   ||   //srai
                        ( (ALUOp==2'b01) ) //lui
                    );
                    
endmodule
