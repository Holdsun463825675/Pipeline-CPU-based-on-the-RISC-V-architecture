module forwarding_unit(
    input [4:0] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd,
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    output [1:0] forwardA, forwardB
    );
    //to judge data hazard

    //EX
    wire EXflagA = EX_MEM_RegWrite & (EX_MEM_rd != 0) & (EX_MEM_rd == ID_EX_rs1);
    wire EXflagB = EX_MEM_RegWrite & (EX_MEM_rd != 0) & (EX_MEM_rd == ID_EX_rs2);

    //MEM: not EX-data-hazard at the same time
    wire MEMflagA = MEM_WB_RegWrite & (MEM_WB_rd != 0) & (MEM_WB_rd == ID_EX_rs1) & ~EXflagA;
    wire MEMflagB = MEM_WB_RegWrite & (MEM_WB_rd != 0) & (MEM_WB_rd == ID_EX_rs2) & ~EXflagB;

    //out
    assign forwardA = {EXflagA, MEMflagA};
    assign forwardB = {EXflagB, MEMflagB};

endmodule
