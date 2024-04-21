`timescale 100fs/100fs

// ID/EX flip flop
module  ID_EX_Register(  input [31:0] instruction_in   
                       , input [31:0] RD1
                       , input [31:0] RD2
                       , input [31:0] SignImmD
                       , input [4:0]  SaD
                       , input [4:0]  RsD
                       , input [4:0]  RtD
                       , input [4:0]  RdD
                       , input [31:0] PCPlus4D
                       , input RegWriteD
                       , input MemtoRegD
                       , input MemWriteD
                       , input [3:0] ALUControlD
                       , input ALUSrcD
                       , input RegDstD
                       , input JumpLinkD
                       , input CLK
                       , input CLR
                    //    , input CLR
                       , output reg [31:0] RD1_out
                       , output reg [31:0] RD2_out
                       , output reg [31:0] SignImmE
                       , output reg [31:0] PCPlus4E
                       , output reg [4:0] RtE
                       , output reg [4:0] RdE
                       , output reg [4:0] RsE
                       , output reg [4:0] SaE
                       , output reg RegWriteE
                       , output reg MemtoRegE
                       , output reg MemWriteE
                       , output reg [3:0] ALUControlE
                       , output reg ALUSrcE
                       , output reg RegDstE
                       , output reg JumpLinkE
                       );

    initial begin

        RtE          <= 5'b0;
        RdE          <= 5'b0;
        RsE          <= 5'b0;
        SaE          <= 5'b0;
        RD1_out      <= 32'b0;
        RD2_out      <= 32'b0;
        SignImmE     <= 32'b0;
        RegWriteE    <= 1'b0;
        MemtoRegE    <= 1'b0;
        MemWriteE    <= 1'b0;
        ALUControlE  <= 4'b0;
        ALUSrcE      <= 1'b0;
        RegDstE      <= 1'b0;
        JumpLinkE    <= 1'b0;
        // PCPlus4E     <= 32'b0;
    end

    always @(posedge CLK) begin
        if (!CLR) begin
            RtE         <= RtD;
            RdE         <= RdD;
            RsE         <= RsD;
            RD1_out     <= RD1;
            RD2_out     <= RD2;
            SignImmE    <= SignImmD;
            SaE         <= SaD;
            RegWriteE   <= RegWriteD;
            MemtoRegE   <= MemtoRegD;
            MemWriteE   <= MemWriteD;
            ALUControlE <= ALUControlD;
            ALUSrcE     <= ALUSrcD;
            RegDstE     <= RegDstD;
            JumpLinkE   <= JumpLinkD;
            PCPlus4E    <= PCPlus4D;
        end
        else if (CLR) begin
            RtE          <= 5'b0;
            RdE          <= 5'b0;
            RsE          <= 5'b0;
            SaE          <= 5'b0;
            RD1_out      <= 32'b0;
            RD2_out      <= 32'b0;
            SignImmE     <= 32'b0;
            RegWriteE    <= 1'b0;
            MemtoRegE    <= 1'b0;
            MemWriteE    <= 1'b0;
            ALUControlE  <= 4'bxxxx;
            ALUSrcE      <= 1'b0;
            RegDstE      <= 1'b0;
            JumpLinkE    <= 1'b0;
            // PCPlus4E     <= 32'b0;

        end

    end
                
    endmodule