`timescale 100fs/100fs

// This file contains some kinds of multiplexer

module Mux2to1_32bit( input  [31:0] din_0
                    , input  [31:0] din_1
                    , input         sel
                    , output reg [31:0] out
                    );

    always @(din_0 or din_1 or sel) begin
        if (sel==1'b0)  out<=din_0;
        else out<=din_1;
    end

endmodule

module Mux2to1_5bit( input  [4:0]  din_0
                   , input  [4:0]  din_1
                   , input         sel
                   , output reg [4:0]  out
                   );


    always @(din_0 or din_1 or sel) begin
        if (sel==1'b0)  out<=din_0;
        else out<=din_1;
    end

endmodule

module Mux3to1_32bit( input  [31:0] din_0
                    , input  [31:0] din_1
                    , input  [31:0] din_2
                    , input  [1:0]  sel
                    , output reg [31:0] out
                    );

    always @(din_0 or din_1 or din_2 or sel) begin
        case (sel)
            2'b00: out <= din_0;
            2'b01: out <= din_1;
            2'b10: out <= din_2;
        endcase
    end
    
endmodule

module Mux4to1_32bit( input  [31:0] din_0
                    , input  [31:0] din_1
                    , input  [31:0] din_2
                    , input  [31:0] din_3
                    , input  [1:0]  sel
                    , output reg [31:0] out
                    );

    always @(din_0 or din_1 or din_2 or din_3 or sel) begin
        case (sel)
            2'b00: out <= din_0;
            2'b01: out <= din_1;
            2'b10: out <= din_2;
            2'b11: out <= din_3;
        endcase
    end
    
endmodule




