module testbench();
reg clk, rst;
MIPS aMIPS(.Clock(clk), .Reset(rst));
initial
begin
	$readmemh("code.txt", aMIPS.aInstrMem.Memory);
	clk = 1;
	rst = 0;
	#5 rst = 1;
	#20 rst = 0;
end

always
	#50 clk = ~clk;
endmodule
