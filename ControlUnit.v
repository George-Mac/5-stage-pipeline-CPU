`timescale 100fs/100fs

module ControlUnit(  input [5:0] OpCode
                   , input [5:0] Funct
                   , input ENABLE  
                   , output reg  RegWrite
                   , output reg  MemtoReg
                   , output reg  MemWrite
                   , output reg  Branch
                   , output reg  ALUSrc
                   , output reg  RegDst
                   , output reg  Jump
                   , output reg  JumpReg
                   , output reg  Bne
                   , output reg  JumpLinkD
                   , output reg [3:0] ALUop
                   );

    initial begin

        RegWrite  <= 1'b0;
        MemtoReg  <= 1'b0;  
        MemWrite  <= 1'b0;  
        Branch    <= 1'b0;
        ALUSrc    <= 1'b0;
        RegDst    <= 1'b0;
        Jump      <= 1'b0;
        Bne       <= 1'b0;
        JumpReg   <= 1'b0;
        ALUop     <= 4'b0000;

    end

    always @(OpCode or Funct) begin
    
    if (ENABLE) begin  // branch happen, clear the conrtol unit

        RegWrite  <= 1'b0;
        MemtoReg  <= 1'b0;  
        MemWrite  <= 1'b0;  
        Branch    <= 1'b0;
        ALUSrc    <= 1'b0;
        RegDst    <= 1'b0;
        Jump      <= 1'b0;
        JumpReg   <= 1'b0;
        Bne       <= 1'b0;
        ALUop     <= 4'b0000;

    end

    // R type (without jr) 
    else begin
    if ((OpCode==6'b000000) && (Funct!=6'b001000)) begin
        
        RegDst    <=  1'b1;
        ALUSrc    <=  1'b0;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <= 1'b0;
        case(Funct)

            6'b100000:  ALUop <= 4'b0010;  // add
            6'b100001:  ALUop <= 4'b0010;  // addu
            6'b100100:  ALUop <= 4'b0000;  // and
            6'b100111:  ALUop <= 4'b1100;  // nor
            6'b100101:  ALUop <= 4'b0001;  // or
            6'b000000:  ALUop <= 4'b1101;  // sll
            6'b000100:  ALUop <= 4'b0101;  // sllv
            6'b101010:  ALUop <= 4'b0111;  // slt
            6'b000011:  ALUop <= 4'b1111;  // sra
            6'b000111:  ALUop <= 4'b1010;  // srav
            6'b000010:  ALUop <= 4'b1110;  // srl
            6'b000110:  ALUop <= 4'b1001;  // srlv
            6'b100010:  ALUop <= 4'b0110;  // sub
            6'b100011:  ALUop <= 4'b0110;  // subu
            6'b100110:  ALUop <= 4'b1011;  // xor

        endcase
        
    end

    // jr
    else if ((OpCode==6'b000000) && (Funct==6'b001000)) begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b0;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b0;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'bxxxx;
        Jump      <=  1'b1;
        JumpReg   <=  1'b1;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // j
    else if(OpCode==6'b000010)begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b0;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b0;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'bxxxx;
        Jump      <=  1'b1;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // jal
    else if(OpCode==000011)begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b0;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'bxxxx;
        Jump      <=  1'b1;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b1;

    end

    // lw
    else if (OpCode==6'b100011) begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b1;
        MemtoReg  <=  1'b1;
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'b0010;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // sw
    else if (OpCode==6'b101011) begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b1;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b0;
        MemWrite  <=  1'b1;
        Branch    <=  1'b0;
        ALUop     <=  4'b0010;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // beq 
    else if (OpCode==6'b000100) begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b0;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b0;
        MemWrite  <=  1'b0;
        Branch    <=  1'b1;
        ALUop     <=  4'b0011; 
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // bne
    else if (OpCode==6'b000101) begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b0;
        MemtoReg  <=  1'b0;
        RegWrite  <=  1'b0;
        MemWrite  <=  1'b0;
        Branch    <=  1'b1;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        ALUop     <=  4'b0100; 
        Bne       <=  1'b1;
        JumpLinkD <=  1'b0;


    end

    // addi, addiu
    else if (OpCode==6'b001000||OpCode==6'b001001) begin  

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b1;
        MemtoReg  <=  1'b0;  
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'b0010;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // andi
    else if (OpCode==6'b001100) begin   

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b1;
        MemtoReg  <=  1'b0;  
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'b0000;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;
    end

    // xori
    else if (OpCode==6'b001110) begin    

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b1;
        MemtoReg  <=  1'b0;  
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'b1011;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // ori
    else if (OpCode==6'b001101) begin

        RegDst    <=  1'b0;
        ALUSrc    <=  1'b1;
        MemtoReg  <=  1'b0;  
        RegWrite  <=  1'b1;
        MemWrite  <=  1'b0;
        Branch    <=  1'b0;
        ALUop     <=  4'b0001;
        Jump      <=  1'b0;
        JumpReg   <=  1'b0;
        Bne       <=  1'b0;
        JumpLinkD <=  1'b0;

    end

    // clear for branch and jump
    else if((OpCode==6'bxxxxxx) && (Funct==6'bxxxxxx)) begin
        
        RegWrite  <= 1'b0;
        MemtoReg  <= 1'b0;  
        MemWrite  <= 1'b0;  
        Branch    <= 1'b0;
        ALUSrc    <= 1'b0;
        RegDst    <= 1'b0;
        Jump      <= 1'b0;
        JumpReg   <=  1'b0;
        Bne       <= 1'b0;
        ALUop     <= 4'b0000;
        JumpLinkD <=  1'b0;

    end

    end

    end


endmodule