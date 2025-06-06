module control(
    input [6:0] opcode,
    input [2:0] funct3,
    input funct7,
    output [6:0] ctrls,
    //Branch[1:0],MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite
    output [4:0] ALUOp,
    output [2:0] dm_ctrl,
    output [5:0] immOp
);
    //use lots of logical operation to boost performance
    
    wire rtypeop = ~opcode[6]&opcode[5]&opcode[4]&~opcode[3]&~opcode[2];
    wire itypeop = ~opcode[6]&~opcode[5]&opcode[4]&~opcode[3]&~opcode[2];
    wire jalrop = opcode[6]&opcode[5]&~opcode[4]&~opcode[3]&opcode[2];
    wire loadop = ~opcode[6]&~opcode[5]&~opcode[4]&~opcode[3]&~opcode[2];
    wire stypeop = ~opcode[6]&opcode[5]&~opcode[4]&~opcode[3]&~opcode[2];
    wire btypeop = opcode[6]&opcode[5]&~opcode[4]&~opcode[3]&~opcode[2];
    wire luiop = ~opcode[6]&opcode[5]&opcode[4]&~opcode[3]&opcode[2];
    wire auipcop = ~opcode[6]&~opcode[5]&opcode[4]&~opcode[3]&opcode[2];
    wire jtypeop = opcode[6]&opcode[5]&~opcode[4]&opcode[3]&opcode[2];

    //ctrls
    assign ctrls[6] = jalrop | jtypeop;
    assign ctrls[5] = jalrop | btypeop;
    assign ctrls[4] = loadop;
    assign ctrls[3] = loadop;
    assign ctrls[2] = stypeop;
    assign ctrls[1] = itypeop | jalrop | loadop | stypeop | luiop | auipcop;
    assign ctrls[0] = rtypeop | itypeop | jalrop | loadop | luiop | auipcop | jtypeop;

    //immOp
    wire si = ~funct3[1] & funct3[0];
    assign immOp[5] = itypeop & si;
    assign immOp[4] = (itypeop & ~si) | jalrop | loadop;
    assign immOp[3] = stypeop;
    assign immOp[2] = btypeop;
    assign immOp[1] = luiop | auipcop;
    assign immOp[0] = jtypeop;

    //ALUOp
    //R,I
    wire _add = ~funct3[2]&~funct3[1]&~funct3[0];
        wire add = rtypeop & _add & ~funct7;
        wire sub = rtypeop & _add & funct7;
        wire addi = itypeop & _add; 
    wire xor_ = (rtypeop | itypeop)&funct3[2]&~funct3[1]&~funct3[0];
    wire and_ = (rtypeop | itypeop)&funct3[2]&funct3[1]&funct3[0];
    wire sll = (rtypeop | itypeop)&~funct3[2]&~funct3[1]&funct3[0];
    wire slt = (rtypeop | itypeop)&~funct3[2]&funct3[1]&~funct3[0];
    wire sltu = (rtypeop | itypeop)&~funct3[2]&funct3[1]&funct3[0];
    wire _sr = funct3[2]&~funct3[1]&funct3[0];
    wire srl = (rtypeop | itypeop)& _sr & ~funct7;
    wire sra = (rtypeop | itypeop)& _sr & funct7;
    wire or_ = (rtypeop | itypeop)&funct3[2]&funct3[1]&~funct3[0];
    //B
    wire beq = btypeop & ~funct3[2]&~funct3[1]&~funct3[0];
    wire bne = btypeop & ~funct3[2]&~funct3[1]&funct3[0];
    wire blt = btypeop & funct3[2]&~funct3[1]&~funct3[0];
    wire bge = btypeop & funct3[2]&~funct3[1]&funct3[0];
    wire bltu = btypeop & funct3[2]&funct3[1]&~funct3[0];
    wire bgeu = btypeop & funct3[2]&funct3[1]&funct3[0];

    assign ALUOp[4] = srl | sra | beq;
    assign ALUOp[3] = bltu | bgeu | slt | sltu | xor_ | or_ | and_ | sll;
    assign ALUOp[2] = sub | bne | blt | bge | xor_ | or_ | and_ | sll;
    assign ALUOp[1] = auipcop | add | addi | jalrop | loadop | stypeop | blt | bge | slt | sltu | and_ | sll | beq;
    assign ALUOp[0] = luiop | add | addi | jalrop | loadop | stypeop | bne | bge | bgeu | sltu | or_ | sll | sra;

    //dm_ctrl
    assign dm_ctrl[0] = ~funct3[2] & ~funct3[1];
    assign dm_ctrl[1] = ~(funct3[2] ^ funct3[1] ^ funct3[0]);
    assign dm_ctrl[2] = funct3[2] & ~funct3[1] & ~funct3[0];

    /*
    //dm_ctrl
    wire lors = loadop | stypeop;
    assign dm_ctrl[0] = lors & ~funct3[2] & ~funct3[1];
    assign dm_ctrl[1] = lors & ~(funct3[2] ^ funct3[1] ^ funct3[0]);
    assign dm_ctrl[2] = lors & funct3[2] & ~funct3[1] & ~funct3[0];*/


endmodule