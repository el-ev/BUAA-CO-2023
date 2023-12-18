`include "Defines.v"

module Controller(
    input wire    [5:0]            OP              ,
    input wire    [5:0]            FUNC            ,
    output reg                     ALU_B_sel       ,
    output reg                     ALU_Shift_sel   ,
    output reg    [`ALUOp_bits:0]  ALUOp           ,
    output reg    [1:0]            ExtOp           ,
    output reg    [2:0]            nPC_sel         ,
    output reg                     Reg_WE          ,
    output reg    [1:0]            Reg_WA_sel      ,
    output reg    [1:0]            Reg_WD_sel      ,
    output reg                     DM_WE           ,
    output reg    [1:0]            DM_Align        ,
    output reg                     DM_Sign         
);
    /*
        Controller
    */
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
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;  //Temporarily
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end         
            `I_ADDU     : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end     
            `I_SUB      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SUBU           ;  //Temporarily
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end     
            `I_SUBU     : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SUBU           ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end     
            `I_AND      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_AND            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end     
            `I_OR       : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_OR             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end     
            `I_SLL      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `ALU_Shift_shamt    ;
                ALUOp           =   `ALU_SLL            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end
            `I_SLLV     : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `ALU_Shift_RD1      ;
                ALUOp           =   `ALU_SLL            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end
            `I_SLT      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SLT            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end
            `I_SRL      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `ALU_Shift_shamt    ;
                ALUOp           =   `ALU_SRL            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_SRLV     : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `ALU_Shift_RD1      ;
                ALUOp           =   `ALU_SRL            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_SRA      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `ALU_Shift_shamt    ;
                ALUOp           =   `ALU_SRA            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_SRAV     : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `ALU_Shift_RD1      ;
                ALUOp           =   `ALU_SRA            ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_JR       : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_reg       ;
                Reg_WE          =   `Disabled           ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end
            `I_JALR     : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_reg       ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RD          ;
                Reg_WD_sel      =   `Reg_WD_PC_4        ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end
            `I_ADDI     : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;  //Temporarily
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ; 
            end
            `I_ADDIU    : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_ANDI     : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_AND            ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_ORI      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_OR             ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_SLTI     : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_SLT            ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_BEQ      : begin     
                ALU_B_sel       =   `ALU_B_RD2          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_EQ             ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_branch         ;
                Reg_WE          =   `Disabled           ; 
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_J        : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_instr     ;
                Reg_WE          =   `Disabled           ; 
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_JAL      : begin     
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `NPC_jump_instr     ;
                Reg_WE          =   `Enabled            ;
                Reg_WA_sel      =   `Reg_WA_31          ;
                Reg_WD_sel      =   `Reg_WD_PC_4        ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_LW       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ; 
                DM_Align        =   `DM_align_word      ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_SW       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Disabled           ; 
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Enabled            ; 
                DM_Align        =   `DM_align_word      ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_LH       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ; 
                DM_Align        =   `DM_align_half      ; 
                DM_Sign         =   `DM_signed          ; 
            end
            `I_LHU      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ; 
                DM_Align        =   `DM_align_half      ; 
                DM_Sign         =   `DM_unsigned        ; 
            end
            `I_SH       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Disabled           ; 
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Enabled            ; 
                DM_Align        =   `DM_align_half      ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_LB       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ; 
                DM_Align        =   `DM_align_byte      ; 
                DM_Sign         =   `DM_signed          ; 
            end
            `I_LBU      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Zero           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_DM          ;
                DM_WE           =   `Disabled           ; 
                DM_Align        =   `DM_align_byte      ; 
                DM_Sign         =   `DM_unsigned        ; 
            end
            `I_SB       : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_ADDU           ;
                ExtOp           =   `Ext_Sign           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Disabled           ; 
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Enabled            ; 
                DM_Align        =   `DM_align_byte      ; 
                DM_Sign         =   `Unused             ; 
            end
            `I_LUI      : begin     
                ALU_B_sel       =   `ALU_B_Imm          ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `ALU_OR             ;  //implemented as (Imm16 || 16'b0) OR 31'b0
                ExtOp           =   `Ext_High           ;
                nPC_sel         =   `NPC_default        ;
                Reg_WE          =   `Enabled            ; 
                Reg_WA_sel      =   `Reg_WA_RT          ;
                Reg_WD_sel      =   `Reg_WD_ALU         ;
                DM_WE           =   `Unused             ; 
                DM_Align        =   `Unused             ; 
                DM_Sign         =   `Unused             ; 
            end

            `I_ERROR    : begin
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `Unused             ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end         
            default     : begin             
                ALU_B_sel       =   `Unused             ;
                ALU_Shift_sel   =   `Unused             ;
                ALUOp           =   `Unused             ;
                ExtOp           =   `Unused             ;
                nPC_sel         =   `Unused             ;
                Reg_WE          =   `Unused             ;
                Reg_WA_sel      =   `Unused             ;
                Reg_WD_sel      =   `Unused             ;
                DM_WE           =   `Unused             ;
                DM_Align        =   `Unused             ;
                DM_Sign         =   `Unused             ;
            end
        endcase
    end

endmodule