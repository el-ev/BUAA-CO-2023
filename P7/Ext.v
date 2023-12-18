`include "Defines.v"

module Ext (
    input wire [15:0] Imm16,
    input wire [1:0] Type,
    output reg [31:0] Imm32
);
    /*
        Extender
        Supported operations:
            00: Zero-extend
            01: Sign-extend
            10: High-extend
            11: Reserved
    */
    always @(*) begin
        case (Type)
            `Ext_Zero:
                Imm32 = {16'b0, Imm16};
            `Ext_Sign:
                Imm32 = {{16{Imm16[15]}}, Imm16[15:0]};
            `Ext_High:
                Imm32 = {Imm16, 16'b0};
            default: 
                Imm32 = 0;
        endcase
    end
endmodule