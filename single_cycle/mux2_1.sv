`timescale 1ns/1ns

module mux2_1 (
    input logic [31:0] data2,
    input logic [31:0] data1,
	input logic 	   sel,
	output logic [31:0] mux_out 
);
	assign mux_out = sel ? data2 : data1;
endmodule
