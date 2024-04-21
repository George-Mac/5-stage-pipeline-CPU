// This module is used to deal jump instruction(jr, jal, j)

module JumpUnit ( input JumpEnable   
                , input JumpRegEnable
                , input [5:0] OpCode
                , input [31:0] PCPlus4D
                , input [25:0] Target
                , input [31:0] RsValue
                , output reg [31:0] JumpAddress
                );
    
    reg [31:0] RsBuffer;

    initial begin
        JumpAddress <= 32'b0;
    end

    always @(JumpEnable or OpCode or Target or RsValue ) begin
        if (JumpEnable) begin
            if (OpCode==6'b0) begin  // jr
                // RsBuffer <= RsValue;
                if (JumpRegEnable) begin
                    JumpAddress <= RsValue;
                end
                
            end
            else if((OpCode==6'b000010)) begin// j
                JumpAddress <= {PCPlus4D[31:28], Target, 2'b00};
               
            end

            else if (OpCode==000011)begin
                JumpAddress <= {PCPlus4D[31:28], Target, 2'b00};
            end
        end

        

    end

endmodule