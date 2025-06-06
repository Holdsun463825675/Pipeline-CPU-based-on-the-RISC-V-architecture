//size,width
`define ADDR_SIZE 32
`define INSTR_SIZE 32
`define IMEM_SIZE 1024
`define XLEN 32
`define DMEM_SIZE 1024
`define RFIDX_WIDTH 5
`define RFREG_NUM 32
`define CONTROL_WIDTH 7
`define ALUOP_WIDTH 5
`define NPCOP_WIDTH 3
`define BRANCHCTRL_WIDTH 2

//opcode
//R-type
`define R_TYPE_OP 7'b0110011
//I-type
`define I_TYPE_OP 7'b0010011
`define JALR_OP 7'b1100111
`define LOAD_OP 7'b0000011
//S-type
`define S_TYPE_OP 7'b0100011
//B-type
`define B_TYPE_OP 7'b1100011
//U-type
`define LUI_OP 7'b0110111
`define AUIPC_OP 7'b0010111
//J-type
`define J_TYPE_OP 7'b1101111

//funct3
//R,I-type
`define ADD_FUNCT3 3'b000
`define XOR_FUNCT3 3'b100
`define AND_FUNCT3 3'b111
`define SLL_FUNCT3 3'b001
`define SLT_FUNCT3 3'b010
`define SLTU_FUNCT3 3'b011
`define SR_FUNCT3 3'b101
`define OR_FUNCT3 3'b110
`define JALR_FUNCT3 3'b000
//load
`define LB_FUNCT3 3'b000
`define LH_FUNCT3 3'b001
`define LW_FUNCT3 3'b010
`define LBU_FUNCT3 3'b100
`define LHU_FUNCT3 3'b101
//S-type
//store
`define SB_FUNCT3 3'b000
`define SH_FUNCT3 3'b001
`define SW_FUNCT3 3'b010
//B-type
`define BEQ_FUNCT3 3'b000
`define BNE_FUNCT3 3'b001
`define BLT_FUNCT3 3'b100
`define BGE_FUNCT3 3'b101
`define BLTU_FUNCT3 3'b110
`define BGEU_FUNCT3 3'b111

//funct7
`define ADD_FUNCT7 1'b0
`define SUB_FUNCT7 1'b1
`define SRL_FUNCT7 1'b0
`define SRA_FUNCT7 1'b1

//ALUOp
`define ALUOp_nop 5'b00000
`define ALUOp_lui 5'b00001
`define ALUOp_auipc 5'b00010
`define ALUOp_add 5'b00011
`define ALUOp_sub 5'b00100
`define ALUOp_bne 5'b00101
`define ALUOp_blt 5'b00110
`define ALUOp_bge 5'b00111
`define ALUOp_bltu 5'b01000
`define ALUOp_bgeu 5'b01001
`define ALUOp_slt 5'b01010
`define ALUOp_sltu 5'b01011
`define ALUOp_xor 5'b01100
`define ALUOp_or 5'b01101
`define ALUOp_and 5'b01110
`define ALUOp_sll 5'b01111
`define ALUOp_srl 5'b10000
`define ALUOp_sra 5'b10001
`define ALUOp_beq 5'b10010

//control
//not defined
`define NOP_CTRL 7'b0000000 //not defined
//R-type
`define R_TYPE_CTRL 7'b0000001 //commom
//I-type
`define I_TYPE_CTRL 7'b0000011 //commom
`define JALR_CTRL 7'b1100011 //jalr
`define LW_CTRL 7'b0011011 //lw
//S-type
`define S_TYPE_CTRL 7'b0000110 //commom
//B-type
`define B_TYPE_CTRL 7'b0100000 //commom
//U-type
`define U_TYPE_CTRL 7'b0000011 //commom
//J-type
`define J_TYPE_CTRL 7'b1000001 //commom

//branch_ctrl
`define NO_BRANCH 2'b00
`define B_TYPE_BRANCH 2'b01
`define JAL_BRANCH 2'b10
`define JALR_BRANCH 2'b11

//next_pc_op
`define NPC_PLUS4 3'b000
`define NPC_B 3'b001
`define NPC_JAL 3'b010
`define NPC_JALR 3'b011

//dm_control
`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100

