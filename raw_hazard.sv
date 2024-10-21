`timescale 1ns/1ns

module raw_hazard (
	input logic [4:0] rs1_E,
	input logic [4:0] rs2_E,
	input logic [4:0] rs2_M,
	input logic [4:0] rdM,
	input logic [4:0] rdW,
	input logic reg_wr_M,
	input logic	reg_wr_W,
	
	output logic [1:0] forwardAE,
	output logic [1:0] forwardBE,
	output logic forwardM,
	output logic forwardCM
);

	always_comb begin
		forwardAE = '0;
		forwardBE = '0;
        forwardM = 0;
        forwardCM = 0;
		if (((rs1_E == rdM) & reg_wr_M) & rs1_E != 0) begin
			forwardAE = 2'b11;
		end
		else if (((rs1_E == rdW) & reg_wr_W) & rs1_E != 0) begin
			forwardAE = 2'b01;
		end

		if (((rs2_E == rdM) & reg_wr_M) & rs2_E != 0) begin
			forwardBE = 2'b11;
		end
		else if (((rs2_E == rdW) & reg_wr_W) & rs2_E != 0) begin
			forwardBE = 2'b01;
		end
		
		// sw before written to reg file
		if(rs2_M == rdW && rdW != 0) begin
		  forwardM = 1;
		end
		
		if(rs2_E == rdW && rdW != 0) begin
		  forwardCM = 1;
		end
	end
endmodule

