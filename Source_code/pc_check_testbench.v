module pc_check();
    reg clk, rst, ld_pc, inc_pc;
    reg [`ADDR_WIDTH - 1 : 0] pc_in;
    wire [`ADDR_WIDTH - 1 : 0] pc_out;

    program_counter dut(.clk(clk), .rst(rst), .ld_pc(ld_pc), .inc_pc(inc_pc), .pc_in(pc_in), .pc_out(pc_out));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #25 rst = 0;
    end

    initial begin
        ld_pc = 0;
        inc_pc = 0;
        pc_in = 5'h0;
        #30;
        rst = 1;
        @(posedge clk);
        compare(5'h0);
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        ld_pc = 0;
        inc_pc = 1;
        @(posedge clk);
        repeat(10) @(posedge clk);
        compare(5'hA);
        inc_pc = 0;
        rst = 1;
        @(posedge clk);
        rst = 0;
        repeat(15) @(posedge clk);
        compare(5'h0);
        inc_pc = 1;
        repeat(25) @(posedge clk);
        inc_pc = 0;
        ld_pc = 1;
        pc_in = 5'h03;
        repeat(2) @(posedge clk);
        compare(5'h03);
        @(posedge clk);
        inc_pc = 1;
        ld_pc = 0;
        wait(pc_out == 5'h1F);
        repeat(2) @(posedge clk);
        compare(5'h0);
        #10 $display("TEST PASSED");

        $finish();
    end

    task compare(input [`ADDR_WIDTH - 1 : 0] exp_value);
    begin
        if (pc_out === exp_value) begin
            $display("[%3t] Data is matching with expected value = 5'h%0h", $time, exp_value);
        end else begin
            $display("[%3t] Data is not matching with expected value = 5'h%0h, but actual value = 5'h%0h", $time, exp_value, pc_out);
            #5 $finish();
        end
    end
    endtask
endmodule
