module pc (
	input logic 		clk,
	input logic 		rst,
	input logic [31:0] 	pc_i,
	output logic [31:0] pc_o
);
	logic [31:0] pc_d, pc_q;
	assign pc_o = pc_d;
	assign pc_d = pc_i + 32'h4;

	always @(posedge clk) begin
		if (rst) begin
			pc_q <= 32'h0;
		end
		// increment pc by 4 on clock edge
		else begin
			pc_q <= pc_d;
		end
	end
endmodule
