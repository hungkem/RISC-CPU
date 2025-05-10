`include "def.v"
module alu(
    input wire [`DATA_WIDTH-`ADDR_WIDTH-1:0] opcode, // from instruction memory
    input wire [`DATA_WIDTH-1:0] in_a,               // from accumulator
    input wire [`DATA_WIDTH-1:0] in_b,               // from memory
    output reg [`DATA_WIDTH-1:0] result,
    output wire is_zero                             // to controller
);

always @(*) begin
    case (opcode)
        `HLT: result = in_a;
        `SKZ: result = in_a;
        `ADD: result = in_a + in_b;
        `AND: result = in_a & in_b;
        `XOR: result = in_a ^ in_b;
        `LDA: result = in_b;
        `STO: result = in_a;
        `JMP: result = in_a;
    endcase
end

assign is_zero = (in_a == {`DATA_WIDTH{1'b0}});

endmodule
