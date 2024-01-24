`timescale 1ns / 1ps

module RISC_V_COMPLETE(input clk,
                       input reset,
                       output[31:0] PC_EX_out,
                       output[31:0] ALU_OUT_EX_out,
                       output[31:0] PC_MEM_out,
                       output PCSrc_out,
                       output[31:0] DATA_MEMORY_MEM_out,
                       output[31:0] ALU_DATA_WB_out,
                       output[1:0] forwardA_out, forwardB_out,
                       output pipeline_stall_out);
  
    wire [31:0] PC_Branch;

    wire [31:0] PC_ID;
    wire [31:0] INSTRUCTION_ID;
    wire [31:0] IMM_ID;
    wire [31:0] REG_DATA1_ID;
    wire [31:0] REG_DATA2_ID;
  
    wire [2:0] FUNCT3_ID; 
    wire [6:0] FUNCT7_ID;
    wire [6:0] OPCODE_ID;
    wire [4:0] RD_ID;
    wire [4:0] RS1_ID;
    wire [4:0] RS2_ID;
  
    wire [31:0] PC_IF;
    wire [31:0] INSTRUCTION_IF;
    wire [31:0] IMM_EX;
    wire [31:0] REG_DATA1_EX,REG_DATA2_EX;
    wire [2:0] FUNCT3_EX;
    wire [6:0] FUNCT7_EX;
    wire [6:0] OPCODE_EX;
    wire [4:0] RD_EX;
    wire [4:0] RS1_EX;
    wire [4:0] RS2_EX;

    wire RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX;
    wire [1:0] ALUop_EX;
    wire ALUSrc_EX;
    wire Branch_EX;
    wire ZERO_EX;

    wire [31:0] PC_Branch_EX;
    wire [31:0] REG_DATA2_EX_FINAL;
    wire [1:0] forwardA,forwardB;
  
    wire ZERO_MEM;
    wire [31:0] ALU_OUT_MEM;
    wire [31:0] PC_Branch_MEM;
    wire [31:0] REG_DATA2_MEM_FINAL;
    wire [4:0] RD_MEM;
    wire RegWrite_MEM;
    wire MemtoReg_MEM;
    wire MemRead_MEM;
    wire MemWrite_MEM;
    wire [1:0] ALUop_MEM;
    wire ALUSrc_MEM;
    wire Branch_MEM;
    wire [2:0] FUNCT3_MEM;
  
    wire [31:0] read_data_data_mem;
  
    wire [31:0] read_data_WB;
    wire [31:0] address_WB;
    wire [4:0] RD_WB;
    wire RegWrite_WB;
    wire MemtoReg_WB;
  
    wire RegWrite_ID,MemtoReg_ID,MemRead_ID,MemWrite_ID;
    wire [1:0] ALUop_ID;
    wire ALUSrc_ID;
    wire Branch_ID;
    wire PC_write, control_sel,IF_ID_write;
  
    wire [31:0] PC_EX;
    wire [31:0] ALU_OUT_EX;
    wire [31:0] PC_MEM;
    wire PCSrc;
    wire [31:0] DATA_MEMORY_MEM;
    wire [31:0] ALU_DATA_WB;
    wire [1:0] forwardA, forwardB;
    wire pipeline_stall;
 
//Modulul Instruction Fetch
    IF instruction_fetch(clk, reset, PCSrc, PC_write, PC_Branch_MEM, PC_IF,INSTRUCTION_IF);
  
//Registru pipeline
    IF_ID_reg IF_ID_REGISTER(clk,reset, IF_ID_write, PC_IF,INSTRUCTION_IF, PC_ID,INSTRUCTION_ID);
  
//Modulul Instruction Decode
    ID instruction_decode(clk, PC_ID, INSTRUCTION_ID, RegWrite_WB, ALU_DATA_WB, RD_WB, IMM_ID, REG_DATA1_ID, REG_DATA2_ID,
        FUNCT3_ID, FUNCT7_ID, OPCODE_ID, RD_ID, RS1_ID, RS2_ID);
                      
//Registru pipeline
    ID_EX_reg pipe2(clk, reset, 1'b1, IMM_ID, REG_DATA1_ID, REG_DATA2_ID, PC_ID, FUNCT3_ID, FUNCT7_ID, OPCODE_ID, RD_ID,
        RS1_ID, RS2_ID, RegWrite_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID, ALUop_ID, ALUSrc_ID, Branch_ID, IMM_EX,
        REG_DATA1_EX, REG_DATA2_EX, PC_EX, FUNCT3_EX, FUNCT7_EX, OPCODE_EX, RD_EX, RS1_EX, RS2_EX, RegWrite_EX,
        MemtoReg_EX, MemRead_EX, MemWrite_EX, ALUop_EX, ALUSrc_EX, Branch_EX);
        
//Modulul Execute
    assign PC_EX_out = PC_EX;
    EX ex_mod(IMM_EX, REG_DATA1_EX, REG_DATA2_EX, PC_EX, FUNCT3_EX, FUNCT7_EX, RD_EX, RS1_EX, RS2_EX, RegWrite_EX,
        MemtoReg_EX, MemRead_EX, MemWrite_EX, ALUop_EX, ALUSrc_EX, Branch_EX, forwardA, forwardB, ALU_DATA_WB, ALU_OUT_MEM,
        ZERO_EX, ALU_OUT_EX, PC_Branch_EX, REG_DATA2_EX_FINAL);
          
//Registru pipeline
    EX_MEM pipe3(clk, reset, 1'b1, ZERO_EX, ALU_OUT_EX, PC_Branch_EX, REG_DATA2_EX_FINAL, RD_EX, RegWrite_EX, MemtoReg_EX,
        MemRead_EX, MemWrite_EX, ALUop_EX, ALUSrc_EX, Branch_EX, FUNCT3_EX, ZERO_MEM, ALU_OUT_MEM, PC_Branch_MEM, REG_DATA2_MEM_FINAL,
        RD_MEM, RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, ALUop_MEM, ALUSrc_MEM, Branch_MEM, FUNCT3_MEM);
  
//Modulul de Forwarding
    forwarding forw(RS1_EX, RS2_EX, RD_MEM, RD_WB, RegWrite_MEM, RegWrite_WB, forwardA, forwardB);      
                 
//Modulul Data Memory
    data_memory d_mem(clk, MemRead_MEM, MemWrite_MEM, ALU_OUT_MEM, REG_DATA2_MEM_FINAL, read_data_data_mem);        
  
    and_gate and_gate(ZERO_MEM,Branch_MEM, PCSrc);
  
//Registru pipeline
    MEM_WB pipe4(clk, reset, 1'b1, read_data_data_mem, ALU_OUT_MEM, RD_MEM, RegWrite_MEM, MemtoReg_MEM, read_data_WB, address_WB,
        RD_WB, RegWrite_WB, MemtoReg_WB);
               
//Zona de Write Back
    mux2_1 mux_WB(address_WB, read_data_WB, MemtoReg_WB, ALU_DATA_WB);
  
    hazard_detection haz_det(RD_EX, RS1_ID, RS2_ID, MemRead_EX, PC_write, IF_ID_write, control_sel);    
                        
    control_path CONTROL_PATH_MODULE(OPCODE_ID, Branch_ID, MemRead_ID, MemtoReg_ID, ALUop_ID, MemWrite_ID, ALUSrc_ID,
        RegWrite_ID);   
                                
//Modulul de Branch Control
    branch_control BRANCH_CONTROL(ZERO_MEM, ALU_OUT_MEM[31], Branch_MEM, FUNCT3_MEM, PCSrc);
    
    assign ALU_OUT_EX_out = ALU_OUT_EX;
    assign PC_MEM_out = PC_Branch_MEM;
    assign PCSrc_out = PCSrc;
    assign DATA_MEMORY_MEM_out = read_data_data_mem;
    assign ALU_DATA_WB_out = ALU_DATA_WB;
    assign forwardA_out = forwardA; 
    assign forwardB_out = forwardB;
    assign pipeline_stall_out = control_sel;
                       
endmodule
