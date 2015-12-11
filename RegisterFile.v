module RegisterFile(Clock, Clear, Read1, Read2, WriteReg, WriteData, ReadData1, ReadData2, RegWrite);

input Clock;			// The clock signal
input Clear;			// The clear signal, set all registers to zero
input [4:0] Read1, Read2;	// The number of registers to be read
input [4:0] WriteReg;		// The number of register to be written
input [31:0] WriteData;		// The data to be written to WriteReg
input RegWrite;			// Decide whether the register should be written

output [31:0] ReadData1, ReadData2;// the data from Read1, Read2

reg [31:0] Register [31:0];	// 32 32-bit registers
integer i;

assign ReadData1 = (Read1==0)?0:Register[Read1];
assign ReadData2 = (Read2==0)?0:Register[Read2];

always @(posedge Clock, posedge Clear)
begin
	if (Clear == 1)
	begin
		for (i=0; i<32; i=i+1)
			Register[i] <= 0;
	end
	else if (RegWrite && WriteReg != 0)
		Register[WriteReg] <= WriteData;
end

endmodule
