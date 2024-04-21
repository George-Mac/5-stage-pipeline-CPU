`timescale 100fs/100fs

`include "ClockGenerator.v"

`include "InstructionRAM.v"
`include "MainMemory.v"
`include "RegisterFile.v"
`include "ControlUnit.v"
`include "ALU.v"

`include "WB_IF.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"

`include "Adder.v"
`include "Mux.v"
`include "BranchPC.v"
`include "JumpUnit.v"
`include "ExtendImmediate.v"
`include "Equal.v"

`include "HazardUnit.v"


module CPU ();

wire CLK;


Clock_Gnerator Clock( .enable(1'b1)
                    , .CLK(CLK)
                    );

//------------------ Stage 1: Instruction Fetch ----------------------\\

wire [31:0] PCF;
wire [31:0] PCPrime;
wire [31:0] PCPlus4F;
wire [31:0] PCBranchD;
wire [31:0] PCJumpD;

wire PCSrcD,JumpD, JumpRegD;

// Mux2to1_32bit MuxPC( .sel(PCSrcD)
                //    , .din_0(PCPlus4F)
                //    , .din_1(PCBranchD)
                //    , .out(PCPrime)
                //    );

Mux3to1_32bit MuxPC( .din_0(PCPlus4F)
                   , .din_1(PCBranchD)
                   , .din_2(PCJumpD)
                   , .sel({JumpD,PCSrcD})
                   , .out(PCPrime)
                   );

wire ControlEnable, StallF, StallD;
wire [1:0] ForwardAE;
wire [1:0] ForwardBE;
wire [4:0] RtE;
wire [4:0] RdE;
wire [4:0] RsE;
wire RegWriteE, RegWriteW, RegWriteM, MemtoRegM;
wire [4:0] WriteRegW;
wire [4:0] WriteRegE;
wire [4:0] WriteRegM;
wire [4:0] RsD;
wire [4:0] RtD;
wire ForwardAD, ForwardBD;
wire [1:0] ForwardJD;
wire [31:0] ReadDataM;
wire FlushE, JumpRegEnable;

HazardUnit DealHazard( .Branch(PCSrcD)
                     , .Jump(JumpD)
                     , .StallD(StallD)
                     , .JumpReg(JumpRegD)
                     , .JumpRegEnable(JumpRegEnable)
                     , .BranchPredict(BranchD)
                     , .MemtoRegM(MemtoRegM)
                     , .MemtoRegE(MemtoRegE)
                     , .CLK(CLK)
                     , .RsD(RsD)
                     , .RtD(RtD)
                     , .StallF(StallF)
                     , .RsE(RsE)
                     , .RtE(RtE)
                     , .WriteRegE(WriteRegE)
                     , .WriteRegM(WriteRegM)
                     , .WriteRegW(WriteRegW)
                     , .RegWriteW(RegWriteW)
                     , .RegWriteM(RegWriteM)
                     , .RegWriteE(RegWriteE)
                     , .ControlEN(ControlEnable)
                     , .FlushE(FlushE)
                     , .ForwardAD(ForwardAD)
                     , .ForwardBD(ForwardBD)
                     , .ForwardAE(ForwardAE)
                     , .ForwardBE(ForwardBE)
                     , .ForwardJD(ForwardJD)
                     );


WB_IF_Register WB_IF(  .enable(1'b0)
                     , .CLK(CLK)
                     , .PCPrime(PCPrime)
                     , .PCF(PCF)
                     );


wire [31:0] RD;

InstructionRAM InstructionMemory (.FETCH_ADDRESS(PCF>>2)
                                 , .DATA(RD)
                                 );

Adder_4 AddPC( .din(PCF)
             , .sum_out(PCPlus4F)
             );


wire [31:0] PCPlus4D;
wire [31:0] InstrD;

//------------------Stage 2: Instruction Decode----------------------\\

IF_ID_Register IF_ID(.instruction_in(RD)
                    , .PCPlus4F(PCPlus4F)
                    , .CLK(CLK)
                    , .ENABLE(StallD)
                    , .PCPlus4D(PCPlus4D)
                    , .instruction_out(InstrD)
                    );


wire RegWriteD, MemtoRegD, MemWriteD, ALUSrcD;
wire RegDstD, BranchD, BneD;
wire [3:0] ALUControlD;
wire JumpLinkD;

ControlUnit Control( .OpCode(InstrD[31:26])
                    , .Funct (InstrD[5:0])
                    , .ENABLE(ControlEnable) 
                    , .RegWrite(RegWriteD)
                    , .MemtoReg(MemtoRegD)
                    , .MemWrite(MemWriteD)
                    , .Branch(BranchD)
                    , .ALUSrc(ALUSrcD)
                    , .RegDst(RegDstD)
                    , .ALUop(ALUControlD)
                    , .Jump(JumpD)
                    , .Bne(BneD)
                    , .JumpLinkD(JumpLinkD)
                    , .JumpReg(JumpRegD)
                    );

wire [31:0] ResultW;

wire MemtoRegW;
wire [31:0] RD1;
wire [31:0] RD2;

wire [31:0] RD1Equal;
wire [31:0] RD2Equal;

wire [4:0] A1;
wire [4:0] A2;

assign A1= InstrD[25:21];
assign A2= InstrD[20:16];

RegisterFile RegFile(  .A1(A1)
                     , .A2(A2)
                     , .A3(WriteRegW)
                     , .WD3(ResultW)
                     , .RegWrite(RegWriteW)
                     , .CLK(CLK)
                     , .RD1(RD1)
                     , .RD2(RD2)
                    );

wire EqualD;

Mux2to1_32bit MuxRD1Equal( .din_0(RD1)
                         , .din_1(ALUOutE)
                         , .sel(ForwardAD)
                         , .out(RD1Equal)
                        );

Mux2to1_32bit MuxRD2Equal( .din_0(RD2)
                         , .din_1(ALUOutE)
                         , .sel(ForwardBD)
                         , .out(RD2Equal)
                          );


CheckEqual Equal( .din_0(RD1Equal)
                , .din_1(RD2Equal)
                , .Bne(BneD)
                , .d_out(EqualD)
                );

assign PCSrcD = EqualD & BranchD;

wire [31:0] SignImmD;

ExtendUnit ExtendImm( .in(InstrD[15:0])
                     , .out(SignImmD)
                     , .OpCode(InstrD[31:26])
                    );

BranchAddrUnit Branch( .SignImmD(SignImmD)
                     , .PCPlus4D(PCPlus4D)
                     , .PCBranchD(PCBranchD)
                     );

wire [31:0] JRsValue;

// deal with jr hazard
Mux3to1_32bit MuxRsValue( .din_0(RD1)
                        , .din_1(ALUOutE)
                        , .din_2(ReadDataM)
                        , .sel(ForwardJD)
                        , .out(JRsValue)
                        );

JumpUnit Jump( .JumpEnable(JumpD)   
             , .OpCode(InstrD[31:26])
             , .PCPlus4D(PCPlus4D)
             , .Target(InstrD[25:0])
             , .RsValue(JRsValue)
             , .JumpAddress(PCJumpD)
             , .JumpRegEnable(JumpRegEnable)
             );

wire MemtoRegE, MemWriteE, ALUSrcE, RegDstE;
wire [3:0] ALUControlE;
wire [4:0] SaE;
wire [31:0] SignImmE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [31:0] WriteDataE;


//-------------------- Stage 3: Execution ----------------------\\
wire JumpLinkE;
wire [31:0] PCPlus4E;
assign RsD = InstrD[25:21];
assign RtD = InstrD[20:16];

ID_EX_Register ID_EX(  .instruction_in(InstrD) 
                     , .RD1(RD1)
                     , .RD2(RD2)
                     , .PCPlus4D(PCPlus4D)
                     , .SignImmD(SignImmD)
                     , .SaD(InstrD[10:6])
                     , .RsD(RsD)
                     , .RtD(RtD)
                     , .RdD(InstrD[15:11])
                     , .RegWriteD(RegWriteD)
                     , .MemtoRegD(MemtoRegD)
                     , .MemWriteD(MemWriteD)
                     , .JumpLinkD(JumpLinkE)
                     , .ALUControlD(ALUControlD)
                     , .ALUSrcD(ALUSrcD)
                     , .RegDstD(RegDstD)
                     , .CLK(CLK)
                     , .CLR(FlushE)
                     , .RD1_out(RD1E)
                     , .RD2_out(RD2E)
                     , .SignImmE(SignImmE)
                     , .RtE(RtE)
                     , .RdE(RdE)
                     , .RsE(RsE)
                     , .SaE(SaE)
                     , .PCPlus4E(PCPlus4E)
                     , .RegWriteE(RegWriteE)
                     , .MemtoRegE(MemtoRegE)
                     , .MemWriteE(MemWriteE)
                     , .ALUControlE(ALUControlE)
                     , .ALUSrcE(ALUSrcE)
                     , .RegDstE(RegDstE)
                     , .JumpLinkE(JumpLinkE)
                    );

wire [31:0] SrcAE;
wire [31:0] SrcBE;
wire [31:0] SrcBEPrime;
wire [31:0] ALUOutM;

Mux4to1_32bit MuxSrcA( .din_0(RD1E)
                    , .din_1(ResultW)
                    , .din_2(ALUOutM)
                    , .din_3(ReadDataM)
                    , .sel(ForwardAE)
                    , .out(SrcAE)
                    );

Mux4to1_32bit MuxSrcBPrime( .din_0(RD2E)
                          , .din_1(ResultW)
                          , .din_2(ALUOutM)
                          , .din_3(ReadDataM)
                          , .sel(ForwardBE)
                          , .out(SrcBEPrime)
                          );

Mux2to1_32bit MuxSrcB( .din_0(SrcBEPrime)
                     , .din_1(SignImmE)
                     , .sel(ALUSrcE)
                     , .out(SrcBE)
                     );


Mux2to1_5bit MuxReg( .din_0(RtE)
                   , .din_1(RdE)
                   , .sel(RegDstE)
                   , .out(WriteRegE)
                   );

wire [31:0] ALUOutE;

ALU ALUModule( .ALUControl(ALUControlE)
             , .reg_A(SrcAE)
             , .reg_B(SrcBE)
             , .sa(SaE)
             , .result(ALUOutE)
             , .zero()  // zero is useless, I put here just to remind myself
             );

wire MemWriteM;
wire [31:0] WriteDataM;
assign WriteDataE = SrcBEPrime;

//------------------Stage 4: Memory Write/Read---------------------\\
wire JumpLinkM;
wire [31:0] PCPlus4M;
EX_MEM_Register EX_MEM( .RegWriteE(RegWriteE)
                      , .MemtoRegE(MemtoRegE)
                      , .MemWriteE(MemWriteE)
                      , .WriteDataE(WriteDataE)
                      , .PCPlus4E(PCPlus4E)
                      , .JumpLinkE(JumpLinkE)
                      , .CLK(CLK)
                      , .WriteRegE(WriteRegE)
                      , .ALUOutE(ALUOutE)
                      , .RegWriteM(RegWriteM)
                      , .WriteDataM(WriteDataM)
                      , .MemtoRegM(MemtoRegM)
                      , .MemWriteM(MemWriteM)
                      , .WriteRegM(WriteRegM)
                      , .ALUOutM(ALUOutM)
                      , .JumpLinkM(JumpLinkM)
                      , .PCPlus4M(PCPlus4M)
                      );      



MainMemory DataMemory( .WriteDataM(WriteDataM)
                     , .ALUOutM(ALUOutM)
                     , .MemWriteM(MemWriteM)
                     , .DATA(ReadDataM)
                     );

wire [31:0] ReadDataW;
wire [31:0] ALUOutW;

//------------------Stage 5: Write Back-------------------------\\
wire JumpLinkW;
wire [4:0] WriteRegWPrime;
wire [31:0] PCPlus4W;
MEM_WB_Register MEM_WB(  .RegWriteM(RegWriteM)
                       , .MemtoRegM(MemtoRegM)
                       , .ALUOutM(ALUOutM)
                       , .ReadDataM(ReadDataM)
                       , .WriteRegM(WriteRegM)
                       , .JumpLinkM(JumpLinkM)
                       , .CLK(CLK)
                       , .RegWriteW(RegWriteW)
                       , .MemtoRegW(MemtoRegW)
                       , .ALUOutW(ALUOutW)
                       , .ReadDataW(ReadDataW)
                       , .WriteRegW(WriteRegWPrime)
                       , .JumpLinkW(JumpLinkW)
                       , .PCPlus4W(PCPlus4W)
                       , .PCPlus4M(PCPlus4M)
                       );

Mux2to1_5bit MuxWriteRegister( .din_0(WriteRegWPrime)
                             , .din_1(5'b11111)
                             , .sel(JumpLinkW)
                             , .out(WriteRegW)
                             );

wire [31:0] ResultWPrime;

Mux2to1_32bit MuxResultWPrime( .din_0(ALUOutW)
                        , .din_1(ReadDataW)
                        , .sel(MemtoRegW)
                        , .out(ResultWPrime)
                        );

Mux2to1_32bit MuxResultW( .din_0(ResultWPrime)
                        , .din_1(PCPlus4W+4)
                        , .sel(JumpLinkW)
                        , .out(ResultW)
                        );


//-------------------------Finish----------------------------\\

endmodule

