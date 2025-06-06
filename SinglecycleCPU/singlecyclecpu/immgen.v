module immgen(
    input [31:0] instr,
    input [5:0] immOp,
    output reg [31:0] imm
);

    always @(*) begin
        case(immOp)
            6'b100000: imm = {27'b0,instr[24:20]};
            6'b010000: imm = {{20{instr[31]}},instr[31:20]};
            6'b001000: imm = {{20{instr[31]}},instr[31:25],instr[11:7]};
            6'b000100: imm = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
            6'b000010: imm = {instr[31:12],12'b0};
            6'b000001: imm = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
            default: imm = 32'b0;
        endcase
    end

endmodule