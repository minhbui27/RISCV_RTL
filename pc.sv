`timescale 1ns/1ns

module pc (
	input logic 		clk,
	input logic 		rst,
	input logic 		stall_F,
	input logic [31:0] 	pc_i,
	output logic [31:0] pc_o
);
	logic [31:0] pc_buf_d, pc_buf_q;
	// implemented as a buffer
	always @(posedge clk) begin
		if (rst) begin
			pc_buf_q <= '0;
		end
		else begin
			pc_buf_q <= pc_buf_d;
		end
	end

	always_comb begin
		if(stall_F) begin
			pc_buf_d = pc_buf_q;
			pc_o = 0;
		end	
		else begin
			pc_buf_d = pc_i;
			pc_o = pc_buf_q;
		end
	end
endmodule
