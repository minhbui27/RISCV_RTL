`timescale 1ns/1ns

module pc (
	input logic 		clk,
	input logic 		rst,
	input logic [31:0] 	pc_i,
	output logic [31:0] pc_o
);

	// implemented as a buffer
	always @(posedge clk) begin
		if (rst) begin
			pc_o <= 32'h0;
		end
		else begin
			pc_o <= pc_i;
		end
	end
endmodule
