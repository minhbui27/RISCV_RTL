`timescale 1ns/1ns
module dmem (
    input  logic [31:0] addr,
    input  logic [31:0] wr_data,
    input  logic        mem_wr,
    input  logic        mem_rd,
    input  logic [2:0]  mask,
    input  logic        clk,
    output logic [31:0] dmem_o
);

    logic [31:0] temp_rd;
    logic [31:0] temp_wr;
    logic [31:0] mem[63:0];
    integer i;
	// Initializing data memory
	initial
	begin
		for (i=0; i<64; i=i+1)
			mem[i] = 32'h0000_0000;
	end
    
    // index mem
    always_comb begin
        if(mem_rd) temp_rd = mem[addr[31:2]];
        else temp_rd = '0;
    end
    
    
	// Combinational Read - Temporary Data to Read
	always_comb
	begin
	   dmem_o = '0;
		if (mem_rd)
		begin
			case (mask)
				3'b000:	// Load Byte (Signed)
				begin
					case (addr[1:0])	// Load a byte (8bit) with 24 extended sign bits 
						2'b00:	dmem_o = {{24{temp_rd[7]}}, temp_rd[7:0]};
						2'b01:  dmem_o = {{24{temp_rd[15]}}, temp_rd[15:8]};
						2'b10:  dmem_o = {{24{temp_rd[23]}}, temp_rd[23:16]};
						2'b11:  dmem_o = {{24{temp_rd[31]}}, temp_rd[31:24]};
					endcase
				end
				3'b001:	// Load Half-Word (Signed)
				begin
					case (addr[1])
						1'b0:	dmem_o = {{16{temp_rd[15]}}, temp_rd[15:0]};
						1'b1:	dmem_o = {{16{temp_rd[31]}}, temp_rd[31:16]};
					endcase
				end
				3'b010:	// Load Word
				begin
					dmem_o <= temp_rd;
				end
				3'b100:	// Load Byte (Unsigned)
				begin
					case (addr[1:0])        // Load a byte (8bit) with 24 extended '0' bits 
											2'b00:  dmem_o = {24'h0000_00, temp_rd[7:0]};
											2'b01:  dmem_o = {24'h0000_00, temp_rd[15:8]};
											2'b10:  dmem_o = {24'h0000_00, temp_rd[23:16]};
											2'b11:  dmem_o = {24'h0000_00, temp_rd[31:24]};
									endcase
				end
				3'b101:	// Load Half-Word (Unsigned)
				begin
					case (addr[1])
											1'b0:   dmem_o = {16'h0000, temp_rd[15:0]};
											1'b1:   dmem_o = {16'h0000, temp_rd[31:16]};
									endcase
				end
				default:
					dmem_o = 32'h0000_0000;
			endcase
		end
		else
			dmem_o = temp_rd;
	end

	// Sequential Write - Temporary data to write
	always_comb 
	begin
	    temp_wr = 0;
		if (mem_wr)
		begin
			case (mask)
				3'b000:	// Store Byte
				begin
					case (addr[1:0])
						2'b00:	temp_wr = {24'h0000_00, wr_data[7:0]};
						2'b01:	temp_wr = {24'h0000_00, wr_data[15:8]};
						2'b10:  temp_wr = {24'h0000_00, wr_data[23:16]};
						2'b11:  temp_wr = {24'h0000_00, wr_data[31:24]};
					endcase
				end
				3'b001:	// Store Half-Word
				begin
					case (addr[1])
											1'b0:   temp_wr = {16'h0000, wr_data[15:0]};
											1'b1:   temp_wr = {16'h0000, wr_data[31:16]};
									endcase
				end
				3'b010:	// Store Word
				begin
					temp_wr = wr_data;
				end
				default: temp_wr = 0;
			endcase
		end
	end	

	// Sequential Write - Write data to memory w.r.t. mask[2:0] and addr[1:0]
	always @(negedge clk)
	begin
		if (mem_wr)
			mem[addr[31:2]] <= temp_wr;	// Upper 30bits of addr = Row Address of DMEM - Lower 2bits: Column Byte Address
	end

endmodule
