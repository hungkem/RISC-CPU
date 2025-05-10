module drb_check();

  reg [`DATA_WIDTH - 1 : 0] data;
  reg data_e;
  wire [`DATA_WIDTH - 1 : 0] data_out;

  driver_bus dut(.data(data), .data_e(data_e), .data_out(data_out));

  initial begin
    data = 8'hFF;
    data_e = 1;
    compare(8'hFF);
    data_e = 0;
    compare(8'hz);
    #10 $display("TEST PASSED");
    $finish();
  end

  task compare(input [`DATA_WIDTH - 1 : 0] exp_value);
    begin
      #5;
      if (data_out === exp_value) begin
        $display("Data is matching with expected value = 8'h%0h", exp_value);
      end else begin
        $display("Data is not matching with expected value = 8'h%0h, but actual value = 8'h%0h", exp_value, data_out);
        #5 $finish();
      end
    end
  endtask

endmodule
