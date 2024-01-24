`timescale 1ns / 1ps

module EX(input [31:0] IMM_EX,
          input [31:0] REG_DATA1_EX,
          input [31:0] REG_DATA2_EX,
          input [31:0] PC_EX,
          input [2:0] FUNCT3_EX,
          input [6:0] FUNCT7_EX,
          input [4:0] RD_EX,
          input [4:0] RS1_EX,
          input [4:0] RS2_EX,
          input RegWrite_EX,
          input MemtoReg_EX,
          input MemRead_EX,
          input MemWrite_EX,
          input [1:0] ALUop_EX,
          input ALUSrc_EX,
          input Branch_EX,
          input [1:0] forwardA, forwardB,
          input [31:0] ALU_DATA_WB,
          input [31:0] ALU_OUT_MEM,
          output ZERO_EX,
          output [31:0] ALU_OUT_EX,
          output [31:0] PC_Branch_EX,
          output [31:0] REG_DATA2_EX_FINAL);
          
    wire [31:0] MUX1_OUT, MUX2_OUT, MUX3_OUT;
    wire [3:0] ALU_output;
    
    mux4_1 mux1(.in1(REG_DATA1_EX), .in2(ALU_DATA_WB), .in3(ALU_OUT_MEM), .in4(32'b0), .sel(forwardA), .out(MUX1_OUT));
    
    mux4_1 mux2(.in1(REG_DATA2_EX), .in2(ALU_DATA_WB), .in3(ALU_OUT_MEM), .in4(32'b0), .sel(forwardB), .out(MUX2_OUT));
    
    mux2_1 mux3(.ina(MUX2_OUT), .inb(IMM_EX), .sel(ALUSrc_EX), .out(MUX3_OUT));
    
    ALUcontrol ALU_control_unit(.ALUop(ALUop_EX), .funct7(FUNCT7_EX), .funct3(FUNCT3_EX), .ALUinput(ALU_output));
    
    ALU ALU_module(.ALUop(ALU_output), .ina(MUX1_OUT), .inb(MUX3_OUT), .zero(ZERO_EX), .out(ALU_OUT_EX));
    
    adder add_EX(.ina(PC_EX), .inb(IMM_EX), .out(PC_Branch_EX));
    
    assign REG_DATA2_EX_FINAL = MUX2_OUT;
          
endmodule
