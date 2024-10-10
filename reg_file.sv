`timescale 1ns/1ns
module reg_file(
    input logic clk,
    input logic rst,
    input logic reg_wr,
    input logic [31:0] wr_data,
    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,
    input logic [4:0] wr_addr,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
	logic [31:0] register [31:0];
    integer i;
    always @(posedge clk)
        begin 
            if (rst)
                begin 
                    for (i=0; i<32; i=i+1)
                        register[i] <= 32'h0000_0000;
                end
        end
    assign	rs1_data = register[rs1_addr];
    assign	rs2_data = register[rs2_addr];

always @(negedge clk)
begin
	if(reg_wr & (wr_addr!=5'b00000))	
		register[wr_addr] <= wr_data;
end
    
endmodule    
