module ALU(SrcA, SrcB, ALUOp, Zero, Result);

input [31:0] SrcA, SrcB;
input [3:0] ALUOp;
output Zero;
output [31:0] Result;

parameter AND = 4'b0000;
parameter OR  = 4'b0001;
parameter ADD = 4'b0010;
parameter XOR = 4'b0011;
parameter SLL = 4'b0100;
parameter SRL = 4'b0101;
parameter SUB = 4'b0110;
parameter SLT = 4'b0111;
parameter LUI = 4'b1000;
parameter SRA = 4'b1001;
parameter NOR = 4'b1100;

reg [31:0] ALUResult;
always @(*)
begin
	case (ALUOp)
		AND: ALUResult = SrcA & SrcB;
		OR : ALUResult = SrcA | SrcB;
		ADD: ALUResult = SrcA + SrcB;
		XOR: ALUResult = SrcA ^ SrcB;
		SLL: ALUResult = SrcB << SrcA[4:0];
		SRL: ALUResult = SrcB >>> SrcA[4:0];
		SUB: ALUResult = SrcA - SrcB;
		SLT: ALUResult = (SrcA < SrcB) ? 1 : 0;
		NOR: ALUResult = ~(SrcA | SrcB);
		SRA: ALUResult = SrcB >> SrcA[4:0];
		LUI: ALUResult = {SrcB, 16'b0};
	endcase
end
assign Zero = (ALUResult == 0)?1:0;
assign Result = ALUResult;
endmodule
