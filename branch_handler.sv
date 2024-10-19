module branch_handler (
	input logic br_en_E,
	output logic flushD,
	output logic flushE
);
	always_comb begin
		flushD = br_en_E;
		flushE = br_en_E;	
	end
endmodule
