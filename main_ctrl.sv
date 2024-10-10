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
    output logic [ 1:0] sel_wb
); 
	typedef struct packed {
		logic [6:0] funct7;
		logic [4:0] rs2;
		logic	[4:0] rs1;
		logic	[2:0]	funct3; 
		logic	[4:0]	rd;
		logic	[6:0] opcode;
	} inst_t;

	inst_t inst;
	assign inst = inst_t'(inst_i);

  always_comb begin : mux_control
		// Only doing R,I,S types for now	
		case (inst.opcode)
			7'b0110011: begin
				
			end
			default :	alu_op = 0;
		endcase
  end
endmodule
