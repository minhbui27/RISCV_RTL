`timescale 1ns/1ns

module pipe_memory(
	input logic			clk,
	input logic			rst,
	input logic			stall,
	input logic			flush,
	
	// control signals
	input logic			reg_wr_M,
	input logic			sel_wb_M,

	output logic 		reg_wr_W,
	output logic 		sel_wb_W,

	// datapath signals
	input logic 		alu_o_M,
	input logic 		rd_data_M,
	input logic [31:0] 	PC4_M,
	input logic [4:0]	rd_M,

	output logic 		alu_o_W,
	output logic 		rd_data_W,
	output logic [31:0] PC4_W,
	output logic [4:0]	rd_W
);

	typedef struct packed {
		logic reg_wr;
		logic sel_wb;
	} control_t;

	// control flip-flops
	control_t control_d, control_q;

	typedef struct packed {
		logic alu_o;
		logic rd_data;
		logic [31:0] PC4;
		logic [4:0] rd;
	} datapath_t;

	// datapath flip-flops
	datapath_t datapath_d, datapath_q;

	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			control_q <= 0;
			datapath_q <= 0;
		end else begin
			control_q <= control_d;
			datapath_q <= datapath_d;
		end
	end

	always_comb begin
		if (stall) begin
			control_d <= control_q;
			reg_wr_W <= 0;
			sel_wb_W <= 0;

			datapath_d <= datapath_q;
			alu_o_W <= 0;
			rd_data_W <= 0;
			PC4_W <= 0;
			rd_W <= 0;
		end
		else if (flush)	begin
			control_d <= 0;
			reg_wr_W <= 0;
			sel_wb_W <= 0;

			datapath_d <= 0;
			alu_o_W <= 0;
			rd_data_W <= 0;
			PC4_W <= 0;
			rd_W <= 0;
		end
		else begin
			alu_o_W <= datapath_q.alu_o;
			rd_data_W <= datapath_q.rd_data;
			PC4_W <= datapath_q.PC4;
			rd_W <= datapath_q.rd;

			datapath_d.alu_o <= alu_o_M;
			datapath_d.rd_data <= rd_data_M;
			datapath_d.PC4 <= PC4_M;
			datapath_d.rd <= rd_M;

			reg_wr_W <= control_q.reg_wr;
			sel_wb_W <= control_q.sel_wb;

			control_d.reg_wr <= reg_wr_M;
			control_d.sel_wb <= sel_wb_M;
		end
	end
endmodule
