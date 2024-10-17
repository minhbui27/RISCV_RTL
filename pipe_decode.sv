`timescale 1ns/1ns

module pipe_decode(
	input logic clk,
	input logic reset,
	input logic stall,
	input logic flush,

	// datapath signals
	input logic [31:0]	rs1_data_D,
	input logic [31:0]	rs2_data_D,
	input logic [31:0]	imm_o_D,
	input logic [6:0]	brc_input_D,
	input logic [31:0]	PC_D,
	input logic [31:0]	PC4_D,
	input logic [4:0]	rd_D

	output logic [31:0] rs1_data_E,
	output logic [31:0] rs2_data_E,
	output logic [31:0] imm_o_E,
	output logic [6:0]	brc_input_E,
	output logic [31:0] PC_E,
	output logic [31:0] PC4_E,
	output logic [4:0]	rd_E,

	// control signals
	input logic 		reg_wr_D,
	input logic [2:0]	br_type_D,
	input logic			sel_a_D,
	input logic 		sel_b_D,
	input logic [3:0] 	alu_op_D,
	input logic			mem_wr_D,
	input logic 		mem_rd_D,
	input logic [2:0] 	mem_mask_D,
	input logic	[1:0]	set_wb_D,

	output logic 		reg_wr_D,
	output logic [2:0]	br_type_D,
	output logic		sel_a_D,
	output logic 		sel_b_D,
	output logic [3:0] 	alu_op_D,
	output logic		mem_wr_D,
	output logic 		mem_rd_D,
	output logic [2:0] 	mem_mask_D,
	output logic [1:0]	set_wb_D
);

	// datapath signals
    typedef struct packed {
        logic [31:0] rs1_data;
        logic [31:0] rs2_data;
        logic [31:0] imm_o;
        logic [6:0]  brc_input;
        logic [31:0] PC;
        logic [31:0] PC4;
        logic [4:0]  rd;
    } datapath_t;

    // flip-flops for datapath
    datapath_t datapath_q, datapath_d;

    // control signals
    typedef struct packed {
        logic        reg_wr;
        logic [2:0]  br_type;
        logic        sel_a;
        logic        sel_b;
        logic [3:0]  alu_op;
        logic        mem_wr;
        logic        mem_rd;
        logic [2:0]  mem_mask;
        logic [1:0]  set_wb;
    } control_t;

    // flip-flops for control signals
    control_t control_q, control_d;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            datapath_q <= '0; // Reset all datapath signals to 0
            control_q  <= '0; // Reset all control signals to 0
        end else begin
            datapath_q <= datapath_d; // Transfer data on clock edge
            control_q  <= control_d;
        end
    end

    // Combinational logic to assign inputs to the next-state (d) registers
    always_comb begin
        if (stall) begin
            // Pipe output back to input to hold the current state
            datapath_d 	= datapath_q;
            control_d  	= control_q;
			rs1_data_E  = 0;
			rs2_data_E  = 0;
			imm_o_E     = 0;
			brc_input_E = 0;
			PC_E        = 0;
			PC4_E       = 0;
			rd_E        = 0;
			reg_wr_E    = 0;
			br_type_E   = 0;
			sel_a_E     = 0;
			sel_b_E     = 0;
			alu_op_E    = 0;
			mem_wr_E    = 0;
			mem_rd_E    = 0;
			mem_mask_E  = 0;
			set_wb_E    = 0;
        end
        else if (flush) begin
            // Reset the pipeline stage when flushing
            datapath_d = '0;
            control_d  = '0;
        end
        else begin
			// Output assignments from the registered (q) state
			rs1_data_E  = datapath_q.rs1_data;
			rs2_data_E  = datapath_q.rs2_data;
			imm_o_E     = datapath_q.imm_o;
			brc_input_E = datapath_q.brc_input;
			PC_E        = datapath_q.PC;
			PC4_E       = datapath_q.PC4;
			rd_E        = datapath_q.rd;

			reg_wr_E    = control_q.reg_wr;
			br_type_E   = control_q.br_type;
			sel_a_E     = control_q.sel_a;
			sel_b_E     = control_q.sel_b;
			alu_op_E    = control_q.alu_op;
			mem_wr_E    = control_q.mem_wr;
			mem_rd_E    = control_q.mem_rd;
			mem_mask_E  = control_q.mem_mask;
			set_wb_E    = control_q.set_wb;

			// Normal operation: pass inputs into flip-flops
            datapath_d.rs1_data  = rs1_data_D;
            datapath_d.rs2_data  = rs2_data_D;
            datapath_d.imm_o     = imm_o_D;
            datapath_d.brc_input = brc_input_D;
            datapath_d.PC        = PC_D;
            datapath_d.PC4       = PC4_D;
            datapath_d.rd        = rd_D;

            control_d.reg_wr     = reg_wr_D;
            control_d.br_type    = br_type_D;
            control_d.sel_a      = sel_a_D;
            control_d.sel_b      = sel_b_D;
            control_d.alu_op     = alu_op_D;
            control_d.mem_wr     = mem_wr_D;
            control_d.mem_rd     = mem_rd_D;
            control_d.mem_mask   = mem_mask_D;
            control_d.set_wb     = set_wb_D;
        end
    end

endmodule

