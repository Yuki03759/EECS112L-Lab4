`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: hazard_Unit
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

module hazard_Detection_Unit(
    
    //Input
    input logic [4:0] if_id_Rs1,
    input logic [4:0] if_id_Rs2,
    input logic [4:0] id_ex_regwriteaddr,
    input logic id_ex_memRead,
    
    output logic stall
);

always_comb
begin

    stall = ( id_ex_memRead && ( (id_ex_regwriteaddr == if_id_Rs1) || (id_ex_regwriteaddr == if_id_Rs2) ) );
    
    /*
    if ( id_ex_memRead && ( (id_ex_regwriteaddr == if_id_Rs1) || (id_ex_regwriteaddr == if_id_Rs2) ) )
        stall = 1'b1;
    else
        stall = 1'b0;
*/
end

endmodule
