// this module handles hazards where we are lw-ing, so getting data at the end
// of mem stage and trying to pass it to the start of execute state for ALU
module stall_hazard (
	input logic [4:0] rs1_addr_D,	
	input logic [4:0] rs2_addr_D,	
	input logic [4:0] rd_E,
	input logic [1:0] sel_wb_E,
	output logic stallF,
	output logic stallD,
	output logic flushE
);
	always_comb begin
	    stallF = 0;
		stallD = 0;
		flushE = 0;
		// if a lw is in the execute stage - sel_wb_E = 00, and
		// if the load's destination register is equal to either of the source
		// then we have a lw hazard, must stall pipes F,D flush E
		if(sel_wb_E == 0 && ((rs1_addr_D == rd_E) | (rs2_addr_D == rd_E)) && rd_E != 0) begin
			stallF = 1;
			stallD = 1;
			flushE = 1;
		end
	end
endmodule

