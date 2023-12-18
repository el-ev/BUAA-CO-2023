`include "Defines.v"

module CMP (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [4:0] CMPOp,
    output reg Zero
);
    /*
        Supported comparisons:
            `CMP_EQ : Equal
            `CMP_NE : Not Equal
            `CMP_LT : Less Than
            `CMP_LE : Less Than or Equal
            `CMP_GT : Greater Than
            `CMP_GE : Greater Than or Equal
    */
    always @(*) begin
        case (CMPOp)
            `CMP_EQ   :  Zero = A == B;
            `CMP_NE   :  Zero = A != B;
            `CMP_LT   :  Zero = $signed(A) <  $signed(B);
            `CMP_LE   :  Zero = $signed(A) <= $signed(B);
            `CMP_GT   :  Zero = $signed(A) >  $signed(B);
            `CMP_GE   :  Zero = $signed(A) >= $signed(B);
            default   :  Zero = 0;
        endcase
    end
endmodule