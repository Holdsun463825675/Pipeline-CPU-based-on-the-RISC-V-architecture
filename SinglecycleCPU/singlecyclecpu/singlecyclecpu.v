module singlecyclecpu(
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

    //wires
    //IDinput
    wire [6:0] opcode = inst_in[6:0];
    wire [2:0] funct3 = inst_in[14:12];
    wire funct7 = inst_in[30];
    wire [4:0] rs1 = inst_in[19:15];
    wire [4:0] rs2 = inst_in[24:20];
    wire [4:0] rd = inst_in[11:7];
    wire [31:0] regwritedata;
    wire [5:0] immOp;
    //IDoutput,EXinput
    wire [6:0] ctrls;
    wire RegWrite = ctrls[0];
    wire ALUSrc = ctrls[1];
    wire [4:0] ALUOp;
    wire [31:0] rd1, rd2;
    wire [31:0] imm;
    //EXoutput,MEMinput
    wire [1:0] branch_ctrl = ctrls[6:5];
    wire MemRead = ctrls[4];
    wire MemWrite = ctrls[2];
    wire ALUZero;
    //MEMoutput,WBinput
    wire [31:0] next_pc;
    wire [31:0] pc_plus4;
    wire [31:0] WBdata0;
    wire [31:0] WBdata1 = Data_in;
    wire MemtoReg = ctrls[3];
    //WBoutput
    wire [31:0] WBdata;

    //modules
    //IF
    wire [31:0] pc;
    pc U_pc(clk, reset, next_pc, pc);

    //ID
    control U_control(opcode, funct3, funct7, ctrls, ALUOp, dm_ctrl, immOp);
    regfile U_regfile(clk, reset, rs1, rs2, rd1, rd2, RegWrite, rd, WBdata);
    immgen U_immgen(inst_in, immOp, imm);

    //EX
    wire [31:0] ALUop2, ALUresult;
    assign ALUop2 = ALUSrc ? imm : rd2;
    alu U_alu(rd1, ALUop2, ALUOp, pc, ALUresult, ALUZero);

    //MEM
    wire DatatoReg;
    wire [2:0] next_pc_op;
    branch_unit U_branch_unit(branch_ctrl, ALUZero, ALUresult[0], DatatoReg, next_pc_op);
    next_pc U_next_pc(pc, next_pc_op, imm, ALUresult, next_pc, pc_plus4);
    assign WBdata0 = DatatoReg ? pc_plus4 : ALUresult;

    //WB
    assign WBdata = MemtoReg ? WBdata1 : WBdata0;

    //CPU output
    assign mem_w = MemWrite;
    assign PC_out = pc;
    assign Addr_out = ALUresult;
    assign Data_out = rd2;


endmodule
