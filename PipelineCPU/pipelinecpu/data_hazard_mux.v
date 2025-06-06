module data_hazard_mux(
    input [31:0] EX_rd1, EX_rd2, MEM_ALUresult, WB_WBdata,
    input [1:0] forwardA, forwardB,
    output reg [31:0] ALUop1, _ALUop2
    );
    //to select ALUoperation among current or previous data

    always @(*) begin
        case(forwardA)
            2'b00: ALUop1 = EX_rd1;         //no data-hazard
            2'b01: ALUop1 = WB_WBdata;      //MEM data-hazard
            2'b10: ALUop1 = MEM_ALUresult;  //EX data-hazard
            default: ALUop1 = EX_rd1;
        endcase
    end

    always @(*) begin
        case(forwardB)
            2'b00: _ALUop2 = EX_rd2;
            2'b01: _ALUop2 = WB_WBdata;
            2'b10: _ALUop2 = MEM_ALUresult;
            default: _ALUop2 = EX_rd2;
        endcase
    end

endmodule
