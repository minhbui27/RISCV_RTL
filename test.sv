// pipe stage
module test(
	input stall,
	input flush,
	input rst,
	input clk,
	input in,
	output logic out 
);
	logic buff_d, buff_q; 

	always_ff @(posedge clk) begin
		if(rst) buff_q <= 0;
		else begin
			buff_q <= buff_d;
		end
	end
	
	always_comb begin
		if(stall) begin
			buff_d = buff_q;
			out = 0;
		end
		else if(flush) begin
			buff_d = 0;
			out = 0;
		end
		else begin
			out = buff_q;
			buff_d = in;
		end
	end
endmodule
