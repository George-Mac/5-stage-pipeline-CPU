`timescale 100fs/100fs

// This module is used to calculate the PC branch address
module BranchAddrUnit ( input  [31:0]  SignImmD
                      , input  [31:0]  PCPlus4D
                      , output [31:0]  PCBranchD
                      );

    assign PCBranchD = PCPlus4D + (SignImmD<<2);
endmodule