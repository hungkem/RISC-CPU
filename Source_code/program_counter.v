`include "def.v"

module program_counter(
    input wire clk,
    input wire rst,
    input wire ld_pc,    // from controller for JMP instruction
    input wire inc_pc,   // from controller
    input wire [`ADDR_WIDTH - 1 : 0] pc_in,   // signal is branch address for JMP instruction
    output reg [`ADDR_WIDTH - 1 : 0] pc_out   // to address mux
);

    always @(posedge clk or posedge rst) begin
        if(rst)
            pc_out <= {`ADDR_WIDTH{1'b0}};
        //else if(halt) pc_out <= pc_out;
        else if(ld_pc) pc_out <= pc_in;
        else if(inc_pc) pc_out <= pc_out + 1'b1;
        //else pc_out <= pc_out;
    end

endmodule
