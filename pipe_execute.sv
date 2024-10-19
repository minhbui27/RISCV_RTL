`timescale 1ns/1ns

module pipe_execute(
	input logic 		clk,
	input logic 		rst,
	input logic 		stall,
	input logic 		flush,

	// control signals
	input logic 		reg_wr_E,
	input logic 		mem_wr_E,
	input logic 		mem_rd_E,
	input logic [2:0] 	mem_mask_E,
	input logic [1:0] 	sel_wb_E,

	output logic 		reg_wr_M,
	output logic 		mem_wr_M,
	output logic 		mem_rd_M,
	output logic [2:0] 	mem_mask_M,
	output logic [1:0] 	sel_wb_M,

	// datapath signals
	input logic [31:0]	alu_o_E,
	input logic [31:0]	wr_data_E,
	input logic [4:0]	rd_E,
	input logic [31:0]	PC4_E,

	output logic [31:0] alu_o_M,
	output logic [31:0] wr_data_M,
	output logic [4:0]	rd_M,
	output logic [31:0] PC4_M
);

	// control signals
	typedef struct packed {
		logic		reg_wr;
		logic 		mem_wr;
		logic 		mem_rd;
		logic [2:0] mem_mask;
		logic [1:0] sel_wb;
	} control_t;

	// flip-flips for buffering control
	control_t control_d, control_q;

	// datapath signals
	typedef struct packed {
		logic [31:0]	alu_o;
		logic [31:0]	wr_data;
		logic [4:0] 	rd;
		logic [31:0]	PC4;
	} datapath_t;

	// flip-flops for datapath
	datapath_t datapath_d, datapath_q;

	always_ff @(posedge clk) begin
		if (rst) begin
			control_q	<= 0;
			datapath_q	<= 0;
		end else begin
			control_q	<= control_d;
			datapath_q	<= datapath_d;
		end
	end

	always_comb begin
			reg_wr_M	= 0;
			mem_wr_M	= 0;
			mem_rd_M	= 0;
			mem_mask_M	= 0;
			sel_wb_M	= 0;
			alu_o_M		= 0;
			wr_data_M	= 0;
			rd_M		= 0;
			PC4_M		= 0;
		if (stall) begin
			control_d	= control_q;
			datapath_d	= datapath_q;
		end
		else if (flush) begin
			control_d	 = 0;
			datapath_d	 = 0;
		end
		else begin
			// control
			reg_wr_M 	= control_q.reg_wr;
			mem_wr_M 	= control_q.mem_wr;
			mem_rd_M 	= control_q.mem_rd;
			mem_mask_M	= control_q.mem_mask;
			sel_wb_M 	= control_q.sel_wb;

			control_d.reg_wr	= reg_wr_E;
			control_d.mem_wr	= mem_wr_E;
			control_d.mem_rd	= mem_rd_E;
			control_d.mem_mask	= mem_mask_E;
			control_d.sel_wb	= sel_wb_E;

			// datapath
			alu_o_M 	= datapath_q.alu_o;
			wr_data_M 	= datapath_q.wr_data;
			rd_M		= datapath_q.rd;
			PC4_M 		= datapath_q.PC4;

			datapath_d.alu_o	= alu_o_E;
			datapath_d.wr_data	= wr_data_E;
			datapath_d.rd		= rd_E;
			datapath_d.PC4		= PC4_E;
		end
	end
endmodule
