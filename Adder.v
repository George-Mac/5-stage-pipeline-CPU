module Adder( input  [31:0] din_0
            , input  [31:0] din_1
            , output [31:0] sum_out
            );

    assign sum_out = din_0 + din_1;

endmodule

module Adder_4( input [31:0] din
              , output [31:0] sum_out
            );

    assign sum_out = din + 4;
    
endmodule