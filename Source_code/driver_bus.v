`include "def.v"
module driver_bus(
    input wire [`DATA_WIDTH - 1 : 0] data,
    input wire data_e,
    output wire [`DATA_WIDTH - 1 : 0] data_out
);
    assign data_out = data_e ? data : {`DATA_WIDTH{1'bz}};
endmodule
