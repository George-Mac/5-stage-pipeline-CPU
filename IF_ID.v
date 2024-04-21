`timescale 100fs/100fs

// IF/IF flip flop
module  IF_ID_Register ( input [31:0] instruction_in
                       , input [31:0] PCPlus4F
                       , input CLK
                       , input ENABLE
                       , output reg [31:0] PCPlus4D
                       , output reg [31:0] instruction_out
                        );

    initial begin
        PCPlus4D <= 32'b0;
        instruction_out <= 32'b0;
    end


    always @(posedge CLK) begin
        // clear the flip flop
        if(!ENABLE) begin
            instruction_out = instruction_in;
            PCPlus4D = PCPlus4F;
        end

        else begin
            instruction_out = 32'b0;
            PCPlus4D = PCPlus4F;
        end

        
    end
                
    endmodule