`timescale 1ns / 1ps

module ALU(input [3:0] ALUop,
           input [31:0] ina, inb,
           output zero,
           output reg [31:0] out);

    always @ * begin
        case(ALUop)
            4'b0000: out = ina & inb;
            4'b0001: out = ina | inb;
            4'b0010: out = ina + inb;
            4'b0011: out = ina ^ inb;
            4'b0100: out = ina << inb[4:0];
            4'b0101: out = ina >> inb[4:0];
            4'b0110: out = ina - inb;
            4'b0111: out = ina & inb;
            4'b1000: begin
                if ($signed(ina) < $signed(inb)) begin
                    out = 32'b1;
                end else begin
                    out = 32'b0;
                end
            end
            4'b1001: out = ina >>> inb[4:0];
            default: out = 32'b0;
        endcase
    end
    
    assign zero = (out==32'b0)? 1'b1 : 1'b0;

endmodule
