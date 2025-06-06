module branch_unit(
    input [1:0] branch_ctrl,
    input Zero,  //not used, to be reserved
    input Bflag, //ALUresult[0]
    output DatatoReg, //Select WBdata0 between ALUresult and pc+4
    output [2:0] next_pc_op
    );

    assign DatatoReg = branch_ctrl[1];
    assign next_pc_op[2] = 1'b0;
    assign next_pc_op[1] = branch_ctrl[1];
    //if B-type, then see Bflag to decide if jump
    assign next_pc_op[0] = branch_ctrl[0] ^ ( ~branch_ctrl[1] & branch_ctrl[0] & Bflag);

endmodule
