// ALU module for branchless RISC-V processor

module alu(
	input wire[31:0] a,
	input wire[31:0] b,
	input wire[3:0] alu_op,
	output wire[31:0] alu_o,
);

always @(*)
begin
	case (alu_op)
		4h'0: alu_o = a + b; 
		4h'1: alu_o = a << b;
	endcase
end

endmodule


