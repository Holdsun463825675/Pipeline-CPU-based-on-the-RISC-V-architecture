module regfile(
  input clk, reset,
  input [4:0] ra1, ra2,
  output [31:0] rd1, rd2,

  input we3, 
  input [4:0] wa3,
  input [31:0] wd3
  );

  reg [31:0] rf[31:0];
  integer i;

  //write
  always @(negedge clk, posedge reset) begin
    if (reset) begin
        for (i=0;i<32;i=i+1) begin rf[i]<=0; end
    end
    else if (we3 && wa3!=0)
      begin
        rf[wa3] <= wd3;
        $display("x%d = %h", wa3, wd3);
      end
  end

  //read
  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule
