`timescale 1ns/1ns

module hazard_unit (
	input logic [4:0] rs1_D,
	input logic [4:0] rs2_D,

	input logic [4:0] rd_E,
	input logic [4:0] rd_M,
	input logic [4:0] rd_W,
	input logic [4:0] rs1_E,
	input logic [4:0] rs2_E,
	input logic	reg_wr_M,
	input logic reg_wr_W,
	input logic br_en_E,
	input logic [1:0] sel_wb_E,

	output logic stallF,
	output logic stallD,
	output logic flushE,
	output logic flushD,

	output logic [1:0] forwardAE,
	output logic [1:0] forwardBE
);
	logic flushE_stall, flushE_branch;
	assign flushE = flushE_stall | flushE_branch;
	stall_hazard stall_hazard_i (
		.rs1_addr_D (rs1_D),	
		.rs2_addr_D (rs2_D),	
		.rd_E 		(rd_E),
		.sel_wb_E	(sel_wb_E),
		.stallF		(stallF),
		.stallD		(stallD),
		.flushE		(flushE_stall)
	);

	raw_hazard raw_hazard_i (
		.rs1_E		(rs1_E),
		.rs2_E		(rs2_E),
		.rdM		(rd_M),
		.rdW		(rd_W),
		.reg_wr_M	(reg_wr_M),
		.reg_wr_W	(reg_wr_W),
		.forwardAE	(forwardAE),
		.forwardBE	(forwardBE)
	);

	branch_handler branch_handler_i (
		.br_en_E	(br_en_E),
		.flushD		(flushD),
		.flushE		(flushE_branch)
	);

endmodule
