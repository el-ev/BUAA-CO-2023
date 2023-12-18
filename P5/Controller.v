`include "Defines.v"

module Controller(
    input wire    [31:0]           Instruction     ,

    // pass to D
    output reg    [4:0]            CMPOp           ,
    output reg    [1:0]            ExtOp           ,
    output reg    [1:0]            nPC_sel         ,    

    // pass to E
    output reg    [4:0]            ALUOp           ,
    output reg                     ALU_B_sel       ,
    output reg                     ALU_Shift_sel   ,
    
    // pass to M
    output reg                     DM_WE           ,
    output reg    [1:0]            DM_Align        ,
    output reg                     DM_Sign         ,

    // pass to W
    output reg                     Reg_WE          ,
    output reg    [1:0]            Reg_WA_sel      ,
    output reg    [1:0]            Reg_WD_sel      ,

    // global
    output reg    [1:0]            Rs_Tuse         ,
    output reg    [1:0]            Rt_Tuse         ,
    output reg    [1:0]            Tnew 

);
    /*
        Controller
    */
    wire [5:0] OP, FUNC;

    assign OP = Instruction[31:26];
    assign FUNC = Instruction[5:0];

    reg [5:0] Instr;
    always @(*) begin
        // AND Logic
        if (OP == `OP_ZERO) begin
            case (FUNC)
                `FUNC_ADD   : Instr = `I_ADD    ;
                `FUNC_ADDU  : Instr = `I_ADDU   ;
                `FUNC_SUB   : Instr = `I_SUB    ;
                `FUNC_SUBU  : Instr = `I_SUBU   ;
                `FUNC_AND   : Instr = `I_AND    ;
                `FUNC_OR    : Instr = `I_OR     ;
                `FUNC_SLL   : Instr = `I_SLL    ;
                `FUNC_SLLV  : Instr = `I_SLLV   ;
                `FUNC_SLT   : Instr = `I_SLT    ;
                `FUNC_SRL   : Instr = `I_SRL    ;
                `FUNC_SRLV  : Instr = `I_SRLV   ;
                `FUNC_SRA   : Instr = `I_SRA    ;
                `FUNC_SRAV  : Instr = `I_SRAV   ;
                `FUNC_JR    : Instr = `I_JR     ;
                `FUNC_JALR  : Instr = `I_JALR   ;
                default     : Instr = `I_ERROR  ;
            endcase
        end
        else begin
            case (OP)
                `OP_ADDI   : Instr = `I_ADDI   ;
                `OP_ADDIU  : Instr = `I_ADDIU  ;
                `OP_ANDI   : Instr = `I_ANDI   ;
                `OP_ORI    : Instr = `I_ORI    ;
                `OP_SLTI   : Instr = `I_SLTI   ;
                `OP_BEQ    : Instr = `I_BEQ    ;
                `OP_J      : Instr = `I_J      ;
                `OP_JAL    : Instr = `I_JAL    ;
                `OP_LW     : Instr = `I_LW     ;
                `OP_SW     : Instr = `I_SW     ;
                `OP_LH     : Instr = `I_LH     ;
                `OP_LHU    : Instr = `I_LHU    ;
                `OP_SH     : Instr = `I_SH     ;
                `OP_LB     : Instr = `I_LB     ;
                `OP_LBU    : Instr = `I_LBU    ;
                `OP_SB     : Instr = `I_SB     ;
                `OP_LUI    : Instr = `I_LUI    ;
                default    : Instr = `I_ERROR  ;
            endcase
        end
    end

    always @(*) begin
        case (Instr)
            `I_ADD      : begin
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;//Temporarily
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end         
            `I_ADDU     : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end     
            `I_SUB      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SUBU           ;//Temporarily
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end     
            `I_SUBU     : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SUBU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end     
            `I_AND      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_AND            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end     
            `I_OR       : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_OR             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end     
            `I_SLL      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `ALU_Shift_shamt    ;
                ALUOp           =   `ALU_SLL            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SLLV     : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `ALU_Shift_RS       ;
                ALUOp           =   `ALU_SLL            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SLT      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SLT            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SRL      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `ALU_Shift_shamt    ;
                ALUOp           =   `ALU_SRL            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SRLV     : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `ALU_Shift_RS       ;
                ALUOp           =   `ALU_SRL            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SRA      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `ALU_Shift_shamt    ;
                ALUOp           =   `ALU_SRA            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SRAV     : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `ALU_Shift_RS       ;
                ALUOp           =   `ALU_SRA            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_JR       : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_reg       ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   0                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end
            `I_JALR     : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_reg       ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_PC_8        ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   0                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end
            `I_ADDI     : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;//Temporarily
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;
            end
            `I_ADDIU    : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;
            end
            `I_ANDI     : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_AND            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;
            end
            `I_ORI      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_OR             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;
            end
            `I_SLTI     : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SLT            ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;
            end
            `I_BEQ      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `CMP_EQ             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_branch         ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   0                   ;
                Rt_Tuse         =   0                   ;
                Tnew            =   0                   ;
            end
            `I_J        : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_instr     ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end
            `I_JAL      : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_instr     ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_31          ;
                Reg_WD_sel      =   `Reg_WD_PC_8        ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end
            `I_LW       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ;
                DM_Align        =   `DM_align_word      ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   2                   ;
            end
            `I_SW       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Enabled            ;
                DM_Align        =   `DM_align_word      ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   2                   ;
                Tnew            =   0                   ;
            end
            `I_LH       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ;
                DM_Align        =   `DM_align_half      ;
                DM_Sign         =   `DM_signed          ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   2                   ;
            end
            `I_LHU      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ;
                DM_Align        =   `DM_align_half      ;
                DM_Sign         =   `DM_unsigned        ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   2                   ;
            end
            `I_SH       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Enabled            ;
                DM_Align        =   `DM_align_half      ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   2                   ;
                Tnew            =   0                   ;
            end
            `I_LB       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ;
                DM_Align        =   `DM_align_byte      ;
                DM_Sign         =   `DM_signed          ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   2                   ;
            end
            `I_LBU      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ;
                DM_Align        =   `DM_align_byte      ;
                DM_Sign         =   `DM_unsigned        ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   2                   ;
            end
            `I_SB       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Enabled            ;
                DM_Align        =   `DM_align_byte      ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   2                   ;
                Tnew            =   0                   ;
            end
            `I_LUI      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_OR             ;//implemented as (Imm16 || 16'b0) OR 31'b0
                CMPOp           =   `Unused             ;
                ExtOp           =   `Ext_High           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end

            `I_ERROR    : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `Unused             ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end         
            default     : begin             
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `Unused             ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end
        endcase
    end

endmodule