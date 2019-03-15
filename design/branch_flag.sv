`timescale 1ns / 1ps

module branch_flag(

    input logic [2:0] Funct3,
    input logic [31:0] srcA, srcB,
    input logic Branch,
    output logic bmux
    
);

    always_comb
    begin
        bmux ='d0;

        case(Funct3[2:0])
            3'b000://BEQ (branch equal )
                bmux = Branch && ((srcA-srcB)==0) ? 1'b1: 1'b0;
            3'b001://BNE (branch not equal)
                bmux = Branch && ((srcA-srcB)!=0) ? 1'b1: 1'b0;
            3'b100://BLT (branch less than)
                bmux = Branch && ($signed(srcA) < $signed(srcB)) ? 1'b1: 1'b0;
            3'b101://BGE (branch greater than or equal)
                bmux = Branch && ($signed(srcA) >= $signed(srcB)) ? 1'b1: 1'b0;
            3'b110://BLTU (branch less than unsigned)
                bmux = Branch && (srcA < srcB) ? 1'b1: 1'b0;
            3'b111://BGEU (branch greater equal unsigned)
                bmux = Branch && (srcA>= srcB) ? 1'b1: 1'b0;
        endcase
    end
endmodule