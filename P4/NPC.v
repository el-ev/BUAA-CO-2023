`include "Defines.v"

module NPC(
    input  wire [31:0]  PC              ,
    input  wire [25:0]  Instr_index     ,
    input  wire [2:0]   nPC_sel         ,
    input  wire         Zero            ,
    input  wire [31:0]  Imm32           ,
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
    assign BranchAddr = PC + 4 + (Imm32 << 2);

    assign JumpInstrAddr = {PC[31:28], {2'b0, Instr_index[25:0]} << 2};
    assign JumpAddr = (Jump_to_Instr) ? JumpInstrAddr : JumpReg;
    
    assign NPC = (Jump          ) ? JumpAddr   :
                 (Branch && Zero) ? BranchAddr : PC + 4;
endmodule