`timescale 100fs/100fs

// MEM/WB flip flop
module  MEM_WB_Register(  input RegWriteM
                        , input MemtoRegM
                        , input JumpLinkM
                        , input [31:0] ALUOutM
                        , input [31:0] ReadDataM
                        , input [4:0]  WriteRegM
                        , input [31:0] PCPlus4M
                        , input CLK
                        , output reg RegWriteW
                        , output reg MemtoRegW
                        , output reg [31:0] ALUOutW
                        , output reg [31:0] ReadDataW
                        , output reg [4:0] WriteRegW
                        , output reg JumpLinkW
                        , output reg [31:0] PCPlus4W
                        );

    initial begin
        JumpLinkW <= 1'b0;
    end

    always @(posedge CLK) begin
        
        RegWriteW <=  RegWriteM;
        MemtoRegW <=  MemtoRegM;
        ALUOutW   <=  ALUOutM;
        ReadDataW <=  ReadDataM;
        WriteRegW <=  WriteRegM;
        JumpLinkW <=  JumpLinkM;
        PCPlus4W  <=  PCPlus4M;
        
    end

endmodule