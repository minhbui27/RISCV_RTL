// Immediate Generator (ImmGen) receives the 32-bits instruction, and based on
// the opcode decides which bits of the instruction should be interpreted as
// the 12-bit immediate. Then sign extends the 12-bits immediate into 32-bits.
// The opcode part of the instruction is bit (6 downto 0) (7 bits).

`timescale 1ns/1ps

module imm_gen (
	input [31:0]		inst,
	output reg [31:0] 	imm_o
);

always_comb begin
	case (inst[6:0]) // opcode
		// I type - arithmetic
		7'b001_0011:
			begin
				case (inst[14:12]) // funct3
					// slli
					3'b001:	imm_o <= $signed(inst[24:20]);
					// srli & srai
					3'b101:	imm_o <= $signed(inst[24:20]);
					// addi, ori, andi, etc...
					default: imm_o <= $signed(inst[31:20]);
				endcase
			end
		// I type - load
		7'b000_0011: imm_o <= inst[31:20];
		// S type
		7'b010_0011: imm_o <= {{20{inst[31]}}, inst[31:25], inst[11:7]};	
		// B type
		7'b110_0011: imm_o <= {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
		// J type (only doing JAL, not C.J)
		7'b110_1111: imm_o <= {inst[31], inst[19:12], inst[20], inst[30:21]};
		default: imm_o <= 32'h0000_0000;
	endcase
end

endmodule
