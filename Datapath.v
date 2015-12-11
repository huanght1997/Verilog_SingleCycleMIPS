module MIPS(Clock, Reset);
input Clock, Reset;

// PC
wire[31:0] PCAddr, PCWrite;

// InstrMem
wire [9:0] IMInstrAddr;
wire[31:0] IMInstr;

// RegisterFile
wire [4:0] RFRead1, RFRead2, RFWriteReg;
wire[31:0] RFReadData1, RFReadData2, RFWriteData;

// Extender
wire[15:0] ExtIn;
wire[31:0] ExtOut;

// DataMem
wire[31:0] DMReadData, DMWriteData;
wire [9:0] DMAddress;

// ALU
wire[31:0] ALUSrcA, ALUSrcB, ALUResult;
wire ALUZero;

// Control
wire [5:0] Opcode, Funct;
wire 	RegDst, Jal, ExtFormat, MemRead, MemtoReg,
	CtrlALUSrcA, CtrlALUSrcB, MemWrite,RegWrite;
wire [1:0] PCSrc;
wire [3:0] ALUOp;

// Instances
PCUnit aPCUnit(.Clock(Clock), .Reset(Reset), .PCWrite(PCWrite), .Addr(PCAddr));

InstrMem aInstrMem(.InstrAddr(IMInstrAddr), .Instr(IMInstr));

RegisterFile aRegisterFile(.Clock(Clock), .Clear(Reset), .Read1(RFRead1), .Read2(RFRead2), .WriteReg(RFWriteReg), .WriteData(RFWriteData),
			   .ReadData1(RFReadData1), .ReadData2(RFReadData2), .RegWrite(RegWrite));

Extender aExtender(.ExtFormat(ExtFormat), .In(ExtIn), .Out(ExtOut));

DataMem aDataMem(.Clock(Clock), .Address(DMAddress), .WriteData(DMWriteData), .ReadData(DMReadData),
		 .MemRead(MemRead), .MemWrite(MemWrite));

ALU aALU(.SrcA(ALUSrcA), .SrcB(ALUSrcB), .ALUOp(ALUOp), .Zero(ALUZero), .Result(ALUResult));

Control aCtrl(Opcode, Funct, ALUZero, RegDst, Jal, ExtFormat, MemRead, MemtoReg, ALUOp,
	      CtrlALUSrcA, CtrlALUSrcB, MemWrite, RegWrite, PCSrc);

// Connect
wire [31:0] ToReg;
wire [31:0] NextPC;
assign NextPC = PCAddr+4;
assign IMInstrAddr = PCAddr[11:2];
assign RFRead1 = IMInstr[25:21];
assign RFRead2 = IMInstr[20:16];
assign RFWriteReg = (Jal==1)?31:((RegDst==0)?IMInstr[15:11]:IMInstr[20:16]);
assign ToReg = (MemtoReg==1)?DMReadData:ALUResult;
assign RFWriteData = (Jal==1)?NextPC:ToReg;
assign ExtIn = IMInstr[15:0];
assign DMAddress = ALUResult;
assign DMWriteData = RFReadData2;
assign ALUSrcA = (CtrlALUSrcA==0)?RFReadData1:IMInstr[10:6];
assign ALUSrcB = (CtrlALUSrcB==0)?RFReadData2:ExtOut;
assign Opcode = IMInstr[31:26];
assign Funct = IMInstr[5:0];
assign PCWrite = (PCSrc[1]==0)?((PCSrc[0]==0)?NextPC:NextPC+ExtOut<<2)
	:((PCSrc[0]==0)?RFReadData1:{NextPC[31:28],IMInstr[25:0],2'b00});

endmodule
