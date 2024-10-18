`timescale 1ns/1ns

module RAW_Hazard(
	input logic mem_flag,
	input logic wb_flag,
	input logic [3:0] rs,
	input logic [3:0] rt,
	input logic [3:0] mem_wrt_dst,
	input logic [3:0] wb_wrt_dst,
	output logic Fwd_rs_1,
	output logic Fwd_rt_1,
	output logic Fwd_rs_2,
	output logic Fwd_rt_2

);

always_comb begin
	// Dependent instruction in MEM
	if (mem_flag==1) begin
		if (mem_wrt_dst==rs) 
			Fwd_rs_1=1;
		else if (mem_wrt_dst==rt)
			Fwd_rt_1=1;
	end
	// Dependent instruction in WB	
	else if (wb_flag==1 && wb_wrt_dst==rs) begin
		if (mem_wrt_dst != rs) // check if MEM is overritten
			Fwd_rs_2=1;
		else
			Fwd_rs_2=0;
	end 
	else if (wb_flag==1 && wb_wrt_dst==rt) begin
		if (mem_wrt_dst != rs) // check if MEM is overritten
			Fwd_rt_2=1;
		else
			Fwd_rt_2=0;
	end 
	// No Fowarding needed
	else begin
		Fwd_rs_1 = 0;
		Fwd_rt_1 = 0;
		Fwd_rs_2 = 0;
		Fwd_rt_2 = 0;
	end
	
end
endmodule
