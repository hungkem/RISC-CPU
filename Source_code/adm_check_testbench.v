
module adm_check();
    reg sel;
    reg [`ADDR_WIDTH - 1 : 0] pc_addr, operand_addr;
    wire [`ADDR_WIDTH - 1 : 0] addr_out;
    address_mux dut(.sel(sel), .pc_addr(pc_addr), .operand_addr(operand_addr), .addr_out(addr_out));
    
    initial begin
        pc_addr = 5'h00;
        operand_addr = 5'hFF;
        sel = 0;
        compare(5'hFF);
        sel = 1;
        compare(5'h00);
        pc_addr = 5'hAA;
        operand_addr = 5'hBB;
        sel = 1;
        compare(5'hAA);
        sel = 0;
        compare(5'hBB);
        #10 $display("TEST PASSED");
        $finish();
    end

    task compare(input [`ADDR_WIDTH - 1 : 0] exp_value);
    begin
        #5;
        if(addr_out === exp_value) begin
            $display("Data is matching with expected value = 5'h%0h", exp_value);
        end else begin
            $display("Data is not matching with expected value = 5'h%0h, but actual value = 5'h%0h", exp_value, addr_out);
            #5 $finish();
        end
    end
    endtask
endmodule
