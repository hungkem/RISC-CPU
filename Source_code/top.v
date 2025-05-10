`include "def.v"

module top(
    input wire clk,
    input wire rst,
    output wire pc_out);
    
    wire ld_pc, inc_pc, wr, rd, data_e, ld_ac, ld_ir, is_zero, sel, halt;
    wire [`ADDR_WIDTH - 1 : 0] pc_out, ir_operand, mux_addr_out;
    wire [`DATA_WIDTH - 1 : 0] mem_data, alu_result, ac_out;
    wire [`DATA_WIDTH - `ADDR_WIDTH - 1 : 0] ir_opcode;

    // program counter
    program_counter pc_dut(
        .clk(clk),
        .rst(rst),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .pc_in(ir_operand),
        //.halt(halt),
        .pc_out(pc_out)
    );

    // address mux
    address_mux adm_dut(
        .sel(sel),
        .pc_addr(pc_out),
        .operand_addr(ir_operand),
        .addr_out(mux_addr_out)
    );

    // instruction register
    instruction_register ir_dut(
        .clk(clk),
        .rst(rst),
        .ld_ir(ld_ir),
        .inst_in(mem_data),
        .opcode(ir_opcode),
        .operand(ir_operand)
    );

    // accumulator register
    accumulator_register ac_dut(
        .clk(clk),
        .rst(rst),
        .ld_ac(ld_ac),
        .ac_in(alu_result),
        .ac_out(ac_out)
    );

    // alu
    alu alu_dut(
        .opcode(ir_opcode),
        .in_a(ac_out),
        .in_b(mem_data),
        .result(alu_result),
        .is_zero(is_zero)
    );

    // memory
    memory mem_dut(
        .clk(clk),
        .wr(wr),
        .rd(rd),
        .data_e(data_e),
        .addr(mux_addr_out),
        .data_io(mem_data)
    );

    // controller
    controller ctrl_dut(
        .clk(clk),
        .rst(rst),
        .opcode(ir_opcode),
        .is_zero(is_zero),
        .sel(sel),
        .wr(wr),
        .rd(rd),
        .data_e(data_e),
        .ld_ir(ld_ir),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .halt(halt),
        .inc_pc(inc_pc)
    );

    // driver bus
    driver_bus db_dut(
        .data(ac_out),
        .data_e(data_e),
        .data_out(mem_data)
    );

endmodule
