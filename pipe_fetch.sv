`timescale 1ns/1ns

module pipe_fetch(
	input logic			clk,
	input logic			reset,
	input logic [31:0]	INST_F,
	input logic	[31:0]	PC_F,
	input logic	[31:0]	PC4_F,
	output logic [31:0] INST_D,
	output logic [31:0] PC_D,
	output logic [31:0] PC4_D
);

always_ff @(posedge clk, posedge reset)
	if (reset) begin
		inst_d <= 0;
		pc_d <= 0;
		pc_plus_4_d <= 0;
	end
	else begin
		inst_d <= inst_f;
		pc_d <= pc_f;
		pc_plus_4_d <= pc_plus_4_f;
	end
endmodule
