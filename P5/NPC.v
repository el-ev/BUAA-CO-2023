`include "Defines.v"

module NPC(
    input  wire [31:0]  F_PC            ,
    input  wire [31:0]  D_PC            ,
    input  wire [25:0]  Imm26           ,
    input  wire [1:0]   nPC_sel         ,
    input  wire         Zero            ,
    input  wire [31:0]  JumpReg         ,
    output wire [31:0]  NPC
);
    /*
        Next Program Counter
    */
    wire Jump, Branch, Jump_to_Instr, Jump_to_Reg;
    wire [31:0] BranchAddr;
    wire [31:0] JumpAddr, JumpInstrAddr;
    
    assign Jump_to_Instr = (nPC_sel == `NPC_jump_instr);
    assign Jump_to_Reg = (nPC_sel == `NPC_jump_reg);
    assign Jump = Jump_to_Instr || Jump_to_Reg;

    assign Branch = (nPC_sel == `NPC_branch);
    assign BranchAddr = D_PC + 4 + {{14{Imm26[15]}}, Imm26[15:0], 2'b0};
    
    assign JumpInstrAddr = {D_PC[31:28], Imm26, 2'b00};
    assign JumpAddr = (Jump_to_Instr) ? JumpInstrAddr : JumpReg;
    assign NPC = (Jump          ) ? JumpAddr   :
                 (Branch && Zero) ? BranchAddr : F_PC + 4;
endmodule