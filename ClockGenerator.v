`timescale 100fs/100fs

// This module is used to generate CLOCK
module Clock_Gnerator(  input   enable 
                      , output  reg CLK);

    parameter clk_period = 10;
    integer CLKCount;
    
    initial begin
        CLK<=0;
        CLKCount<=0;
    end
    
    always begin
        if (enable) begin
            #(clk_period/2);
            CLK=~CLK;
            CLKCount = CLKCount+1;
        end
    end

endmodule