`timescale 1ns/1ns

module RAW_Hazard(
	input logic [3:0] rs1,    // src reg from EXE
	input logic [3:0] rs2,    // src reg from EXE
	input logic reg_wr_M,     // flag to know if dst reg actually written to
	input logic reg_wr_W,
	input logic [3:0] rdM,    // dst reg from Mem
	input logic [3:0] rdW, 	  // dst reg from WB
	output logic [1:0] FwdAE, // mux sel o/p signals
	output logic [1:0] FwdBE  // 0 no fwd, 1 fwd from WB, 2 fwd from MEM

);

always_comb begin
	if (((rs1==rdM) && reg_wr_M) && (rs1!=0))
		FwdAE = 2;
	else if (((rs1== rdW) & reg_wr_W) & (rs1!=0))
		FwdAE = 1;
	else
		FwdAE=0;
	if (((rs2==rdM) && reg_wr_M) && (rs2!=0))
		FwdBE = 2;
	else if (((rs2== rdW) && reg_wr_W) && (rs2!=0))
		FwdBE = 1;
	else
		FwdBE=0;
end
endmodule
