`ifndef DEFINE_V
`define DEFINE_V

// ====================data and address width==================== //
`define DATA_WIDTH 8
`define ADDR_WIDTH 5
`define MEM_DEPTH 32

//=====================opcode(binary encoding)===================== //
`define HLT 3'b000
`define SKZ 3'b001
`define ADD 3'b010
`define AND 3'b011
`define XOR 3'b100
`define LDA 3'b101
`define STO 3'b110
`define JMP 3'b111

// ====================Controller state operation(one hot encoding)================ //
`define INST_ADDR 	8'b0000_0001
`define INST_FETCH 	8'b0000_0010
`define INST_LOAD 	8'b0000_0100
`define IDLE 		8'b0000_1000
`define OP_ADDR 	8'b0001_0000
`define OP_FETCH 	8'b0010_0000
`define ALU_OP 		8'b0100_0000
`define STORE 		8'b1000_0000

// ================================================================= //
`endif
