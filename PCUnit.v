module PCUnit(Clock, Reset, PCWrite, Addr);

input Clock;
input Reset;
input [31:0] PCWrite;
output [31:0] Addr;

reg [31:0] PCNow;
always @(posedge Clock or posedge Reset)
begin
	if (Reset)
		PCNow <= 32'h0000_3000;
	else
		PCNow <= PCWrite;
end
assign Addr = PCNow;

endmodule
