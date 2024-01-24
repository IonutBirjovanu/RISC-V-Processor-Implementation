`timescale 1ns / 1ps

module ALUcontrol(input [1:0] ALUop,
                   input [6:0] funct7,
                   input [2:0] funct3,
                   output reg [3:0] ALUinput);
                   
    always @ (ALUop) begin
        casex(ALUop)
            2'b00: begin
                casex({funct7,funct3})
                    10'bxxxxxxxxxx: ALUinput = 4'b0010; //ld,sd
                endcase
            end
            2'b01: begin
                casex({funct7,funct3})
                    10'bxxxxxxx00x: ALUinput = 4'b0110; //beq, bne
                    10'bxxxxxxx10x: ALUinput = 4'b1000; //blt, bge
                    10'bxxxxxxx11x: ALUinput = 4'b0111; //bltu, bgeu
                endcase
            end
            2'b10: begin
                casex({funct7,funct3})
                    10'b0000000000: ALUinput = 4'b0010; //add
                    10'b0100000000: ALUinput = 4'b0110; //sub
                    10'b0000000111: ALUinput = 4'b0000; //and
                    10'b0000000110: ALUinput = 4'b0001; //or
                    10'b0000000100: ALUinput = 4'b0011; //xor
                    10'b0000000011: ALUinput = 4'b0111; //sltu
                    10'b0000000010: ALUinput = 4'b1000; //slt
                endcase
            end
            2'b11: begin
                casex({funct7,funct3})
                    10'bxxxxxxx000: ALUinput = 4'b0010; //addi
                    10'bxxxxxxx110: ALUinput = 4'b0001; //ori
                endcase
            end
            2'b1x: begin
                casex({funct7,funct3})
                    10'b000000x101: ALUinput = 4'b0101; //srl, srli
                    10'b000000x001: ALUinput = 4'b0100; //sll, slli
                    10'b010000x101: ALUinput = 4'b1001; //sra, srai
                endcase
            end
        endcase
    end
                   
endmodule