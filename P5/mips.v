`include "Defines.v"

module mips(input wire clk, input wire reset);
    wire stall;

    wire F_WE = !stall;
    wire D_WE = !stall;
    wire E_WE = `Enabled;
    wire M_WE = `Enabled;
    wire W_WE = `Enabled;

    wire F_rst = reset;
    wire D_rst = reset;
    wire E_rst = reset || stall;
    wire M_rst = reset;
    wire W_rst = reset;

    wire [31:0] E_Reg_WD;
    wire [31:0] M_Reg_WD;
    wire [31:0] W_Reg_WD;
    
    assign E_Reg_WD =
        //(E_Reg_WD_sel == `Reg_WD_ALU) ? E_ALURes :
        //(E_Reg_WD_sel == `Reg_WD_DM) ? E_DM_WD :
        (E_Reg_WD_sel == `Reg_WD_PC_8) ? E_PC + 8 : `Unused;
    assign M_Reg_WD =
        (M_Reg_WD_sel == `Reg_WD_ALU) ? M_ALURes :
        //(M_Reg_WD_sel == `Reg_WD_DM) ? M_DM_WD :
        (M_Reg_WD_sel == `Reg_WD_PC_8) ? M_PC + 8 : `Unused;
    assign W_Reg_WD =
        (W_Reg_WD_sel == `Reg_WD_ALU) ? W_ALURes :
        (W_Reg_WD_sel == `Reg_WD_DM) ? W_DM_RD :
        (W_Reg_WD_sel == `Reg_WD_PC_8) ? W_PC + 8 : `Unused;

    HD hd(
        .Rs_Tuse(D_Rs_Tuse),
        .Rs_Addr(D_RS_Addr),
        .Rt_Tuse(D_Rt_Tuse),
        .Rt_Addr(D_RT_Addr),
        .E_Tnew(E_Tnew),
        .E_Reg_WA(E_Reg_WA),
        .M_Tnew(M_Tnew),
        .M_Reg_WA(M_Reg_WA),
        .stall(stall)
    );

    wire [31:0] F_PC;
    wire [31:0] F_Inst;
    wire [31:0] D_NPC;

    PC pc(
        .clk(clk),
        .rst(F_rst),
        .WE(F_WE),
        .NPC(D_NPC),
        .PC(F_PC)
    );
    IM im(
        .PC(F_PC),
        .Instruction(F_Inst)
    );

    wire [31:0] D_PC;
    wire [31:0] D_Inst;

    D_Reg d_reg(
        .clk(clk),
        .rst(D_rst),
        .WE(D_WE),
        .F_PC(F_PC),
        .F_Inst(F_Inst),
        .D_PC(D_PC),
        .D_Inst(D_Inst)
    );

    // From instruction
    wire [4:0] D_RS_Addr   = D_Inst[25:21];
    wire [4:0] D_RT_Addr = D_Inst[20:16];
    wire [4:0] D_RD_Addr = D_Inst[15:11];
    wire [15:0] D_Imm16    = D_Inst[15:0];
    wire [25:0] D_Imm26    = D_Inst[25:0];
    wire [4:0] D_Shamt   = D_Inst[10:6];

    
    // From Controller
    wire [4:0] D_CMPOp;
    wire [1:0] D_ExtOp;
    wire [1:0] D_nPC_sel;
    wire [1:0] D_Rs_Tuse;
    wire [1:0] D_Rt_Tuse;

    wire D_ALU_B_sel;
    wire D_ALU_Shift_sel;
    wire [4:0] D_ALUOp;

    wire D_DM_WE;
    wire [1:0] D_DM_Align;
    wire D_DM_Sign;

    wire D_Reg_WE;
    wire [1:0] D_Reg_WA_sel;
    wire [4:0] D_Reg_WA;
    wire [1:0] D_Reg_WD_sel;

    wire [1:0] D_Tnew;


    // Forward
    wire [31:0]  FWD_D_RS;
    wire [31:0]  FWD_D_RT;

    assign FWD_D_RS =
        (D_RS_Addr == 0) ? 0 :
        (D_RS_Addr == E_Reg_WA) ? E_Reg_WD :
        (D_RS_Addr == M_Reg_WA) ? M_Reg_WD : D_RS;
    assign FWD_D_RT =
        (D_RT_Addr == 0) ? 0 :
        (D_RT_Addr == E_Reg_WA) ? E_Reg_WD :
        (D_RT_Addr == M_Reg_WA) ? M_Reg_WD : D_RT;

    Controller controller(
        .Instruction(D_Inst),

        .CMPOp(D_CMPOp),
        .ExtOp(D_ExtOp),
        .nPC_sel(D_nPC_sel),
        
        .ALUOp(D_ALUOp),
        .ALU_B_sel(D_ALU_B_sel),
        .ALU_Shift_sel(D_ALU_Shift_sel),

        .DM_WE(D_DM_WE),
        .DM_Align(D_DM_Align),
        .DM_Sign(D_DM_Sign),

        .Reg_WE(D_Reg_WE),
        .Reg_WA_sel(D_Reg_WA_sel),
        .Reg_WD_sel(D_Reg_WD_sel),

        .Tnew(D_Tnew),
        .Rs_Tuse(D_Rs_Tuse),
        .Rt_Tuse(D_Rt_Tuse)
    );

    assign D_Reg_WA = ( D_Reg_WA_sel == `Reg_WA_RD ) ? D_RD_Addr :
                      ( D_Reg_WA_sel == `Reg_WA_RT ) ? D_RT_Addr : 
                      ( D_Reg_WA_sel == `Reg_WA_31 ) ? 5'h1F : 0;

    wire [31:0] D_Imm32; // Pass to E
    Ext ext(
        .Imm16(D_Imm16),
        .Type(D_ExtOp),
        .Imm32(D_Imm32)
    );

    wire D_Zero;
    CMP cmp(
        .A(FWD_D_RS),
        .B(FWD_D_RT),
        .CMPOp(D_CMPOp),
        .Zero(D_Zero)
    );
    NPC npc(
        .F_PC(F_PC),
        .D_PC(D_PC),
        .Imm26(D_Imm26),
        .nPC_sel(D_nPC_sel),
        .Zero(D_Zero),
        .JumpReg(FWD_D_RS),
        .NPC(D_NPC)
    );

    wire [4:0] W_Reg_WA;
    wire W_Reg_WE; 
    wire [31:0] D_RS; // Pass to E
    wire [31:0] D_RT; // Pass to M
    GRF grf(
        .clk(clk),
        .rst(reset),
        .PC(W_PC),
        .RS_Addr(D_RS_Addr),
        .RT_Addr(D_RT_Addr),
        .WA(W_Reg_WA),
        .WE(W_Reg_WE),
        .WD(W_Reg_WD),
        .RS(D_RS),
        .RT(D_RT)
    );

    wire [31:0] E_PC;
    wire [1:0] E_Tnew;
    
    wire [4:0] E_RS_Addr;
    wire [31:0] E_RS;
    wire [31:0] E_Imm32;
    wire [4:0] E_Shamt;
    wire E_ALU_B_sel;
    wire E_ALU_Shift_sel;
    wire [4:0] E_ALUOp;

    wire [4:0] E_RT_Addr;
    wire [31:0] E_RT;
    wire E_DM_WE;
    wire [1:0] E_DM_Align;
    wire E_DM_Sign;

    wire E_Reg_WE;
    wire [4:0] E_Reg_WA;
    wire [1:0] E_Reg_WD_sel;

    E_Reg e_reg(
        .clk(clk),
        .rst(E_rst),
        .WE(E_WE),
        
        .D_PC(D_PC),
        .D_Tnew(D_Tnew),
        
        .D_RS_Addr(D_RS_Addr),
        .D_RS(FWD_D_RS),
        .D_Imm32(D_Imm32),
        .D_Shamt(D_Shamt),
        .D_ALU_B_sel(D_ALU_B_sel),
        .D_ALU_Shift_sel(D_ALU_Shift_sel),
        .D_ALUOp(D_ALUOp),

        .D_RT_Addr(D_RT_Addr),
        .D_RT(FWD_D_RT),
        .D_DM_WE(D_DM_WE),
        .D_DM_Align(D_DM_Align),
        .D_DM_Sign(D_DM_Sign),

        .D_Reg_WE(D_Reg_WE),
        .D_Reg_WA(D_Reg_WA),
        .D_Reg_WD_sel(D_Reg_WD_sel),

        .E_PC(E_PC),
        .E_Tnew(E_Tnew),

        .E_RS_Addr(E_RS_Addr),
        .E_RS(E_RS),
        .E_Imm32(E_Imm32),
        .E_Shamt(E_Shamt),
        .E_ALU_B_sel(E_ALU_B_sel), 
        .E_ALU_Shift_sel(E_ALU_Shift_sel),
        .E_ALUOp(E_ALUOp),

        .E_RT_Addr(E_RT_Addr),
        .E_RT(E_RT),
        .E_DM_WE(E_DM_WE),
        .E_DM_Align(E_DM_Align),
        .E_DM_Sign(E_DM_Sign),

        .E_Reg_WE(E_Reg_WE),
        .E_Reg_WA(E_Reg_WA),
        .E_Reg_WD_sel(E_Reg_WD_sel)
    );

    // Forward
    wire [31:0] FWD_E_RS;
    wire [31:0] FWD_E_RT;

    assign FWD_E_RS =
        (E_RS_Addr == 0) ? 0 :
        (E_RS_Addr == M_Reg_WA) ? M_Reg_WD :
        (E_RS_Addr == W_Reg_WA) ? W_Reg_WD : E_RS;
    assign FWD_E_RT =
        (E_RT_Addr == 0) ? 0 :
        (E_RT_Addr == M_Reg_WA) ? M_Reg_WD :
        (E_RT_Addr == W_Reg_WA) ? W_Reg_WD : E_RT;

    wire [31:0] E_ALU_A = FWD_E_RS;
    wire [31:0] E_ALU_B = (E_ALU_B_sel == `ALU_B_RT) ? FWD_E_RT :
                        (E_ALU_B_sel == `ALU_B_Imm) ? E_Imm32 : `Unused;
    wire [4:0] E_ALU_Shift = (E_ALU_Shift_sel == `ALU_Shift_shamt) ? E_Shamt :
                           (E_ALU_Shift_sel == `ALU_Shift_RS) ? FWD_E_RS[4:0] : `Unused;

    wire [31:0] E_ALURes; // Pass to W
    ALU alu(
        .A(E_ALU_A),
        .B(E_ALU_B),
        .Shift(E_ALU_Shift),
        .ALUOp(E_ALUOp),
        .ALURes(E_ALURes)
    );

    wire [31:0] M_PC;
    wire [1:0] M_Tnew;

    wire [4:0] M_RT_Addr;
    wire [31:0] M_RT;
    wire M_DM_WE;
    wire [1:0] M_DM_Align;
    wire M_DM_Sign;

    wire [31:0] M_ALURes;
    wire M_Reg_WE;
    wire [4:0] M_Reg_WA;
    wire [1:0] M_Reg_WD_sel;

    M_Reg m_reg(
        .clk(clk),
        .rst(M_rst),
        .WE(M_WE),

        .E_PC(E_PC),
        .E_Tnew(E_Tnew),

        .E_RT_Addr(E_RT_Addr),
        .E_RT(FWD_E_RT),
        .E_DM_WE(E_DM_WE),
        .E_DM_Align(E_DM_Align),
        .E_DM_Sign(E_DM_Sign),

        .E_ALURes(E_ALURes),
        .E_Reg_WE(E_Reg_WE),
        .E_Reg_WA(E_Reg_WA),
        .E_Reg_WD_sel(E_Reg_WD_sel),

        .M_PC(M_PC),
        .M_Tnew(M_Tnew),

        .M_RT_Addr(M_RT_Addr),
        .M_RT(M_RT),
        .M_DM_WE(M_DM_WE),
        .M_DM_Align(M_DM_Align),
        .M_DM_Sign(M_DM_Sign),

        .M_ALURes(M_ALURes),
        .M_Reg_WE(M_Reg_WE),
        .M_Reg_WA(M_Reg_WA),
        .M_Reg_WD_sel(M_Reg_WD_sel)
    );

    // Forward
    wire [31:0] FWD_M_RT;

    assign FWD_M_RT =
        (M_RT_Addr == 0) ? 0 :
        (M_RT_Addr == W_Reg_WA) ? W_Reg_WD : M_RT;

    wire [31:0] M_DM_RD; // Pass to W
    DM dm(
        .clk(clk),
        .rst(reset),
        .PC(M_PC),
        .Addr(M_ALURes),
        .WE(M_DM_WE),
        .Align(M_DM_Align),
        .Sign(M_DM_Sign),
        .WD(FWD_M_RT),
        .RD(M_DM_RD)
    );

    wire [31:0] W_PC;

    wire [31:0] W_ALURes;
    wire [31:0] W_DM_RD;
    wire [1:0] W_Reg_WD_sel;

    W_Reg w_reg(
        .clk(clk),
        .rst(W_rst),
        .WE(W_WE),

        .M_PC(M_PC),

        .M_ALURes(M_ALURes),
        .M_DM_RD(M_DM_RD),
        .M_Reg_WE(M_Reg_WE),
        .M_Reg_WA(M_Reg_WA),
        .M_Reg_WD_sel(M_Reg_WD_sel),

        .W_PC(W_PC),

        .W_ALURes(W_ALURes),
        .W_DM_RD(W_DM_RD),
        .W_Reg_WE(W_Reg_WE),
        .W_Reg_WA(W_Reg_WA),
        .W_Reg_WD_sel(W_Reg_WD_sel)
    );



endmodule
