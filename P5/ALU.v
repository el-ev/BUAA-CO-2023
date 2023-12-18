`include "Defines.v"

module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [4:0] Shift,
    input wire [4:0] ALUOp,
    output reg [31:0] ALURes
);
    /*
        Arithmetic Logic Unit
        Supported operations:
            `ALU_ADDU : ADDU
            `ALU_SUBU : SUBU
            `ALU_AND : AND
            `ALU_OR  : OR
            `ALU_SLL : SLL
            `ALU_SLT : SLT
            `ALU_SRL : SRL
            `ALU_SRA : SRA
            `ALU_SLTU : SLTU
    */
    always @(*) begin
        case (ALUOp)
            `ALU_ADDU :  ALURes = A + B;
            `ALU_SUBU :  ALURes = A - B;
            `ALU_AND  :  ALURes = A & B;
            `ALU_OR   :  ALURes = A | B;
            `ALU_SLL  :  ALURes = B << Shift;
            `ALU_SLT  :  ALURes = ($signed(A) <  $signed(B));
            `ALU_SRL  :  ALURes = B >> Shift;
            `ALU_SRA  :  ALURes = $signed(B) >>> Shift;   
            `ALU_SLTU :  ALURes = (A < B);
            default   :  ALURes = 0;
        endcase
    end
endmodule