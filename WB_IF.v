`timescale 100fs/100fs

// WB/IF flip flop
module WB_IF_Register( input [31:0] PCPrime
                    , input CLK
                    , input enable
                    , output reg [31:0] PCF
                    );

    initial begin
        PCF <= 32'b0;
    end
    
    always @(posedge CLK) begin
        if (!enable) begin
            PCF <= PCPrime;
        end
        
    end

endmodule