`timescale 100fs/100fs

// EX/MEM flip flop
module EX_MEM_Register( input          RegWriteE
                      , input          MemtoRegE
                      , input          MemWriteE
                      , input          JumpLinkE
                      , input   [31:0] WriteDataE
                      , input   [31:0] PCPlus4E
                      , input              CLK
                      , input   [4:0]      WriteRegE
                      , input   [31:0]     ALUOutE
                      , output  reg        RegWriteM
                      , output  reg [31:0] WriteDataM
                      , output  reg [31:0] PCPlus4M
                      , output  reg        MemtoRegM
                      , output  reg        MemWriteM
                      , output  reg [4:0]  WriteRegM
                      , output  reg [31:0] ALUOutM
                      , output  reg        JumpLinkM
                      );        
    initial begin
        JumpLinkM <= 1'b0;
    end

    always @(posedge CLK) begin
        
        RegWriteM  <=  RegWriteE;
        WriteDataM <=  WriteDataE;
        MemtoRegM  <=  MemtoRegE;
        MemWriteM  <=  MemWriteE;
        WriteRegM  <=  WriteRegE;
        ALUOutM    <=  ALUOutE;
        JumpLinkM  <=  JumpLinkE;
        PCPlus4M   <=  PCPlus4E;
        
    end

    endmodule