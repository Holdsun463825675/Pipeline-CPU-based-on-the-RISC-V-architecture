module pc(
    input clk,
    input reset,
    input PCWrite,  
    input [31:0] next_pc,
    output reg [31:0] pc
);
    always @(negedge clk or posedge reset) begin
        if (reset) begin pc <= 32'h00000000;end
        else if (PCWrite == 1) begin pc <= next_pc;end
    end

endmodule