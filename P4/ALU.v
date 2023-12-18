`include "Defines.v"

module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [4:0] Shift,
    input wire [`ALUOp_bits:0] ALUOp,
    output reg [31:0] ALUResult,
    output reg Zero
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
            1000-1001: Reserved
            `ALU_NE : NE
            `ALU_LT : LT
            `ALU_LE : LE
            `ALU_GT : GT
            `ALU_GE : GE
            `ALU_EQ : EQ
    */
    always @(*) begin
        case (ALUOp)
            `ALU_ADDU: begin 
                    ALUResult = A + B;
                    Zero = 0;
                end
            `ALU_SUBU: begin 
                    ALUResult = A - B;
                    Zero = 0;
                end
            `ALU_AND: begin 
                    ALUResult = A & B;
                    Zero = 0;
                end
            `ALU_OR: begin 
                    ALUResult = A | B;
                    Zero = 0;
                end
            `ALU_SLL: begin 
                    ALUResult = B << Shift;
                    Zero = 0;
                end
            `ALU_SLT: begin 
                    ALUResult = ($signed(A) <  $signed(B));
                    Zero = 0;
                end
            `ALU_SRL: begin 
                    ALUResult = B >> Shift;
                    Zero = 0;
                end
            `ALU_SRA: begin 
                    ALUResult = $signed(B) >>> Shift;
                    Zero = 0;
                end    
            `ALU_NE:begin
                    ALUResult = 0;
                    Zero = (A != B);
                end
            `ALU_LT:begin
                    ALUResult = 0;
                    Zero = ($signed(A) <  $signed(B));
                end
            `ALU_LE:begin
                    ALUResult = 0;
                    Zero = ($signed(A) <= $signed(B));
                end
            `ALU_GT:begin
                    ALUResult = 0;
                    Zero = ($signed(A) >  $signed(B));
                end
            `ALU_GE:begin
                    ALUResult = 0;
                    Zero = ($signed(A) >= $signed(B));
                end
            `ALU_EQ:begin
                    ALUResult = 0;
                    Zero = (A == B);
                end
            default: begin
                ALUResult = 0;
                Zero = 0;
                end
        endcase
    end
endmodule