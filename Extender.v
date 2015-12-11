module Extender(ExtFormat, In, Out);

input ExtFormat;
input [15:0] In;
output [31:0] Out;

reg [31:0] RegOut;
always @(*)
begin
	if (ExtFormat == 1)
		RegOut = { {16{In[15]}}, In};
	else
		RegOut = { 16'b0, In};
end

assign Out = RegOut;

endmodule
