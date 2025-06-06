module IF_ID(
    input clk, reset, write_enable, flush,
    // [31:0] pc, [31:0] instr
    input [63:0] in,
    output reg [63:0] out
    );

    always @(negedge clk, posedge reset)
    begin
        if (reset) begin
            out <= 0;
        end
        else if (write_enable) begin
            if (flush) begin out <= 0;end
            else begin out <= in;end
        end
    end

endmodule

module ID_EX(
    input clk, reset, write_enable, flush,
    // [4:0] rs1, rs2
    // [6:0] ctrls (Branch[1:0],MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite)
    // [4:0] ALUOp, [2:0] dm_ctrl, [31:0] pc, [31:0] rd1, [31:0] rd2, [31:0] imm, [4:0] rd
    input [157:0] in,
    output reg [157:0] out
    );

    always @(negedge clk, posedge reset)
    begin
        if (reset) begin
            out <= 0;
        end
        else if (write_enable) begin
            if (flush) begin out <= 0;end
            else begin out <= in;end
        end
    end

endmodule

module EX_MEM(
    input clk, reset, write_enable, flush,
    // [3:0] ctrls (MemRead,MemtoReg,MemWrite,RegWrite)
    // [2:0] dm_ctrl, [31:0] ALUresult, [31:0] _ALUop2, [31:0] WBdata0, [4:0] rd
    input [107:0] in,
    output reg [107:0] out
    );

    always @(negedge clk, posedge reset)
    begin
        if (reset) begin
            out <= 0;
        end
        else if (write_enable) begin
            if (flush) begin out <= 0;end
            else begin out <= in;end
        end
    end

endmodule

module MEM_WB(
    input clk, reset, write_enable, flush,
    // ctrl (RegWrite)
    // [31:0] WBdata, [4:0] rd
    input [37:0] in,
    output reg [37:0] out
    );

    always @(negedge clk, posedge reset)
    begin
        if (reset) begin
            out <= 0;
        end
        else if (write_enable) begin
            if (flush) begin out <= 0;end
            else begin out <= in;end
        end
    end

endmodule
