module ac_check();

  reg clk, rst, ld_ac; // from controller
  reg [`DATA_WIDTH - 1 : 0] ac_in;   // from result of alu
  wire [`DATA_WIDTH - 1 : 0] ac_out;

  accumulator_register dut(.clk(clk), .rst(rst), .ld_ac(ld_ac), .ac_in(ac_in), .ac_out(ac_out));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1;
    #25 rst = 0;
  end

  initial begin
    #30; // wait rst done
    rst = 1;
    @(posedge clk);
    compare(8'h0);
    #10 rst = 0;
    write(8'hFF, 0);
    compare(8'h0);
    write(8'hFF, 1);
    compare(8'hFF);
    write(8'hCC, 0);
    compare(8'hFF);
    write(8'hCC, 1);
    compare(8'hCC);
    write(8'hAA, 1);
    compare(8'hAA);
    #10 $display("TEST PASSED");
    $finish();
  end

  task compare(input [`DATA_WIDTH - 1 : 0] exp_value);
    begin
      #5;
      if (ac_out === exp_value) begin
        $display("Data is matching with expected value = 8'h%0h", exp_value);
      end else begin
        $display("Data is not matching with expected value = 8'h%0h, but actual value = 8'h%0h", exp_value, ac_out);
        #5 $finish();
      end
    end
  endtask

  task write(input [`DATA_WIDTH - 1 : 0] data_in, input enable);
    begin
      @(posedge clk);
      ac_in = data_in;
      ld_ac = enable;
      @(posedge clk);
      // instruction = {`DATA_WIDTH{1'b0}};
      // ld_ir = 0;
    end
  endtask

endmodule
