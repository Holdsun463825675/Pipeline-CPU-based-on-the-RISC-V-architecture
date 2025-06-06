module next_pc(
    input [31:0] pc,
    input [2:0] next_pc_op,
    input [31:0] imm,
    input [31:0] ALUresult,
    output reg [31:0] next_pc,
    output [31:0] pc_plus4
    );
    assign pc_plus4 = pc+4;

    always @(*) begin
        case (next_pc_op)
            3'b000: next_pc = pc_plus4;
            3'b001: next_pc = pc+imm;
            3'b010: next_pc = pc+imm;
            3'b011: next_pc = ALUresult;
            default: next_pc = pc_plus4;
        endcase
   end

endmodule
