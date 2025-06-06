module detection_hazard_unit(
    input [4:0] IF_ID_rs1, IF_ID_rs2, ID_EX_rd,
    input ID_EX_MemRead,
    output PCWrite, detection_flush
    );
    //to judge if need to set a nop

    //the last instruction is load and current instruction need this data
    wire setnop = ID_EX_MemRead & (ID_EX_rd != 0) & (ID_EX_rd == IF_ID_rs1 | ID_EX_rd == IF_ID_rs2);
    assign PCWrite = ~setnop;           //When nop, PC shouldn't write
    assign detection_flush = setnop;    //When nop, produce a flush

endmodule
