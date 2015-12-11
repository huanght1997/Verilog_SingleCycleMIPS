module DataMem(Clock, Address, WriteData, ReadData, MemRead, MemWrite);

input Clock;			// The clock signal
input [9:0] Address;		// The address to be operated
input [31:0] WriteData;		// The data to be written into memory
input MemRead, MemWrite;	// Decide the operation of memory

output [31:0] ReadData;

reg [31:0] Memory [1023:0];
reg [31:0] Read;

always @(posedge Clock)
begin
	if (MemRead)
	begin
		Read <= Memory[Address];
	end
	if (MemWrite)
	begin
		Memory[Address] <= WriteData;
	end
end

assign ReadData = Read;

endmodule
