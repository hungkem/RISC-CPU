`include "def.v"
module memory(
    input wire clk,
    input wire data_e,   // output enable from controller
    input wire wr,       // write enable from controller
    input wire rd,       // read enable from controller
    input wire [`ADDR_WIDTH-1:0] addr, // from address mux
    inout wire [`DATA_WIDTH-1:0] data_io // single bidirectional-port
);

    // internal variables
    reg [`DATA_WIDTH-1:0] data_out; // read data
    reg [`DATA_WIDTH-1:0] mem [0:`MEM_DEPTH-1]; // memory (will have value from testbench)

    // write transfer
    always @(posedge clk) begin
        if(wr && data_e) mem[addr] <= data_io; // push data into memory for STO instruction
    end

    // read transfer
    always @(posedge clk) begin
        if(rd) data_out <= mem[addr];
    end

    assign data_io = rd ? data_out : {`DATA_WIDTH{1'bz}};

endmodule
