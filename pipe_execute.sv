`timescale 1ns/1ns

module pipe_execute(
	input logic clk,
	input logic reset,
	input logic alu_result_e,
	input logic write_data_e,
	input logic rd_e,
	input logic pc_plus_4_e,
	output logic alu_result_m,
    output logic write_data_m,
    output logic rd_m,
    output logic pc_plus_4_m
);

always_ff @(posedge clk, posedge reset)
	if (reset) begin
		alu_result_m <= 0;
		write_data_m <= 0;
		rd_m <= 0;
		pc_plus_4_m <= 0;
	end else begin
		alu_result_m <= alu_result_e;
        write_data_m <= write_data_e;
        rd_m <= rd_e;
        pc_plus_4_m <= pc_plus_4_e;
	end
endmodule
