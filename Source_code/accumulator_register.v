`include "def.v"
module accumulator_register(
    input wire clk,
    input wire rst,
    input wire ld_ac,  // from controller
    input wire [`DATA_WIDTH-1:0] ac_in, // from result of alu
    output reg [`DATA_WIDTH-1:0] ac_out // this signal is input in_a of alu or to memory for STO instruction
);

always @(posedge clk or posedge rst) begin
    if(rst)
        ac_out <= {`DATA_WIDTH{1'b0}};
    else if(ld_ac)
        ac_out <= ac_in;
    else
        ac_out <= ac_out;
end

endmodule
