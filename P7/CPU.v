`include "Defines.v"

module CPU(
    input wire clk,
    input wire reset,
    input wire [31:0] i_inst_rdata,
    input wire int_peri,
    input wire int_t0,
    input wire int_t1,
    output wire [31:0] i_inst_addr,
    output wire [31:0] PrAddr,
    output wire [31:0] PrWD,
    input wire [31:0] PrRD,
    output wire [3:0] PrByteen,
    output wire [31:0] m_inst_addr,
    output wire w_grf_we,
    output wire [4:0] w_grf_addr,
    output wire [31:0] w_grf_wdata,
    output wire [31:0] w_inst_addr,
    output wire [31:0] macroscopic_pc
);
    wire stall;

    wire F_WE = !stall;
    wire D_WE = !stall;
    wire E_WE = `Enabled;
    wire M_WE = `Enabled;
    wire W_WE = `Enabled;

    wire [31:0] E_Reg_WD;
    wire [31:0] M_Reg_WD;
    wire [31:0] W_Reg_WD;
    
    assign E_Reg_WD =
        //(E_Reg_WD_sel == `Reg_WD_ALU) ? E_ALURes :
        //(E_Reg_WD_sel == `Reg_WD_HILO)? E_MulDiv_Out :
        //(E_Reg_WD_sel == `Reg_WD_DM) ? E_DM_WD :
        (E_Reg_WD_sel == `Reg_WD_PC_8) ? E_PC + 8 : `Unused;
    assign M_Reg_WD =
        (M_Reg_WD_sel == `Reg_WD_ALU) ? M_ALURes :
        (M_Reg_WD_sel == `Reg_WD_HILO)? M_MulDiv_Out :
        //(M_Reg_WD_sel == `Reg_WD_DM) ? M_DM_WD :
        (M_Reg_WD_sel == `Reg_WD_PC_8) ? M_PC + 8 : `Unused;
    assign W_Reg_WD =
        (W_Reg_WD_sel == `Reg_WD_ALU) ? W_ALURes :
        (W_Reg_WD_sel == `Reg_WD_HILO)? W_MulDiv_Out :
        (W_Reg_WD_sel == `Reg_WD_DM) ? W_DM_RD :
        (W_Reg_WD_sel == `Reg_WD_PC_8) ? W_PC + 8 :
        (W_Reg_WD_sel == `Reg_WD_CP0) ? W_CP0Out : `Unused;


    wire [4:0] F_ExcCode, D_ExcCode, E_ExcCode, M_ExcCode, D_ExcCode_old, E_ExcCode_old, M_ExcCode_old; 
    wire F_Exc_AdEL, D_Exc_RI, D_Exc_Syscall, E_Exc_Ov, E_Exc_Ov_DM, M_Exc_Ov_DM, M_Exc_AdEL, M_Exc_AdES;
    wire F_bd, D_bd, E_bd, M_bd;
    wire D_eret, E_eret, M_eret;
    wire [31:0] EPC;
    assign macroscopic_pc = M_PC;
    wire req;

    assign F_ExcCode = F_Exc_AdEL ? `AdEL :
                       `Unused;
    assign D_ExcCode = D_ExcCode_old ? D_ExcCode_old :
                       D_Exc_RI ? `RI :
                       D_Exc_Syscall ? `Syscall :
                       `Unused;
    assign E_ExcCode = E_ExcCode_old ? E_ExcCode_old :
                       E_Exc_Ov ? `Ov :
                       `Unused;
    assign M_ExcCode = M_ExcCode_old ? M_ExcCode_old :
                       M_Exc_AdEL ? `AdEL :
                       M_Exc_AdES ? `AdES :
                       `Unused;

    assign F_bd = (D_nPC_sel != `NPC_default);


    HD hd(
        .E_CP0_WE(E_CP0_WE),
        .E_RD_Addr(E_RD_Addr),
        .M_CP0_WE(M_CP0_WE),
        .M_RD_Addr(M_RD_Addr),
        .D_eret(D_eret),

        .Rs_Tuse(D_Rs_Tuse),
        .Rs_Addr(D_RS_Addr),
        .Rt_Tuse(D_Rt_Tuse),
        .Rt_Addr(D_RT_Addr),
        .D_MulDivOp(D_MulDivOp),
        .E_Tnew(E_Tnew),
        .E_Reg_WA(E_Reg_WA),
        .E_MulDiv_busy(E_MulDiv_busy),
        .M_Tnew(M_Tnew),
        .M_Reg_WA(M_Reg_WA),
        .stall(stall)
    );

    wire [31:0] F_PC;
    wire [31:0] F_Inst;
    wire [31:0] D_NPC;

    PC pc(
        .req(req),
        .D_eret(D_eret),
        .EPC(EPC),
        .F_Exc_AdEL(F_Exc_AdEL),

        .clk(clk),
        .rst(reset),
        .WE(F_WE),
        .NPC(D_NPC),
        .PC(F_PC)
    );
    

    assign i_inst_addr = F_PC;
    assign F_Inst = F_Exc_AdEL ? 32'h00000000 :
                    i_inst_rdata;

    //wire [255:0] F_ASM;
	//_DASM Dasm(
    //    .pc(F_PC),
    //    .instr(F_Inst),
    //    .imm_as_dec(1'b1),
    //    .reg_name(1'b0),
    //    .asm(F_ASM)
    //);
    wire [31:0] D_PC;
    wire [31:0] D_Inst;

    D_Reg d_reg(
        .req(req),
        .F_ExcCode(F_ExcCode),
        .F_bd(F_bd),

        .D_ExcCode_old(D_ExcCode_old),
        .D_bd(D_bd),

        .clk(clk),
        .rst(reset),
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
    wire [2:0] D_nPC_sel;
    wire [1:0] D_Rs_Tuse;
    wire [1:0] D_Rt_Tuse;

    wire D_ALU_B_sel;
    wire [4:0] D_ALUOp;
    wire [3:0] D_MulDivOp;
    wire D_ALUOv;
    wire D_DM_Ov;

    wire D_DM_RE, E_DM_RE, M_DM_RE;
    wire D_DM_WE;
    wire [2:0] D_DM_Align;
    wire D_CP0_WE;

    wire D_Reg_WE;
    wire [1:0] D_Reg_WA_sel;
    wire [4:0] D_Reg_WA;
    wire [2:0] D_Reg_WD_sel;

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
        .Exc_RI(D_Exc_RI),
        .Exc_Syscall(D_Exc_Syscall),
        
        .ALUOp(D_ALUOp),
        .ALU_B_sel(D_ALU_B_sel),
        .MulDivOp(D_MulDivOp),
        .ALUOv(D_ALUOv),
        .DM_Ov(D_DM_Ov),

        .DM_RE(D_DM_RE),
        .DM_WE(D_DM_WE),
        .DM_Align(D_DM_Align),
        .CP0_WE(D_CP0_WE),
        .eret(D_eret),

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
        .req(req),
        .eret(D_eret),
        .EPC(EPC),

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
    wire [4:0] E_ALUOp;
    wire [3:0] E_MulDivOp;
    wire E_ALUOv;
    wire E_DM_Ov;

    wire [4:0] E_RT_Addr;
    wire [4:0] E_RD_Addr;
    wire [31:0] E_RT;
    wire E_DM_WE;
    wire [2:0] E_DM_Align;
    wire E_CP0_WE;

    wire E_Reg_WE;
    wire [4:0] E_Reg_WA;
    wire [2:0] E_Reg_WD_sel;

    E_Reg e_reg(
        .stall(stall),
        .req(req),
        .D_ALUOv(D_ALUOv),
        .D_DM_Ov(D_DM_Ov),
        .D_ExcCode(D_ExcCode),
        .D_bd(D_bd),
        .E_ALUOv(E_ALUOv),
        .E_DM_Ov(E_DM_Ov),
        .E_ExcCode_old(E_ExcCode_old),
        .E_bd(E_bd),

        .D_DM_RE(D_DM_RE),
        .E_DM_RE(E_DM_RE),

        .clk(clk),
        .rst(reset),
        .WE(E_WE),
        
        .D_PC(D_PC),
        .D_Tnew(D_Tnew),
        
        .D_RS_Addr(D_RS_Addr),
        .D_RS(FWD_D_RS),
        .D_Imm32(D_Imm32),
        .D_Shamt(D_Shamt),
        .D_ALU_B_sel(D_ALU_B_sel),
        .D_ALUOp(D_ALUOp),
        .D_MulDivOp(D_MulDivOp),

        .D_RT_Addr(D_RT_Addr),
        .D_RD_Addr(D_RD_Addr),
        .D_RT(FWD_D_RT),
        .D_DM_WE(D_DM_WE),
        .D_DM_Align(D_DM_Align),
        .D_CP0_WE(D_CP0_WE),
        .D_eret(D_eret),

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
        .E_ALUOp(E_ALUOp),
        .E_MulDivOp(E_MulDivOp),

        .E_RT_Addr(E_RT_Addr),
        .E_RD_Addr(E_RD_Addr),
        .E_RT(E_RT),
        .E_DM_WE(E_DM_WE),
        .E_DM_Align(E_DM_Align),
        .E_CP0_WE(E_CP0_WE),
        .E_eret(E_eret),

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

    wire [31:0] E_ALURes; // Pass to W
    ALU alu(
        .ALUOv(E_ALUOv),
        .DM_Ov(E_DM_Ov),
        .Exc_Ov(E_Exc_Ov),
        .Exc_Ov_DM(E_Exc_Ov_DM),
        .A(E_ALU_A),
        .B(E_ALU_B),
        .ALUOp(E_ALUOp),
        .ALURes(E_ALURes)
    );

    wire [31:0] E_MulDiv_Out; // Pass to W
    wire E_MulDiv_busy;

    MulDiv muldiv(
        .req(req),

        .clk(clk),
        .rst(reset),
        .Op(E_MulDivOp),
        .RS(FWD_E_RS),
        .RT(FWD_E_RT),
        .busy(E_MulDiv_busy),
        .Out(E_MulDiv_Out)
    );

    wire [31:0] M_PC;
    wire [1:0] M_Tnew;

    wire [4:0] M_RT_Addr;
    wire [4:0] M_RD_Addr;
    wire [31:0] M_RT;
    wire M_DM_WE;
    wire [2:0] M_DM_Align;
    wire M_CP0_WE;

    wire [31:0] M_ALURes;
    wire [31:0] M_MulDiv_Out;
    wire M_Reg_WE;
    wire [4:0] M_Reg_WA;
    wire [2:0] M_Reg_WD_sel;

    M_Reg m_reg(
        .req(req),
        .E_ExcCode(E_ExcCode),
        .E_bd(E_bd),
        .E_Exc_Ov_DM(E_Exc_Ov_DM),

        .M_ExcCode_old(M_ExcCode_old),
        .M_bd(M_bd),
        .M_Exc_Ov_DM(M_Exc_Ov_DM),

        .E_DM_RE(E_DM_RE),
        .M_DM_RE(M_DM_RE),

        .clk(clk),
        .rst(reset),
        .WE(M_WE),

        .E_PC(E_PC),
        .E_Tnew(E_Tnew),

        .E_RT_Addr(E_RT_Addr),
        .E_RD_Addr(E_RD_Addr),
        .E_RT(FWD_E_RT),
        .E_DM_WE(E_DM_WE),
        .E_DM_Align(E_DM_Align),
        .E_CP0_WE(E_CP0_WE),
        .E_eret(E_eret),

        .E_ALURes(E_ALURes),
        .E_MulDiv_Out(E_MulDiv_Out),
        .E_Reg_WE(E_Reg_WE),
        .E_Reg_WA(E_Reg_WA),
        .E_Reg_WD_sel(E_Reg_WD_sel),

        .M_PC(M_PC),
        .M_Tnew(M_Tnew),

        .M_RT_Addr(M_RT_Addr),
        .M_RD_Addr(M_RD_Addr),
        .M_RT(M_RT),
        .M_DM_WE(M_DM_WE),
        .M_DM_Align(M_DM_Align),
        .M_CP0_WE(M_CP0_WE),
        .M_eret(M_eret),

        .M_ALURes(M_ALURes),
        .M_MulDiv_Out(M_MulDiv_Out),
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
        .req(req),
        .RE(M_DM_RE),
        .Exc_Ov_DM(M_Exc_Ov_DM),
        .Exc_AdEL(M_Exc_AdEL),
        .Exc_AdES(M_Exc_AdES),

        .PC(M_PC),
        .Addr(M_ALURes),
        .WE(M_DM_WE),
        .Align(M_DM_Align),
        .WD(FWD_M_RT),
        .m_data_rdata(PrRD),
        .m_data_addr(PrAddr),
        .m_data_wdata(PrWD),
        .m_data_byteen(PrByteen),
        .m_inst_addr(m_inst_addr),
        .RD(M_DM_RD)
    );


    wire [31:0] M_CP0Out; // Pass to W
    wire [5:0] HWInt = {3'b0, int_peri, int_t1, int_t0};
    CP0 cp0(
        .clk(clk),
        .rst(reset),
        .WE(M_CP0_WE),
        .InAddr(M_RD_Addr),
        .OutAddr(M_RD_Addr),
        .InData(FWD_M_RT),
        .OutData(M_CP0Out),
        .VPC(M_PC),
        .BDIn(M_bd),
        .ExcCodeIn(M_ExcCode),
        .HWInt(HWInt),
        .EXLClr(M_eret),
        .EPCOut(EPC),
        .req(req)
    );


    wire [31:0] W_PC;

    wire [31:0] W_ALURes;
    wire [31:0] W_MulDiv_Out;
    wire [31:0] W_DM_RD;
    wire [2:0] W_Reg_WD_sel;
    wire [31:0] W_CP0Out;

    W_Reg w_reg(
        .req(req),

        .clk(clk),
        .rst(reset),
        .WE(W_WE),

        .M_PC(M_PC),

        .M_ALURes(M_ALURes),
        .M_MulDiv_Out(M_MulDiv_Out),
        .M_DM_RD(M_DM_RD),
        .M_Reg_WE(M_Reg_WE),
        .M_Reg_WA(M_Reg_WA),
        .M_Reg_WD_sel(M_Reg_WD_sel),
        .M_CP0Out(M_CP0Out),

        .W_PC(W_PC),

        .W_ALURes(W_ALURes),
        .W_MulDiv_Out(W_MulDiv_Out),
        .W_DM_RD(W_DM_RD),
        .W_Reg_WE(W_Reg_WE),
        .W_Reg_WA(W_Reg_WA),
        .W_Reg_WD_sel(W_Reg_WD_sel),
        .W_CP0Out(W_CP0Out)
    );

    // For judger
    assign w_grf_we = W_Reg_WE;
    assign w_grf_addr = W_Reg_WA;
    assign w_grf_wdata = W_Reg_WD;
    assign w_inst_addr = W_PC;

endmodule
