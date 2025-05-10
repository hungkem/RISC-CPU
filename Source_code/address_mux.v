`include "def.v"

module address_mux(
    input wire sel,
    input wire [`ADDR_WIDTH - 1 : 0] pc_addr,       // from program counter
    input wire [`ADDR_WIDTH - 1 : 0] operand_addr,   // from instruction register
    output wire [`ADDR_WIDTH - 1 : 0] addr_out
);

    assign addr_out = sel ? pc_addr : operand_addr;

endmodule
