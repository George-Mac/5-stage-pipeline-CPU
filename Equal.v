`timescale 100fs/100fs

// module CheckEqual( input  [31:0] din_0
                //  , input  [31:0] din_1
                //  , output  d_out
                //  );
// 
    // assign d_out = (din_0==din_1) ? 1:0;
    // 
// endmodule

// This module is used to check wether two data are equal
module CheckEqual( input  [31:0] din_0
                 , input  [31:0] din_1
                 , input  Bne
                 , output  reg d_out
                 );

    initial begin
        d_out <= 1'b0;
    end

    always @(din_0 or din_1 or Bne) begin
        if (Bne==1'b1) begin
            d_out <= (din_0!=din_1) ? 1:0;
        end
        else d_out <= (din_0==din_1) ? 1:0;
    end
    
endmodule