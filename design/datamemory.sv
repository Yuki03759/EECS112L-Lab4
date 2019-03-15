    `timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
    )(
    input logic clk,
	input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [ DATA_W -1:0] wd , // Write Data
    
    input logic [2:0] Funct3, 
    output logic [ DATA_W -1:0] rd // Read Data
    );

`ifdef __SIM__ 
    
    logic [8-1:0] mem [4*(2**DM_ADDRESS)-1:0];

    always_comb
    begin
        if(MemRead)begin
            if(Funct3[1])begin          //LW
                rd = {mem[a+3], mem[a+2], mem[a+1], mem[a]};
            end else if(Funct3[0])begin //LB, LBU
                rd = {(mem[a+1][7]&&!Funct3[2])? {{16{1'b1}}, mem[a+1], mem[a]}:{{16{1'b0}}, mem[a+1], mem[a]} }; 
            end else begin              //LH, LHU
                rd = (mem[a][7]&&!Funct3[2])? {{24{1'b1}}, mem[a]}:{{24{1'b0}}, mem[a]};
            end
        end
    end
    
    always @(posedge clk) begin
        if(MemWrite)begin
            if(Funct3[1])begin          //SW
                mem[a+3] = wd[31:24];
                mem[a+2] = wd[23:16];
                mem[a+1] = wd[15:8];
                mem[a] = wd[7:0];
            end else if(Funct3[0])begin //SH
                mem[a+1] = wd[15:8];
                mem[a] = wd[7:0];
            end else begin              //SB
                mem[a] = wd[7:0];
            end
        end
    end
/*    
    always_comb 
    begin
       if(MemRead)
        case(Funct3[1:0])
            00: //LB LBU
                rd = {(mem[a+1][7]&&!Funct3[2])? {24{1'b1}}:{24{1'b0}}, mem[a]};
            01: //LH LHU
                rd = {(mem[a+1][7]&&!Funct3[2])? {16{1'b1}}:{16{1'b0}}, mem[a+1], mem[a]}; 
            10: //LW
                rd = {mem[a+3], mem[a+2], mem[a+1], mem[a]};
        endcase
	end
    
    always @(posedge clk) begin
       if (MemWrite)
        case(Funct3[1:0])
            00: //SB
                mem[a] = wd[7:0];
            01: begin//SH
                mem[a+1] = wd[15:8];
                mem[a] = wd[7:0];
                end
            10: begin//SW
                mem[a+3] = wd[31:24];
                mem[a+2] = wd[23:16];
                mem[a+1] = wd[15:8];
                mem[a] = wd[7:0];
                end
        endcase
    end
    */
`else
   logic we;
    assign we = MemWrite;
  
   SRAM1RW512x32 RAM (
         .A       ( a[8:0] ),
         .CE      ( 1'b1   ),
         .WEB     ( ~we    ),
         .OEB     ( we     ),
         .CSB     ( 1'b0   ),
         .I       ( wd     ),
         .O       ( rd     )
         );

`endif
    
    
endmodule
