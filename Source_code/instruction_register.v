`include "def.v"
module instruction_register(
    input wire clk,
    input wire rst,
    input wire ld_ir,      // from controller
    input wire [`DATA_WIDTH-1:0] inst_in, // from memory
    output reg [`DATA_WIDTH-`ADDR_WIDTH-1:0] opcode, // to alu and controller
    output reg [`ADDR_WIDTH-1:0] operand   // to address mux
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        {opcode, operand} <= {`DATA_WIDTH{1'b0}};
    end else if(ld_ir) begin
        {opcode, operand} <= inst_in;
    end
end

endmodule
