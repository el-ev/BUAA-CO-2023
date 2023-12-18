`include "Defines.v"

module Controller(
    input wire    [31:0]           Instruction     ,

    // pass to D
    output reg    [4:0]            CMPOp           ,
    output reg    [1:0]            ExtOp           ,
    output reg    [2:0]            nPC_sel         ,    

    // pass to E
    output reg    [4:0]            ALUOp           ,
    output reg                     ALU_B_sel       ,
    output reg                     ALU_Shift_sel   ,
    output reg    [3:0]            MulDivOp        ,
    // pass to M
    output reg                     DM_WE           ,
    output reg    [2:0]            DM_Align        ,
    output reg                     DM_Sign         ,
    output reg                     DM_SIG          ,
    // pass to W
    output reg                     Reg_WE          ,
    output reg    [1:0]            Reg_WA_sel      ,
    output reg    [2:0]            Reg_WD_sel      ,

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
                `FUNC_SUB   : Instr = `I_SUB    ;
                `FUNC_AND   : Instr = `I_AND    ;
                `FUNC_OR    : Instr = `I_OR     ;
                `FUNC_SLT   : Instr = `I_SLT    ;
                `FUNC_SLTU  : Instr = `I_SLTU   ;
                `FUNC_JR    : Instr = `I_JR     ;
                `FUNC_JALR  : Instr = `I_JALR   ;
                `FUNC_MULT  : Instr = `I_MULT   ;
                `FUNC_MULTU : Instr = `I_MULTU  ;
                `FUNC_DIV   : Instr = `I_DIV    ;
                `FUNC_DIVU  : Instr = `I_DIVU   ;
                `FUNC_MFHI  : Instr = `I_MFHI   ;
                `FUNC_MFLO  : Instr = `I_MFLO   ;
                `FUNC_MTHI  : Instr = `I_MTHI   ;
                `FUNC_MTLO  : Instr = `I_MTLO   ;
                default     : Instr = `I_ERROR  ;
            endcase
        end
        else begin
            case (OP)
                `OP_ADDI   : Instr = `I_ADDI   ;
                `OP_ANDI   : Instr = `I_ANDI   ;
                `OP_ORI    : Instr = `I_ORI    ;
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
                `OP_BNE    : Instr = `I_BNE    ;
                default    : Instr = `I_ERROR  ;
            endcase
        end
    end

    always @(*) begin
        DM_SIG = 0;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   1                   ;
            end
            `I_SLTU      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SLTU           ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
                Rs_Tuse         =   0                   ;
                Rt_Tuse         =   0                   ;
                Tnew            =   0                   ;
            end
            `I_BNE      : begin     
                ALU_B_sel       =   `ALU_B_RT           ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `CMP_NE             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_branch         ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;
            end
            `I_MULT     : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Mult            ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   0                   ;               
            end
            `I_MULTU    : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Multu           ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   0                   ;               
            end
            `I_DIV      : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Div             ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   0                   ;               
            end
            `I_DIVU     : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Divu            ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   1                   ;
                Tnew            =   0                   ;               
            end
            `I_MFLO     : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_HILO        ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Mflo            ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;               
            end
            `I_MFHI     : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_HILO        ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Mfhi            ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   1                   ;               
            end
            `I_MTLO     : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Mtlo            ;
                Rs_Tuse         =   1                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;               
            end
            `I_MTHI     : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                CMPOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
                MulDivOp        =   `MD_Mthi            ;
                Rs_Tuse         =   1                   ;
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
                MulDivOp        =   `Unused             ;
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
                MulDivOp        =   `Unused             ;
                Rs_Tuse         =   3                   ;
                Rt_Tuse         =   3                   ;
                Tnew            =   0                   ;
            end
        endcase
    end

endmodule