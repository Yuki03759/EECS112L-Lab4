typedef struct packed {

    logic [31:0] pc; //why this pc has 9 bit
    logic [31:0] pcplus4;
    logic [31:0] instr;
}if_id_t;


typedef struct packed {
    
    //signal
    logic alusrc;
    logic [1:0] memtoreg;  
    logic regwrite;
    logic memread; 
    logic memwrite;
    logic branch;
    
    logic [2:0] funct3;
    logic [3:0] alu_cc;
    logic jumpmux;
    logic jumprmux;
    logic umux;

    //result
    logic [4:0] regwriteaddress;
    logic [31:0] readdata1;
    logic [31:0] readdata2;
    logic [4:0] readaddr1;
    logic [4:0] readaddr2;
    logic [31:0] ext_imm; 
    
    //Not sure
    logic [31:0] pc;
    logic [31:0] pcplus4;

}id_ex_t;

typedef struct packed {

    //signal
    logic [1:0] memtoreg;  
    logic regwrite;
    logic memread; 
    logic memwrite;
    
    //output
    logic [4:0] regwriteaddress;
    logic [31:0] aluresult;
    logic [31:0] readdata2;
    logic [2:0] funct3;
    logic [31:0] pcplus4;
    
}ex_mem_t;

typedef struct packed {

    //signal
    logic [1:0] memtoreg;
    logic regwrite;
    
    //output
    logic [4:0] regwriteaddress;
    logic [31:0] aluresult;
    logic [31:0] pcplus4;
    logic [31:0] readdata;


}mem_wb_t;