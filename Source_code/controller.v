`include "def.v"
module controller(
    input wire clk ,
    input wire rst ,
    input wire [`DATA_WIDTH - `ADDR_WIDTH - 1 : 0] opcode , // from instruction memory
    input wire is_zero , // from alu
    output reg sel ,
    output reg rd ,
    output reg ld_ir ,
    output reg halt ,
    output reg inc_pc ,
    output reg ld_ac ,
    output reg ld_pc ,
    output reg wr ,
    output reg data_e
);

// internal variables
reg [`DATA_WIDTH - 1 : 0] current_state, next_state;
reg aluop, skz, jmp, halt_op, sto;
always @(*) begin
    aluop = (opcode == `ADD) | (opcode == `AND) | (opcode == `XOR) | (opcode == `LDA);
    skz = opcode == `SKZ;
    jmp = opcode == `JMP;
    halt_op = opcode == `HLT;
    sto = opcode == `STO;
end

// store states
always @(posedge clk or posedge rst) begin
    if(rst) current_state <= `INST_ADDR;
    else current_state <= next_state;
end

// next state and output logic
always @(*) begin
    if(rst) begin
        sel = 1;
        rd = 0;
        ld_ir = 0;
        halt = 0;
	inc_pc = 0;
        ld_ac = 0;
        ld_pc = 0;
        wr = 0;
        data_e = 0;
    end else begin
        case (current_state)
            `INST_ADDR: begin
                sel = 1;
                rd = 0;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
                next_state = `INST_FETCH;
            end

            `INST_FETCH: begin
                sel = 1;
                rd = 1;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
                next_state = `INST_LOAD;
            end

    	`INST_LOAD: begin
     		sel = 1;
                rd = 1;
                ld_ir = 1;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
		wr = 0;
        	data_e = 0;
        	next_state = `IDLE;
    	end

    `IDLE: begin
        sel = 1;
        rd = 1;
        ld_ir = 1;
        halt = 0;
        inc_pc = 0;
        ld_ac = 0;
        ld_pc = 0;
        wr = 0;
        data_e = 0;
        next_state = `OP_ADDR;
    end

    `OP_ADDR: begin
        sel = 0;
        rd = 0;
        ld_ir = 0;
        halt = halt_op;
        inc_pc = 1;
        ld_ac = 0;
        ld_pc = 0;
        wr = 0;
        data_e = 0;
        next_state = `OP_FETCH;
    end

    `OP_FETCH: begin
        sel = 0;
        rd = aluop;
        ld_ir = 0;
        halt = 0;
        inc_pc = 0;
        ld_ac = 0;
        ld_pc = 0;
        wr = 0;
        data_e = 0;
        next_state = `ALU_OP;
    end
    `ALU_OP: begin
        sel = 0;
        rd = aluop;
        ld_ir = 0;
        halt = 0;
        inc_pc = skz && is_zero;
        ld_ac = 0;
        ld_pc = jmp;
        wr = 0;
        data_e = sto;
        next_state = `STORE;
    end

    `STORE: begin
        sel = 0;
        rd = aluop;
        ld_ir = 0;
        halt = 0;
        inc_pc = 0;
        ld_ac = aluop;
        ld_pc = jmp;
        wr = sto;
        data_e = sto;
        next_state = `INST_ADDR;
    end

    default: begin
        next_state = `INST_ADDR;
    end
    endcase
end
end
endmodule
