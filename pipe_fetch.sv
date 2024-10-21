`timescale 1ns/1ns

module pipe_fetch(
	input logic			clk,
	input logic			rst,
	input logic			flush,
	input logic			stall,
	input logic [31:0]	INST_F,
	input logic	[31:0]	PC_F,
	input logic	[31:0]	PC4_F,
	output logic [31:0] INST_D,
	output logic [31:0] PC_D,
	output logic [31:0] PC4_D
);
	// flip-flops to buffer signals during flushes
	logic [31:0] INST_buff_d, INST_buff_q;
	logic [31:0] PC_buff_d, PC_buff_q;
	logic [31:0] PC4_buff_d, PC4_buff_q;

	always_ff @(posedge clk) begin
		if (rst) begin
			INST_buff_q <= 0;
			PC_buff_q <= 0;
			PC4_buff_q <= 0;
		end
		else begin
			INST_buff_q <= INST_buff_d;
			PC_buff_q <= PC_buff_d;
			PC4_buff_q <= PC4_buff_d;
		end
	end


	always_comb begin
		INST_D = INST_buff_q;
			PC_D = PC_buff_q;
			PC4_D = PC4_buff_q;
		
		if (stall) begin
			// pipe output back to input to save for next cycle
			INST_buff_d = INST_buff_q;
			PC_buff_d = PC_buff_q;
			PC4_buff_d = PC4_buff_q;	
		end
		else if (flush) begin
			INST_buff_d = 0;
			PC_buff_d = 0;
			PC4_buff_d = 0;
			INST_D = 0;
		    PC_D = 0;
		    PC4_D = 0;
		end
		else begin
			INST_buff_d = INST_F;
			PC_buff_d = PC_F;
			PC4_buff_d = PC4_F;
		end
	end
endmodule
