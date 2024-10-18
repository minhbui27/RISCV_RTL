// ALU module for branchless RISC-V processor
`timescale 1ns/1ns
module alu(
	input logic [31:0]	a,
	input logic [31:0]	b,
	input logic	[3:0]	alu_op,
	output logic [31:0]	alu_o
);

always @(*)
begin
	case (alu_op)
		4'b0000: alu_o = a + b; 
		4'b0001: alu_o = a ^ b;
		4'b0010: alu_o = a | b;
		4'b0011: alu_o = a & b;
		4'b0100: alu_o = a << b;	// shift left logical
		4'b0101: alu_o = a >> b;	// shift right logical
		4'b0110: alu_o = a >>> b;	// shirt right arithmetic
		4'b0111: alu_o = $signed(a) < $signed(b); // set less than
		4'b1000: alu_o = a < b;		// set less than unsigned
		4'b1001: alu_o = a - b;		// subtract
		default: alu_o = 32'h0000;
	endcase
end

endmodule
