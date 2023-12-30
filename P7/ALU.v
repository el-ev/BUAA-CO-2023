`include "Defines.v"

module ALU (
    input wire ALUOv,
    input wire DM_Ov,
    output wire Exc_Ov,
    output wire Exc_Ov_DM,

    input wire [31:0] A,
    input wire [31:0] B,
    input wire [4:0] ALUOp, // allows for 32 operations
    output reg [31:0] ALURes
);
    /*
        Arithmetic Logic Unit
        Supported operations:
            `ALU_ADD : ADDU
            `ALU_SUB : SUBU
            `ALU_AND : AND
            `ALU_OR  : OR
            `ALU_SLT : SLT
            `ALU_SLTU : SLTU
    */
    always @(*) begin
        case (ALUOp)
            `ALU_ADD :  ALURes = A + B;
            `ALU_SUB :  ALURes = A - B;
            `ALU_AND  :  ALURes = A & B;
            `ALU_OR   :  ALURes = A | B;
            `ALU_SLT  :  ALURes = ($signed(A) <  $signed(B));
            `ALU_SLTU :  ALURes = (A < B);
            default   :  ALURes = 0;
        endcase
    end

    wire [32:0] t_A = {A[31], A};
    wire [32:0] t_B = {B[31], B};
    wire [32:0] Add = t_A + t_B;
    wire [32:0] Sub = t_A - t_B;
    assign Exc_Ov = ALUOv && (
        (ALUOp == `ALU_ADD && Add[32] != Add[31]) ||
        (ALUOp == `ALU_SUB && Sub[32] != Sub[31])
    );
    assign Exc_Ov_DM = DM_Ov && (
        (ALUOp == `ALU_ADD && Add[32] != Add[31]) ||
        (ALUOp == `ALU_SUB && Sub[32] != Sub[31])
    ); 
    
endmodule