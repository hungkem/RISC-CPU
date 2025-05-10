module alu_testbench();
    reg [`DATA_WIDTH - `ADDR_WIDTH - 1 : 0] opcode;
    reg [`DATA_WIDTH - 1 : 0] in_a, in_b;
    wire [`DATA_WIDTH - 1 : 0] result;
    wire is_zero;
    alu alu_dut(.opcode(opcode),
                .in_a(in_a),
                .in_b(in_b),
                .is_zero(is_zero),
                .result(result));
    task compare(input [8:0] exp_value);
        if({is_zero, result} === exp_value) begin
            $display("[%3t] Result is matching with expected result = 8'h%0h and expected is_zero = %0b",$time, exp_value[7:0], exp_value[8]);
        end else begin
            $display("[%3t] Result is not matching with expected result = 8'h%0h but actual result is 8'h%0h", $time, exp_value[7:0], result);
            #10 $finish();
        end
    endtask

    initial begin
        #20;
        opcode = 3'b000;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_37);
        #10;
        opcode = 3'b001;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_37);
        #10;
        opcode = 3'b010;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_11);
        #10;
        opcode = 3'b011;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_12);
        #10;
        opcode = 3'b100;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_ed);
        #10;
        opcode = 3'b101;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_DA);
        #10;
        opcode = 3'b110;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_37);
        #10;
        opcode = 3'b111;
        in_a = 8'h37;
        in_b = 8'hDA;
        #5;
        compare(9'h0_37);
        #10;
        opcode = 3'b010;
        in_a = 8'h00;
        in_b = 8'hFF;
        #5;
        compare(9'h1_FF);
        $display("\n====================TEST PASSED====================");
        #10 $finish();
    end
endmodule
