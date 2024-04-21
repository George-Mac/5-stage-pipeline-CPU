
// This module is used to handle hazard signal
module HazardUnit (  input Branch
                   , input BranchPredict
                   , input Jump
                   , input CLK
                   , input JumpReg
                   , input [4:0] RsE
                   , input [4:0] RtE
                   , input [4:0] RsD
                   , input [4:0] RtD
                   , input [4:0] WriteRegE
                   , input [4:0] WriteRegM
                   , input [4:0] WriteRegW
                   , input [31:0] ReadDataM
                   , input MemtoRegM
                   , input RegWriteW
                   , input RegWriteM
                   , input RegWriteE
                   , input MemtoRegE
                   , output reg StallD
                   , output reg StallF
                   , output reg ControlEN
                   , output reg FlushE
                   , output reg ForwardAD
                   , output reg ForwardBD
                   , output reg [1:0] ForwardAE
                   , output reg [1:0] ForwardBE
                   , output reg [1:0] ForwardJD
                   , output reg JumpRegEnable
                   );

    initial begin

        ControlEN <= 1'b0;
        StallD    <= 1'b0;
        StallF    <= 1'b0; 
        FlushE    <= 1'b0; 
        ForwardAD <= 1'b0;
        ForwardBD <= 1'b0;
        ForwardAE <= 2'b0;
        ForwardBE <= 2'b0;
        ForwardJD <= 2'b0;
        JumpRegEnable <= 1'b1;

    end

    // if branch or jump
    always @(Branch or BranchPredict or Jump or JumpReg or RegWriteW or RegWriteM or RegWriteE or WriteRegE or WriteRegM or WriteRegW or RsE or RtE or MemtoRegE) begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        FlushE = 1'b0;
        // if (Branch==1'b1)begin
            // StallD    <= 1'b1;
            // ControlEN <= 1'b1;
            // StallF    <= 1'b1;
            // ForwardAD = 1'b0;
            // ForwardBD = 1'b0;

            // if ((RegWriteM == 1'b1) && (WriteRegM!=5'b0)) begin
                // if (WriteRegM==RsD)
                    // ForwardAD = 1'b1;
                // 
                // if (WriteRegM==RtD) 
                    // ForwardBD = 1'b1;
        // 
            // end
        // end

        // else if (Jump==1'b1) begin
            // StallD    <= 1'b1;
            // ControlEN <= 1'b1;
            // StallF    <= 1'b1;

        // end
        // else begin
        // StallD    <= 1'b0;
        // ControlEN <= 1'b0;
        // StallF    <= 1'b0;
        // end

        if ((Branch==1'b1)||(Jump==1'b1)) begin
            StallD    <= 1'b1;
            ControlEN <= 1'b1;
            StallF    <= 1'b1;
        end
        else begin
            StallD    <= 1'b0;
            ControlEN <= 1'b0;
            StallF    <= 1'b0;
        end

        // read after write (data forwarding)
        if ((RegWriteM==1'b1) && (WriteRegM!=5'b0) ) 
        begin
            if (WriteRegM==RsE)
                ForwardAE <= 2'b10;
            if (WriteRegM==RtE)
                ForwardBE <= 2'b10;
            if ((WriteRegW==RsE) && (WriteRegW!=5'b0))
                ForwardAE<=2'b01;
            if ((WriteRegW==RtE) && (WriteRegW!=5'b0))
                ForwardBE<=2'b01;
        end

        

        // lw stall hazard
        if ((MemtoRegM==1'b1) && (WriteRegM!=5'b0)) begin
            if (WriteRegM==RsE) begin
                ForwardAE <= 2'b11;
            end
            if (WriteRegM==RtE) begin
                ForwardBE <= 2'b11;
            end
        end
        
        ForwardJD = 2'b00;
        // JumpRegEnable = 1'b1;
        // jr hazard
        if ((JumpReg==1'b1) && (Jump==1'b1) && (WriteRegE!=5'b0)) begin
            if ((MemtoRegE==1'b1) && (WriteRegE==RsD) && (MemtoRegE==1'b1) ) begin  // jr,lw hazard, stall and forward
                ForwardJD <= 2'b10;
                FlushE    <= 1'b1;
                JumpRegEnable <= 1'b0;
            end
            else if ((WriteRegE==RsD) && (MemtoRegE==1'b0) )begin  // jr data forwarding
                ForwardJD <= 2'b01;
                FlushE    <= 1'b0;
                JumpRegEnable <= 1'b1;
            end
            else JumpRegEnable <= 1'b1;
        end
        
        // branch hazard
        if (BranchPredict) begin
            if ( (WriteRegE!=5'b0) && (RegWriteE==1'b1) ) begin
                if (RsD==WriteRegE) begin
                    ForwardAD <= 1'b1;
                end
                if (RtD==WriteRegE) begin
                    ForwardBD <= 1'b1;
                end
            end
        end

       
    end


endmodule