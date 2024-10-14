`timescale 1ns/1ns
module sc_tb();
	// wires
	logic clk, rst;	
	// pc wires
	logic [31:0] pc4, pc_o;

	// module instantiations
	pc pc(
		.clk (clk),
		.rst (rst),
		.pc_i(pc4),
		.pc_o(pc_o)
	);
	
	pc_add4 pc_add(
		.pc_o(pc_o),
		.pc_pc4(pc4)
	);

	// create clock
	initial begin
		forever begin
			clk <= 0;
			#1;
			clk <= 1;
			#1;
		end
	end

	initial begin
		rst <= 1;
		#10;
		rst <= 0;
		

		#200;
		$finish;
	end
endmodule
