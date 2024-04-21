`timescale 100fs/100fs

// ALU module, output alu result, the zero is useless since I 
// remove the branch unit to the second stage (ID)
module ALU( input [3:0]   ALUControl
          , input [31:0] reg_A
          , input [31:0] reg_B
          , input [4:0]  sa
          , output reg [31:0] result
          , output reg zero 
          ); 

    always @(ALUControl or reg_A or reg_B or sa) 
    begin
        result = 32'b0;

        case (ALUControl)
            4'bxxxx: result = 32'b0;   // jr , j, jal

            4'b0000: result = reg_A & reg_B;  // and, andi

            4'b0001: result = reg_A | reg_B;  // or, ori

            4'b0010:  result = reg_A + reg_B;  // add,addi,addu,addiu,sw,lw

            4'b0011:                           // beq : equal branch
                    begin 
                        result = reg_A - reg_B;
                    end

            4'b0100:                        // bne : not equal branch
                    begin
                        result = reg_A - reg_B;        
                    end

            4'b0101: result = reg_B << reg_A;   //  sllv

            4'b0110: result = reg_A - reg_B;   // sub, subu

            4'b0111: result = $signed(reg_A) < $signed(reg_B) ? 32'b1 : 32'b0;   // slt, slti

            4'b1000: result = $unsigned(reg_A) < $unsigned(reg_B) ? 32'b1 : 32'b0; // sltu, sltiu

            4'b1001: result = reg_B >> reg_A;  // srlv

            4'b1010: result = $signed(reg_B) >>> (reg_A);  // srav

            4'b1011: result = reg_A ^ reg_B;      // xor, xori

            4'b1100: result = ~(reg_A|reg_B);   // nor
            
            4'b1101: result = reg_B << sa;     // sll

            4'b1110: result = reg_B >> sa;     // srl

            4'b1111: result = $signed(reg_B) >>> (sa);    // sra

        endcase
    end

endmodule