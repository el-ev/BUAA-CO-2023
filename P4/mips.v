`include "Defines.v"

module mips (input wire clk, input wire reset);
    wire    [31:0]              PC              ;
    wire    [31:0]              NPC             ;
    wire    [31:0]              Instr           ;
    wire    [5:0]               OP,FUNC         ;
    wire    [4:0]               rs,rt,rd        ;
    wire    [4:0]               shamt           ;
    wire    [15:0]              Imm16           ;
    wire    [25:0]              Imm26           ;
    wire    [31:0]              Imm32           ;
    wire                        Zero            ;
    wire                        ALU_B_sel       ;
    wire                        ALU_Shift_sel   ;
    wire    [`ALUOp_bits:0]     ALUOp           ;
    wire    [31:0]              ALUResult       ;
    wire    [1:0]               ExtOp           ;
    wire    [2:0]               nPC_sel         ;
    wire    [1:0]               Reg_WA_sel      ;
    wire    [1:0]               Reg_WD_sel      ;
    wire                        Reg_WE          ;
    wire    [31:0]              Reg_RD1         ;
    wire    [31:0]              Reg_RD2         ;
    wire                        DM_WE           ;
    wire    [1:0]               DM_Align        ;
    wire                        DM_Sign         ;
    wire    [31:0]              DM_RD           ;
    wire                        rst             ;

    assign  rst                         =   reset       ;
    assign  {OP,rs,rt,rd,shamt,FUNC}    =   Instr       ;
    assign  Imm16                       =   Instr[15:0] ;
    assign  Imm26                       =   Instr[25:0] ;

    PC pc(
        .clk(clk),
        .rst(rst),
        .NPC(NPC),
        .PC(PC)
    );
    NPC npc(
        .PC(PC),
        .Instr_index(Imm26),
        .nPC_sel(nPC_sel),
        .Zero(Zero),
        .Imm32(Imm32),
        .JumpReg(Reg_RD1),
        .NPC(NPC)
    );
    IM im(
        .PC(PC),
        .Instruction(Instr)
    );
    GRF grf(
        .clk(clk),
        .rst(rst),
        .PC(PC),
        .RA1(rs),
        .RA2(rt),
        .WA(
            (Reg_WA_sel == `Reg_WA_RD) ? rd :
            (Reg_WA_sel == `Reg_WA_RT) ? rt :
            (Reg_WA_sel == `Reg_WA_31) ? 5'd31 : 5'd0
        ),
        .WE(Reg_WE),
        .WD(
            (Reg_WD_sel == `Reg_WD_ALU ) ? ALUResult :
            (Reg_WD_sel == `Reg_WD_DM  ) ? DM_RD     :
            (Reg_WD_sel == `Reg_WD_PC_4) ? (PC + 4)  : 0
        ),
        .RD1(Reg_RD1),
        .RD2(Reg_RD2)
    );
    Ext ext(
        .Imm16(Imm16),
        .Type(ExtOp),
        .Imm32(Imm32)
    );
    ALU alu(
        .A(Reg_RD1),
        .B(
            (ALU_B_sel == `ALU_B_RD2) ? Reg_RD2 :
            (ALU_B_sel == `ALU_B_Imm) ? Imm32   : 0
        ),
        .Shift(
            (ALU_Shift_sel == `ALU_Shift_RD1  ) ? Reg_RD1[4:0] :
            (ALU_Shift_sel == `ALU_Shift_shamt) ? shamt        : 5'd0
        ),
        .ALUOp(ALUOp),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    DM dm(
        .clk(clk),
        .rst(rst),
        .PC(PC),
        .Addr(ALUResult),
        .WD(Reg_RD2),
        .WE(DM_WE),
        .Align(DM_Align),
        .Sign(DM_Sign),
        .RD(DM_RD)
    );
    Controller controller(
        .OP(OP),
        .FUNC(FUNC),
        .ALU_B_sel(ALU_B_sel),
        .ALU_Shift_sel(ALU_Shift_sel),
        .ALUOp(ALUOp),
        .ExtOp(ExtOp),
        .nPC_sel(nPC_sel),
        .Reg_WE(Reg_WE),
        .Reg_WA_sel(Reg_WA_sel),
        .Reg_WD_sel(Reg_WD_sel),
        .DM_WE(DM_WE),
        .DM_Align(DM_Align),
        .DM_Sign(DM_Sign)
    );


endmodule