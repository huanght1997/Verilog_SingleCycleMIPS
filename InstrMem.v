module InstrMem(InstrAddr, Instr);

input [9:0] InstrAddr;	// The address of the instruction to be fetched
output [31:0] Instr;	// The instruction

reg [31:0] Memory [1023:0];

assign Instr = Memory[InstrAddr];

endmodule
