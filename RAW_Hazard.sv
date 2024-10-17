`timescale 1ns/1ns

module hazard(
	input logic write_to_mem,
	input logic [3:0] Reg_rs,
	input logic [3:0] Reg_rt,
	input logic wrt_dst,
	output logic Fwd_rs,
	output logic Fwd_rt
);

always_comb begin
	if (write_to_mem==1 && wrt_dst==Reg_rs) begin
		Fwd_rs = 1;
	end else begin 
		Fwd_rs = 0;
	end
	if (write_to_mem==1 && wrt_dst==Reg_rt) begin
		Fwd_rt = 1;
	end else begin 
		Fwd_rt = 0;
	end
end
endmodule
