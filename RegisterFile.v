`timescale 100fs/100fs

// This module is used to stored, written and output the value of registers
module RegisterFile( input [4:0] A1
                   , input [4:0] A2
                   , input [4:0] A3
                   , input [31:0] WD3
                   , input  RegWrite
                   , input CLK
                   , output [31:0] RD1
                   , output [31:0] RD2
                   );
    
    integer i;

    reg signed [31:0] RegisterValue [31:0];
    
    initial begin
        for (i=0; i<32; i=i+1) begin
            RegisterValue[i] <= 32'b0;
        end
    end
    
    assign RD1=RegisterValue[(A1)];
    assign RD2=RegisterValue[(A2)];

    always @(RegWrite or A3 or WD3 ) begin
        if ((RegWrite==1) && (A3!=5'b00000)) 
            RegisterValue[(A3)] = WD3;
    end

endmodule