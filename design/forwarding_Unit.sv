`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Forwarding Unit
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

module forwarding_Unit(
    
    //Input
    input logic [4:0] id_ex_Rs1,
    input logic [4:0] id_ex_Rs2,
    input logic [4:0] mem_wb_regaddr,
    input logic [4:0] ex_mem_regaddr,
    input logic id_ex_umux,
    input logic id_ex_alusrc,
    input logic mem_wb_RegWrite,
    input logic ex_mem_RegWrite,
    
    
    //Outputs
    output logic [1:0] ForwardA,    //2'b00 No forwarding, pass SrcA
                                    //2'b01 forwarding, pass mem_web
                                    //2'b10 forwarding, pass ex_mem
    
    output logic [1:0] ForwardB     //2'b00 No forwarding, pass SrcB
                                    //2'b01 forwarding, pass mem_web
                                    //2'b10 forwarding, pass ex_mem
);

always_comb
    begin
//ForwardA
    if( ex_mem_RegWrite && ex_mem_regaddr == id_ex_Rs1 && id_ex_umux == 1'b0  ) //2'b01 forwarding, pass ex_mem
        ForwardA = 2'b10;   
    else if( mem_wb_RegWrite && mem_wb_regaddr == id_ex_Rs1 && id_ex_umux == 1'b0 ) //2'b10 forwarding, pass mem_web
        ForwardA = 2'b01;
    else //No forwarding
         ForwardA = 2'b00;
        
//ForwardB
    if ( ex_mem_RegWrite && ex_mem_regaddr == id_ex_Rs2 && id_ex_alusrc == 1'b0  )
         ForwardB = 2'b10;
    else if( mem_wb_RegWrite && mem_wb_regaddr == id_ex_Rs2 && id_ex_alusrc == 1'b0  ) //2'b10 forwarding, pass mem_web,
         ForwardB = 2'b01;
    else
         ForwardB = 2'b00;
    end 

endmodule