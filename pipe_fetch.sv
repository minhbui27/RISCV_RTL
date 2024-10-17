`timescale 1ns/1ps

module pipe_fetch(
	input logic	 clk,
	input logic  reset,
	input logic	 inst_f,
	input logic	 pc_f,
	input logic	 pc_plus_4_f,
	output logic inst_d,
	output logic pc_d,
	output logic pc_plus_4_d
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
