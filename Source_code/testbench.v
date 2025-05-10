module test_bench();
    reg clk, rst;
   // wire halt;	
    top dut(.clk(clk),.rst(rst));
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

//  initial begin
//      rst = 1;
//      #25 rst = 0;
//  end

    initial begin
        $display("========CPU TEST 1: THIS TEST SHOULD BE HALTED WITH THE PC AT 17 HEX=========");
        $readmemb("PROG1.txt", dut.mem_dut.mem);
        rst = 1;
        @(posedge clk);
        rst = 0;
        wait(dut.ctrl_dut.halt);
        $display("[%0t]  ||  PC = %0h  ||  OP = %b  ||  ADDR = %0h  ||  DATA = %0h", $time, dut.pc_dut.pc_out, dut.ctrl_dut.opcode, dut.pc_dut.pc_out, dut.mem_dut.data_out);
        
        if (dut.pc_dut.pc_out === 5'h17) begin
            $display("CPU TEST 1 PASSED");
        end else begin
            $display("CPU TEST 1 FAILED");
        end

    #50;
    $display("===========================END CPU TEST 1===========================");
    rst = 1;
    #30 rst = 0;
        $display("===========CPU TEST 2: THIS TEST SHOULD BE HALTED WITH THE PC AT 10 HEX===========");
        $readmemb("PROG2.txt", dut.mem_dut.mem);
        rst = 1;
        @(posedge clk);
        rst = 0;
        wait(dut.ctrl_dut.halt);
        $display("[%0t]  ||  PC = %0h  ||  OP = %b  ||  ADDR = %0h  ||  DATA = %0h", $time, dut.pc_dut.pc_out, dut.ctrl_dut.opcode, dut.pc_dut.pc_out, dut.mem_dut.data_out);

        if (dut.pc_dut.pc_out === 5'h10) begin
            $display("CPU TEST 2 PASSED");
        end else begin
            $display("CPU TEST 2 FAILED");
        end
    #50;
    $display("===========================END CPU TEST 2===========================");
    rst = 1;
    #30 rst = 0;
        $display("========CPU TEST 3: THIS TEST SHOULD BE HALTED WITH THE PC AT 0C HEX=========");
        $readmemb("PROG3.txt", dut.mem_dut.mem);
        rst = 1;
        @(posedge clk);
        rst = 0;
        wait(dut.ctrl_dut.halt);
        $display("[%0t]  ||  PC = %0h  ||  OP = %b  ||  ADDR = %0h  ||  DATA = %0h", $time, dut.pc_dut.pc_out, dut.ctrl_dut.opcode, dut.pc_dut.pc_out, dut.mem_dut.data_out);

        if (dut.pc_dut.pc_out === 5'h0C) begin
            $display("CPU TEST 3 PASSED");
        end else begin
            $display("CPU TEST 3 FAILED");
        end

    #50;
    $display("===========================END CPU TEST 3===========================");
    #10 $finish();
end
//  #3000 $finish();
endmodule
