`timescale 1ns / 1ps

module MEM_WB(input clk,
              input reset,
              input write,
              input [31:0] read_data_MEM,
              input [31:0] address_MEM,
              input [4:0] RD_MEM,
              input RegWrite_MEM,
              input MemtoReg_MEM,
              output reg [31:0] read_data_WB,
              output reg [31:0] address_WB,
              output reg [4:0] RD_WB,
              output reg RegWrite_WB,
              output reg MemtoReg_WB);
              
    always @(posedge clk) begin
        if (reset) begin
            read_data_WB <= 0;
            address_WB <= 0;
            RD_WB <= 0;
            RegWrite_WB <= 0;
            MemtoReg_WB <= 0;
        end
        else if (write) begin
            read_data_WB <= read_data_MEM;
            address_WB <= address_MEM;
            RD_WB <= RD_MEM;
            RegWrite_WB <= RegWrite_MEM;
            MemtoReg_WB <= MemtoReg_MEM;
        end
    end
              
endmodule
