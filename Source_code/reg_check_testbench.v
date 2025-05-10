
module reg_check();
    reg clk,rst,ld_ir;
    reg [`DATA_WIDTH - 1 : 0] inst_in;
    wire [`DATA_WIDTH - `ADDR_WIDTH - 1 : 0] opcode;
    wire [`ADDR_WIDTH - 1 : 0] operand;
    instruction_register dut(.clk(clk),.rst(rst),.opcode(opcode),.ld_ir(ld_ir),.operand(operand),.inst_in(inst_in));
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #25 rst = 0;
    end

    initial begin
        #30; //wait rst done
        rst = 1;
        @(posedge clk);
        compare(8'h0);
        #10 rst = 0;
        write(8'hFF, 0);
        compare(8'h0);
        write(8'hFF,1);
        compare(8'hFF);
        write(8'hCC,0);
        compare(8'hFF);
        write(8'hCC,1);
        compare(8'hCC);
        write(8'hAA,1);
        compare(8'hAA);
        #10 $display("TEST PASSED");
        $finish();
    end

    task compare(input [`DATA_WIDTH - 1 : 0]exp_value);
    begin
        #5;
        if({opcode, operand} === exp_value) begin
            $display("Data is matching with expected value = 8'h%0h", exp_value);
        end else begin
            $display("Data is not matching with expected value = 8'h%0h", exp_value);
            #5 $finish();
        end
    end
    endtask

    task write(input [`DATA_WIDTH - 1 : 0] data_in, input enable);
    begin
        @(posedge clk);
        inst_in = data_in;
        ld_ir = enable;
        @(posedge clk);
        // inst_in = {'DATA_WIDTH{1'b0}};
        // ld_ir = 0;
    end
    endtask
endmodule
