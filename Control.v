module Control(
	Opcode,		// The opcode field in instruction
	Funct,		// The funct field in instruction
	Zero,		// From ALU
	RegDst,		// rd is denstination register if 0, rt if 1
	Jal,		// Force $31 be the destination register and store current PC to $31 if it's enabled
	ExtFormat,	// Zero-extend if 0, Sign-extend if 1
	MemRead,	// Reading memory is available if it's enabled
	MemtoReg,	// Data to be written into register file is from memory if 1, ALU's result if 0.
	ALUOp,		// Control the operation of ALU
	ALUSrcA,	// The data in rs if 0, shamt if 1
	ALUSrcB,	// The data in rt if 0, immediate number if 1
	MemWrite,	// Writing memory is available if it's enabled
	RegWrite,	// Writing register is available if it's enabled
	PCSrc		// 0:PC+4(most) 1:PC+4+Imm<<2(bne,beq) 2:data in rs(jr) 3:addr<<2(j,jal)
);
input [5:0] Opcode, Funct;
input Zero;
output RegDst, Jal, ExtFormat, MemRead, MemtoReg, ALUSrcA, ALUSrcB, MemWrite, RegWrite;
output [3:0] ALUOp;
output [1:0] PCSrc;

reg RType, iAdd, iAnd, iBeq, iBne, iJ, iJal, iJr, iLui, iLw, iOr, iSll, iSrl, iSw, iSub, iXor, iSra;
always @(*)
begin
	RType = (Opcode == 6'h00)?1:0;
	iAdd = (RType && Funct==6'h20 || Opcode == 6'h08)?1:0;
	iAnd = (RType && Funct==6'h24 || Opcode == 6'h0c)?1:0;
	iBeq = (Opcode == 6'h04)?1:0;
	iBne = (Opcode == 6'h05)?1:0;
	iJ   = (Opcode == 6'h02)?1:0;
	iJal = (Opcode == 6'h03)?1:0;
	iJr  = (RType && Funct==6'h08)?1:0;
	iLui = (Opcode == 6'h0f)?1:0;
	iLw  = (Opcode == 6'h23)?1:0;
	iOr  = (RType && Funct==6'h25 || Opcode == 6'h0d)?1:0;
	iSll = (RType && Funct==6'h00)?1:0;
	iSrl = (RType && Funct==6'h02)?1:0;
	iSw  = (Opcode == 6'h2b)?1:0;
	iSub = (RType && Funct==6'h22)?1:0;
	iXor = (RType && Funct==6'h26 || Opcode == 6'h0e)?1:0;
	iSra = (RType && Funct==6'h02)?1:0;
	
end
assign RegDst = ~RType;
assign Jal = iJal;
assign ExtFormat = iAdd | iLw | iSw;
assign MemRead = iLw;
assign MemtoReg = iLw;
assign ALUSrcA = iSll | iSrl;
assign ALUSrcB = ~RType;
assign MemWrite = iSw;
assign RegWrite = ~(iBeq | iBne | iJ | iJr | iSw);
assign ALUOp[3] = iSra | iLui;
assign ALUOp[2] = iSub | iSll | iSrl | iBne | iBeq;
assign ALUOp[1] = iAdd | iSub | iXor | iBne | iBeq | iSw | iLw;
assign ALUOp[0] = iOr  | iXor | iSrl | iSra;
assign PCSrc[1] = iJr  | iJ   | iJal;
assign PCSrc[0] = iBne&~Zero | iBeq&Zero | iJal | iJ;
endmodule
