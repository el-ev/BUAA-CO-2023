`define Begin_DM 32'h00000000
`define End_DM   32'h00002fff
`define Begin_TC0 32'h00007f00
`define End_TC0   32'h00007f0b
`define Begin_TC1 32'h00007f10
`define End_TC1   32'h00007f1b
`define Begin_Pr  32'h00007f20
`define End_Pr    32'h00007f23

module mips(
    input wire clk,                    
    input wire reset,                  
    input wire interrupt,              
    output wire  [31:0] macroscopic_pc, 
 
    output wire  [31:0] i_inst_addr,    
    input  wire  [31:0] i_inst_rdata,   
 
    output wire  [31:0] m_data_addr,    
    input  wire  [31:0] m_data_rdata,   
    output wire  [31:0] m_data_wdata,   
    output wire  [3 :0] m_data_byteen,  
 
    output wire  [31:0] m_int_addr,     
    output wire  [3 :0] m_int_byteen,   
 
    output wire  [31:0] m_inst_addr,    
 
    output wire  w_grf_we,              
    output wire  [4 :0] w_grf_addr,     
    output wire  [31:0] w_grf_wdata,    
 
    output wire  [31:0] w_inst_addr     
);

    wire [31:0] PrAddr, PrWD, PrRD;
    wire [3:0] PrByteen;
    CPU cpu(
        .clk(clk),
        .reset(reset),
        .macroscopic_pc(macroscopic_pc),

        .i_inst_addr(i_inst_addr),
        .i_inst_rdata(i_inst_rdata),

        .PrAddr(PrAddr),
        .PrWD(PrWD),
        .PrRD(PrRD),
        .PrByteen(PrByteen),

        .m_inst_addr(m_inst_addr),

        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),
        .w_inst_addr(w_inst_addr),

        .int_peri(interrupt),
        .int_t0(IRQ0),
        .int_t1(IRQ1)
    );

    wire mem = (PrAddr >= `Begin_DM) & (PrAddr <= `End_DM),
         tc0 = (PrAddr >= `Begin_TC0) & (PrAddr <= `End_TC0),
         tc1 = (PrAddr >= `Begin_TC1) & (PrAddr <= `End_TC1),
         pr  = (PrAddr >= `Begin_Pr) & (PrAddr <= `End_Pr);
    
    assign m_data_addr = PrAddr;
    assign m_data_wdata = PrWD;
    assign m_data_byteen = {4{mem}} & PrByteen;

    assign m_int_addr = PrAddr;
    assign m_int_byteen = {4{pr}} & PrByteen;

    assign PrRD = mem ? m_data_rdata :
                  tc0 ? TC0_Out :
                  tc1 ? TC1_Out :
                  0;

    wire TC0_WE = tc0 && (PrByteen != 0);
    wire TC1_WE = tc1 && (PrByteen != 0);
    wire IRQ0, IRQ1;
    wire [31:0] TC0_Out, TC1_Out;
    TC _tc0(
        .clk(clk),
        .reset(reset),
        .Addr(PrAddr[31:2]),
        .WE(TC0_WE),
        .Din(PrWD),
        .Dout(TC0_Out),
        .IRQ(IRQ0)
    );
    TC _tc1(
        .clk(clk),
        .reset(reset),
        .Addr(PrAddr[31:2]),
        .WE(TC1_WE),
        .Din(PrWD),
        .Dout(TC1_Out),
        .IRQ(IRQ1)
    );
endmodule