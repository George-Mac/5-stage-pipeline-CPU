
// This module is used to store main memory

module MainMemory( input [31:0] ALUOutM
                ,  input [31:0] WriteDataM
                ,  input MemWriteM
                ,  output reg [31:0] DATA
                );
    
    reg [31:0] DATA_RAM [0:511];
    integer i;

    initial begin
        DATA <= 32'b0;
        for (i = 0; i<512; i++) begin
            DATA_RAM[i] <= 32'b0;
        end
    end

    always @(ALUOutM or WriteDataM or MemWriteM) begin
        if (MemWriteM==1'b0) begin
            DATA <=  DATA_RAM[(ALUOutM)/4];
        end
        else if (MemWriteM==1'b1) begin
            DATA_RAM[(ALUOutM)/4] <= WriteDataM;
        end
    end

endmodule