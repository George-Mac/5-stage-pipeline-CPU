
// This module is used to calculate the SignExtendImm or ZeorExtendImm
module ExtendUnit ( input  [15:0] in
                      , input  [5:0] OpCode
                      , output reg [31:0] out
                      );
    

    always @(in or OpCode) begin
        if ((OpCode==6'b001101) || (OpCode==6'b001110)) begin
            out <= {{16{1'b0}}, in};  // zero extend
        end
        else out <= {{16{in[15]}}, in}; // sign extend
    end
    
endmodule