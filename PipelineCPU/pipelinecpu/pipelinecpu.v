module pipelinecpu(
    input      clk,           // clock
    input      reset,         // reset
    input      MIO_ready,
    input [31:0]  inst_in,    // instruction
    input [31:0]  Data_in,    // data from data memory
   
    output mem_w,             // MemWrite
    output [31:0] PC_out,     // PC address
    output [31:0] Addr_out,   // ALUresult
    output [31:0] Data_out,   // data to dmem
    output [2:0] dm_ctrl,     // connect dm_controller
    output CPU_MIO,
    input INT                 // interrupt
    );

    assign MIO_ready = CPU_MIO;
    //wires
    //IF
    wire [31:0] IF_pc;
    wire [31:0] IF_instr = inst_in;
    wire [31:0] IF_next_pc;

    assign PC_out = IF_pc;

    //IF_ID
    // [31:0] pc, [31:0] instr
    wire [63:0] IF_ID_in = {IF_pc, IF_instr};
    wire [63:0] IF_ID_out;
    wire IF_ID_Write, IF_ID_flush;
    IF_ID U_IF_ID(clk, reset, IF_ID_Write, IF_ID_flush, IF_ID_in, IF_ID_out);

    //ID
    wire [31:0] ID_pc = IF_ID_out[63:32];
    wire [31:0] ID_instr = IF_ID_out[31:0];
    wire [6:0] ID_opcode = ID_instr[6:0];
    wire [2:0] ID_funct3 = ID_instr[14:12];
    wire ID_funct7 = ID_instr[30];
    wire [4:0] ID_rs1 = ID_instr[19:15];
    wire [4:0] ID_rs2 = ID_instr[24:20];
    wire [4:0] ID_rd = ID_instr[11:7];

    wire [6:0] ID_ctrls;
    wire [4:0] ID_ALUOp;
    wire [2:0] ID_dm_ctrl;
    wire [5:0] ID_immOp;
    wire [31:0] ID_rd1, ID_rd2, ID_imm;

    //ID_EX
    // [4:0] rs1, rs2
    // [6:0] ctrls (Branch[1:0],MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite)
    // [4:0] ALUOp, [2:0] dm_ctrl, [31:0] pc, [31:0] rd1, [31:0] rd2, [31:0] imm, [4:0] rd
    wire [157:0] ID_EX_in = {ID_rs1, ID_rs2, ID_ctrls, ID_ALUOp, ID_dm_ctrl, ID_pc, ID_rd1, ID_rd2, ID_imm, ID_rd};
    wire [157:0] ID_EX_out;
    wire ID_EX_flush;
    ID_EX U_ID_EX(clk, reset, 1'b1, ID_EX_flush, ID_EX_in, ID_EX_out);

    //EX
    wire [4:0] EX_rs1 = ID_EX_out[157:153];
    wire [4:0] EX_rs2 = ID_EX_out[152:148];
    wire [6:0] EX_ctrls = ID_EX_out[147:141];
    wire [1:0] EX_Branch = EX_ctrls[6:5];
    wire EX_MemRead = EX_ctrls[4];
    wire EX_ALUSrc = EX_ctrls[1];
    wire [3:0] EX_other_ctrls = {EX_ctrls[4:2], EX_ctrls[0]};
    wire [4:0] EX_ALUOp = ID_EX_out[140:136];
    wire [2:0] EX_dm_ctrl = ID_EX_out[135:133];
    wire [31:0] EX_pc = ID_EX_out[132:101];
    wire [31:0] EX_rd1 = ID_EX_out[100:69];
    wire [31:0] EX_rd2 = ID_EX_out[68:37];
    wire [31:0] EX_imm = ID_EX_out[36:5];
    wire [4:0] EX_rd = ID_EX_out[4:0];

    wire [31:0] ALUop2;
    wire EX_ALUZero;
    wire [31:0] EX_ALUresult;
    wire EX_DatatoReg;
    wire [2:0] EX_next_pc_op;
    wire [31:0] EX_next_pc;
    wire [31:0] EX_pc_plus4;
    wire EX_PCSrc;
    wire [31:0] EX_WBdata0;

    wire [31:0] _ALUop2; //Hazard

    //EX_MEM
    // [3:0] ctrls (MemRead,MemtoReg,MemWrite,RegWrite)
    // [2:0] dm_ctrl, [31:0] ALUresult, [31:0] _ALUop2, [31:0] WBdata0, [4:0] rd
    wire [107:0] EX_MEM_in = {EX_other_ctrls, EX_dm_ctrl, EX_ALUresult, _ALUop2, EX_WBdata0, EX_rd};
    wire [107:0] EX_MEM_out;
    EX_MEM U_EX_MEM(clk, reset, 1'b1, 1'b0, EX_MEM_in, EX_MEM_out);

    //MEM
    wire MEM_MemRead = EX_MEM_out[107];
    wire MEM_MemtoReg = EX_MEM_out[106];
    wire MEM_MemWrite = EX_MEM_out[105];
    wire MEM_RegWrite = EX_MEM_out[104];
    wire [2:0] MEM_dm_ctrl = EX_MEM_out[103:101];
    wire [31:0] MEM_ALUresult = EX_MEM_out[100:69];
    wire [31:0] MEM_rd2 = EX_MEM_out[68:37];
    wire [31:0] MEM_WBdata0 = EX_MEM_out[36:5];
    wire [4:0] MEM_rd = EX_MEM_out[4:0];
    wire [31:0] MEM_WBdata1 = Data_in;
    wire [31:0] MEM_WBdata;

    assign mem_w = MEM_MemWrite;
    assign Addr_out = MEM_ALUresult;
    assign Data_out = MEM_rd2;
    assign dm_ctrl = MEM_dm_ctrl;

    //MEM_WB
    // ctrls (RegWrite)
    // [31:0] WBdata, [4:0] rd
    wire [37:0] MEM_WB_in = {MEM_RegWrite, MEM_WBdata, MEM_rd};
    wire [37:0] MEM_WB_out;
    MEM_WB U_MEM_WB(clk, reset, 1'b1, 1'b0, MEM_WB_in, MEM_WB_out);

    //WB
    wire WB_RegWrite = MEM_WB_out[37];
    wire [31:0] WB_WBdata = MEM_WB_out[36:5];
    wire [4:0] WB_rd = MEM_WB_out[4:0];
    

    //Hazard wires
    wire _PCWrite, PCWrite;
    wire [1:0] forwardA, forwardB;
    wire [31:0] ALUop1;


    //modules
    //IF
    assign IF_next_pc = EX_PCSrc ? EX_next_pc : IF_pc+4;
    pc U_pc(clk, reset, PCWrite, IF_next_pc, IF_pc);

    //ID
    control U_control(ID_opcode, ID_funct3, ID_funct7, ID_ctrls, ID_ALUOp, ID_dm_ctrl, ID_immOp);
    regfile U_regfile(clk, reset, ID_rs1, ID_rs2, ID_rd1, ID_rd2, MEM_RegWrite, MEM_rd, MEM_WBdata);
    immgen U_immgen(ID_instr, ID_immOp, ID_imm);

    //EX
    assign ALUop2 = EX_ALUSrc ? EX_imm : _ALUop2;
    alu U_alu(ALUop1, ALUop2, EX_ALUOp, EX_pc, EX_ALUresult, EX_ALUZero);
    branch_unit U_branch_unit(EX_Branch, EX_ALUZero, EX_ALUresult[0], EX_DatatoReg, EX_next_pc_op);
    next_pc U_next_pc(EX_pc, EX_next_pc_op, EX_imm, EX_ALUresult, EX_next_pc, EX_pc_plus4, EX_PCSrc);
    assign EX_WBdata0 = EX_DatatoReg ? EX_pc_plus4 : EX_ALUresult;

    //MEM
    assign MEM_WBdata = MEM_MemtoReg ? MEM_WBdata1 : MEM_WBdata0;

    //WB
    //send back data to regfile

    //Hazard modules
    wire detection_flush;                               //flush
    assign PCWrite = EX_PCSrc | _PCWrite;               //decided by nop or branch
    assign IF_ID_Write = PCWrite;                       //the same with PCWrite
    assign IF_ID_flush = EX_PCSrc;                      //flush when branch
    assign ID_EX_flush = EX_PCSrc | detection_flush;    //flush when nop or branch
    detection_hazard_unit U_detection_hazard_unit(ID_rs1, ID_rs2, EX_rd, EX_MemRead, _PCWrite, detection_flush);
    forwarding_unit U_forwarding_unit(EX_rs1, EX_rs2, MEM_rd, WB_rd, MEM_RegWrite, WB_RegWrite, forwardA, forwardB);
    data_hazard_mux U_data_hazard_mux(EX_rd1, EX_rd2, MEM_ALUresult, WB_WBdata, forwardA, forwardB, ALUop1, _ALUop2);


endmodule
