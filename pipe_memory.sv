`timescale 1ns/1ns

module pipe_memory(
	input logic clk,
	input logic reset,
	input logic alu_result_m,
	input logic read_data_m,
	input logic rd_m,
	input logic pc_plus_4_m,
	output logic alu_result_w,
    output logic read_data_w,
    output logic rd_w,
    output logic pc_plus_4_w
);

always_ff @(posedge clk, posedge reset)
	if (reset) begin
		alu_result_w <= 0;
        read_data_w <= 0;
        rd_w <= 0;
        pc_plus_4_w <= 0;
	end else begin
		alu_result_w <= alu_result_m;
        read_data_w <= read_data_m;
        rd_w <=  rd_m;
        pc_plus_4_w <= pc_plus_4_m;
	end
endmodule
