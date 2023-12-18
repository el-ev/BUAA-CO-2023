module D_Reg (
    input wire        clk   ,
    input wire        rst   ,
    input wire        WE    ,
    input wire [31:0] F_PC   ,
    input wire [31:0] F_Inst ,
    output reg [31:0] D_PC   ,
    output reg [31:0] D_Inst 
);
    always @(posedge clk ) begin
        if (rst) begin
            D_PC   <= 32'h00003000;
            D_Inst <= 32'h00000000;
        end
        else if (WE) begin
            D_PC   <= F_PC;
            D_Inst <= F_Inst;
        end
    end  
endmodule