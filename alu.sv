// ALU module for branchless RISC-V processor

module alu(
	input wire[31:0]	a,
	input wire[31:0]	b,
	input wire[3:0]		alu_op,
	output wire[31:0]	alu_o,
);

always @(*)
begin
	case (alu_op)
		4b'0000: alu_o = a + b; 
		4b'0001: alu_o = a ^ b;
		4b'0010: alu_o = a | b;
		4b'0011: alu_o = a & b;
		4b'0100: alu_o = a << b;	// shift left logical
		4b'0101: alu_o = a >> b;	// shift right logical
		4b'0110: alu_o = a >>> b;	// shirt right arithmetic
		4b'0111: alu_o = $signed(a) < $signed(b); // set less than
		4b'1000: alu_o = a < b;		// set less than unsigned
		4b'1001: alu_o = a - b;		// subtract
		default: alu_o = 32'h0000;
	endcase
end

endmodule

