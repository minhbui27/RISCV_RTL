`timescale 1ns/1ns

module pipe_decode(
	input logic clk,
	input logic reset,
	input logic rd1_d,
	input logic rd2_d,
	input logic pc_d,
	input logic rd_d,
	input logic imm_ext_d,
	input logic pc_plus_4_d,	
	output logic rd1_e,
	output logic rd2_e,
	output logic pc_e,
	output logic rd_e,
	output logic imm_ext_e,
	output logic pc_plus_4_e
);

always_ff @(posedge clk, posedge reset)
	if (reset) begin
		rd1_e <= 0;
    	rd2_e <= 0;
    	pc_e <= 0;
    	rd_e <= 0;
    	imm_ext_e <= 0;
		pc_plus_4_e <= 0;
	end
	else begin
		rd1_e <= rd1_d;
    	rd2_e <= rd2_d;
    	pc_e <= pc_d;
    	rd_e <= rd_d;
    	imm_ext_e <= imm_ext_e;
		pc_plus_4_e <= pc_plus_4_e;
	end
endmodule
