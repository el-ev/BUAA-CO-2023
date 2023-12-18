`include "Defines.v"

module MulDiv (
    input wire req,
    input wire clk,
    input wire rst,
    input wire [3:0] Op,
    input wire [31:0] RS,
    input wire [31:0] RT,
    output wire busy,
    output wire [31:0] Out
);
    /*
        Multiply and Divide Unit
        Operations:
        MD_Mult   : mult
        MD_Multu  : multu 
        MD_Div    : div
        MD_Divu   : divu
        MD_Mflo   : mflo
        MD_Mfhi   : mfhi
        MD_Mtlo   : mtlo
        MD_Mthi   : mthi
        Multilpy busy for 5 cycles, divide busy for 10 cycles
    */
    wire start;
    reg [31:0] HI, LO, t_HI, t_LO;
    reg [3:0] busyCounter;

    assign start = (Op == `MD_Mult) || (Op == `MD_Multu) || (Op == `MD_Div) || (Op == `MD_Divu);
    assign busy = (busyCounter != 0) || start;
    assign Out = (Op == `MD_Mflo) ? LO:
                 (Op == `MD_Mfhi) ? HI:
                 32'b0;

    initial begin
        busyCounter = 0;
        HI = 0;
        LO = 0;
        t_HI = 0;
        t_LO = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            busyCounter <= 0;
            HI <= 0;
            LO <= 0;
        end else if (!req) begin
            if (!busyCounter) begin
                if (Op == `MD_Mtlo) LO <= RS;
                else if (Op == `MD_Mthi) HI <= RS;
                else if (Op == `MD_Mult) begin
                    busyCounter <= 5;
                    {t_HI, t_LO} <= $signed(RS) * $signed(RT);
                end
                else if (Op == `MD_Multu) begin
                    busyCounter <= 5;
                    {t_HI, t_LO} <= RS * RT;
                end
                else if (Op == `MD_Div) begin
                    busyCounter <= 10;
                    t_HI <= $signed(RS) % $signed(RT);
                    t_LO <= $signed(RS) / $signed(RT);
                end
                else if (Op == `MD_Divu) begin
                    busyCounter <= 10;
                    t_HI <= RS % RT;
                    t_LO <= RS / RT;
                end
            end
            else if (busyCounter == 4'd1) begin
                LO <= t_LO;
                HI <= t_HI;
                busyCounter <= 0;
            end
            else begin
                busyCounter <= busyCounter - 1;
            end
        end
    end
endmodule