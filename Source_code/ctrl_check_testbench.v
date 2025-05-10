module ctrl_check();

    reg clk , rst, is_zero;
    reg [2:0] opcode;
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;
    controller dut(.is_zero(is_zero),.clk(clk),.rst(rst),.opcode(opcode),.sel(sel),.rd(rd),.wr(wr),.ld_ir(ld_ir),.ld_ac(ld_ac),.ld_pc(ld_pc),.halt(halt),.inc_pc(inc_pc),.data_e(data_e));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #25 rst = 0;
    end

    initial begin
        $monitor("[%4t] opcode = 3'b%0b || is_zero = %0b || sel = %0b || rd = %0b || ld_ir = %0b || halt = %0b || inc_pc = %0b || ld_ac = %0b || ld_pc = %0b || wr = %0b || data_e = %0b", $time, opcode, is_zero, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e);
        opcode = 3'b001;
        is_zero = 0;
        #150
        opcode = 3'b011;
        is_zero = 1;
        #150
        opcode = 110;
        is_zero = 0;
        #150 $finish();
    end

endmodule
