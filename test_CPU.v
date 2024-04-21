`timescale 100fs/100fs

// test brench module
module CPU_test;

CPU test_CPU();

integer i, fd;


initial begin
   fd = $fopen("./MemoryOut.txt", "w+");
end

always @(test_CPU.RD) begin
    if(test_CPU.RD=={32{1'b1}}) begin
        #30 for(i=0; i<512; i=i+1) 
           $fdisplay(fd, "%b", test_CPU.DataMemory.DATA_RAM[i]);
        
        $fdisplay(fd, "\nTotal number of CLK cycle:", "%d", test_CPU.Clock.CLKCount);
        $fclose(fd);
        $finish;
    end

end

endmodule