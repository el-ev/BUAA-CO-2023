`include "Defines.v"

module DM(
    input wire          clk         ,
    input wire          rst         ,
    input wire [31:0]   PC          ,
    input wire [31:0]   Addr        ,
    input wire          WE          ,
    input wire [1:0]    Align       ,
    input wire          Sign        ,
    input wire [31:0]   WD          ,
    output reg [31:0]   RD
);
    /*
        Data Memory
        Align:
            00: Word
            01: Halfword
            10: Byte
            11: Reserved
        Sign(for read):
            0: Unsigned
            1: Signed
    */
    reg     [31:0]   memory [0:3071]                    ;
    wire    [11:0]   _addr                              ;
    wire    [15:0]   WD_Half                            ;
    wire    [7:0]    WD_Byte                            ;
    wire             _word, _half, _byte                ;
    wire             H_0,H_1,B_0,B_1,B_2,B_3            ;
    integer          i                                  ;

    assign _addr     = Addr[13:2]                       ;
    assign WD_Half  = WD[15:0]                          ;
    assign WD_Byte  = WD[7:0]                           ;
    assign _word     = (Align == `DM_align_word)        ;
    assign _half     = (Align == `DM_align_half)        ;
    assign _byte     = (Align == `DM_align_byte)        ;
    assign H_0      = (Addr[1] == 0) & (Addr[0] == 0)   ;
    assign H_1      = (Addr[1] == 1) & (Addr[0] == 0)   ;      
    assign B_0      = (Addr[1] == 0) & (Addr[0] == 0)   ;
    assign B_1      = (Addr[1] == 0) & (Addr[0] == 1)   ;
    assign B_2      = (Addr[1] == 1) & (Addr[0] == 0)   ;
    assign B_3      = (Addr[1] == 1) & (Addr[0] == 1)   ;

    initial begin
        for (i = 0; i < 3072; i = i + 1) begin
            memory[i] = 0;
        end
    end
    //Read
    always @(*) begin
        if (_word) begin
            RD = memory[_addr];
        end
        else if (_half) begin
            if (H_0) begin
                if (!Sign) RD = {16'b0,memory[_addr][15:0]};
                else RD = {{16{memory[_addr][15]}},memory[_addr][15:0]};
            end
            else if (H_1) begin
                if (!Sign) RD = {16'b0,memory[_addr][31:16]};
                else RD = {{16{memory[_addr][31]}},memory[_addr][31:16]};
            end
            else begin
                RD = 8'b00000000;
            end
        end
        else if (_byte) begin
            if (B_0) begin
                if (!Sign) RD = {24'b0,memory[_addr][7:0]};
                else RD = {{24{memory[_addr][7]}},memory[_addr][7:0]};
            end
            else if (B_1) begin
                if (!Sign) RD = {24'b0,memory[_addr][15:8]};
                else RD = {{24{memory[_addr][15]}},memory[_addr][15:8]};
            end
            else if (B_2) begin
                if (!Sign) RD = {24'b0,memory[_addr][23:16]};
                else RD = {{24{memory[_addr][23]}},memory[_addr][23:16]};
            end
            else if (B_3) begin
                if (!Sign) RD = {24'b0,memory[_addr][31:24]};
                else RD = {{24{memory[_addr][31]}},memory[_addr][31:24]};
            end
            else begin
                RD = 8'b00000000;
            end
        end
        else begin
            RD = 8'b00000000;
        end
    end
    //Write
    always @(posedge clk) begin
        if (rst) begin 
            for (i = 0; i < 3072; i = i + 1) begin
                memory[i] <= 0;
            end
        end
        else begin
            if (WE) begin
                if (_word) begin
                    memory[_addr ] <= WD;
                    $display("%d@%h: *%h <= %h", $time, PC, Addr, WD);
                end
                else if (_half) begin
                    if (H_0) memory[_addr] <= {memory[_addr ][31:16],WD_Half};
                    else if (H_1) memory[_addr ] <= {WD_Half,memory[_addr ][15:0]};
                    $display("%d@%h: *%h <= %h", $time, PC, Addr, WD_Half);
                end
                else if (_byte) begin
                    if (B_0) memory[_addr] <= {memory[_addr][31:8],WD_Byte};
                    else if (B_1) memory[_addr] <= {memory[_addr][31:16],WD_Byte,memory[_addr][7:0]};
                    else if (B_2) memory[_addr] <= {memory[_addr][31:24],WD_Byte,memory[_addr][15:0]};
                    else if (B_3) memory[_addr] <= {WD_Byte,memory[_addr][23:0]};
                    $display("%d@%h: *%h <= %h", $time, PC, Addr, WD_Byte);
                end
                else begin
                    memory[_addr ] <= WD;
                    $display("%d@%h: *%h <= %h", $time, PC, Addr, WD);
                end
            end
        end
    end
    
endmodule