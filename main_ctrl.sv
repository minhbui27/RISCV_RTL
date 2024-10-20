`timescale 1ns/1ns
module main_ctrl (
    input  logic [31:0] inst_i,
    output logic        reg_wr,
    output logic [ 3:0] alu_op,
    output logic        sel_a,
    output logic        sel_b,
    output logic        mem_wr,
    output logic        mem_rd,
    output logic [ 2:0] mask,
    output logic [ 1:0] sel_wb,
    output logic [ 2:0] br_type
); 
	// for easy field access of the instruction
	typedef struct packed {
		logic	[6:0]	funct7;
		logic	[4:0]	rs2;
		logic	[4:0]	rs1;
		logic	[2:0]	funct3; 
		logic	[4:0]	rd;
		logic	[6:0]	opcode;
	} inst_t;

	inst_t inst;
	assign inst = inst_t'(inst_i);

  always_comb begin : mux_control
		// Only doing R,I (no jalr),S types for now. 
		case (inst.opcode)
			// R types
			7'b0110011: begin
				sel_a = 0;
				sel_b = 0;
				reg_wr = 1;
				sel_wb = 1;
				case (inst.funct3)
					// ADD or SUB
					3'b000: alu_op = !inst.funct7 ? 0 : 4'b1001;
					// XOR
					3'b100: alu_op = 4'b0001;
					// OR
					3'b110: alu_op = 4'b0010;
					// AND
					3'b111: alu_op = 4'b0011;
					// SLL
					3'b001: alu_op = 4'b0100;
					// SRL or SRA
					3'b101: alu_op = (!inst.funct7) ? 4'b0101 : 4'b0110; 
					// SLT
					3'b010: alu_op = 4'b0111;
					// SLTU
					3'b011: alu_op = 4'b1000;
					default: alu_op = 0;
				endcase	
			end
			// I arithmetic types
			7'b0010011: begin
				sel_a = 0;
				sel_b = 1;
				reg_wr = 1;
				sel_wb = 1;
				case (inst.funct3)
					// ADD (there is no SUBI) 
					3'b000: alu_op = 0;
					// XOR
					3'b100: alu_op = 4'b0001;
					// OR
					3'b110: alu_op = 4'b0010;
					// AND
					3'b111: alu_op = 4'b0011;
					// SLL
					3'b001: alu_op = 4'b0100;
					// SRL or SRA
					3'b101: alu_op = (!inst[31:26]) ? 4'b0101 : 4'b0110; 
					// SLT
					3'b010: alu_op = 4'b0111;
					// SLTU
					3'b011: alu_op = 4'b1000;
					default: alu_op = 0;
				endcase	
			end
			// I - Load types
			7'b0000011: begin
				mem_rd = 1;
				reg_wr = 1;
				sel_wb = 0;
				sel_b = 1;
				mask = inst.funct3;
			end
			// S types
			7'b0100011: begin
				mem_wr = 1;
				sel_b = 1;	
				mask = inst.funct3;	
			end
			// B types
			7'b1100011: begin
				 sel_a = 1;
				 sel_b = 1;
				 alu_op = 0;
			     br_type = inst.funct3;
			end
			// J type
			7'b1101111: begin
				sel_a = 1;
				sel_b = 1;
				alu_op = 0;	
			end
			default: begin
				sel_a = '0;
				sel_b = '0;
				sel_wb = '0;
				mem_wr = '0;
				mem_rd = '0;
				mask = '0;
				alu_op = '0;
				reg_wr = '0;
				br_type = '0;
			end
		endcase
  end
endmodule

