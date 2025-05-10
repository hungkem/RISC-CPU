module mem_test();
  reg clk, wr, rd;
  reg [`ADDR_WIDTH-1:0] addr;
  wire [`DATA_WIDTH-1:0] data_io;

  memory dut(.clk(clk), .wr(wr), .rd(rd), .addr(addr), .data_io(data_io));

  integer i;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  reg [`DATA_WIDTH-1:0] data_drv;
  assign data_io = wr ? data_drv : {`DATA_WIDTH{1'bz}};
  reg [`DATA_WIDTH-1:0] rd_t;

  initial begin
    wr = 0;
    rd = 0;
    addr = 0;

    // checkerboard test
    for(i = 0; i < 32; i = i + 1) begin
      write(i[DATA_WIDTH-1:0], i[ADDR_WIDTH-1:0]);
    end

    for(i = 0; i < 32; i = i + 1) begin
      read(rd_t, i[ADDR_WIDTH-1:0]);
      compare(i[DATA_WIDTH-1:0], rd_t);
    end

    #10;

    // clear mem
    for(i = 0; i < 32; i = i + 1) begin
      write(0, i[ADDR_WIDTH-1:0]);
    end

    for(i = 0; i < 32; i = i + 1) begin
      read(rd_t, i[ADDR_WIDTH-1:0]);
      compare(0, rd_t);
    end

    #10;
    // multiple write
    write(8'hab, 5'h1e);
    write(8'h19, 5'h1e);
    write(8'h34, 5'h1e);
    read(rd_t, 5'h1e);
    compare(8'h34, rd_t);
    #10 $display("TEST PASSED");
    $finish();
  end

  task compare(input [`DATA_WIDTH-1:0] exp_value, act_value);
  begin
    #5;
    if (act_value === exp_value) begin
      $display("Data matched! Value = 8'h%0h", exp_value);
    end else begin
      $display("Data mismatch! Expected = 8'h%0h, Got = 8'h%0h", exp_value, act_value);
      #5 $finish();
    end
  end
  endtask

  task write(input [`DATA_WIDTH-1:0] data_in, input [`ADDR_WIDTH-1:0] addr_in);
  begin
    @(posedge clk);
    $display("[WRITE] Addr = 5'h%0h || Data = 8'h%0h", addr_in, data_in);
    addr = addr_in;
    wr = 1;
    data_drv = data_in;
    @(posedge clk);
    wr = 0;
  end
  endtask

  task read(output [`DATA_WIDTH-1:0] rdata, input [`ADDR_WIDTH-1:0] addr_in);
  begin
    @(posedge clk);
    addr = addr_in;
    rd = 1;
    @(posedge clk);
    #1;
    rdata = data_io;
    $display("[READ] Addr = 5'h%0h || Data = 8'h%0h", addr_in, rdata);
    rd = 0;
  end
  endtask

endmodule
