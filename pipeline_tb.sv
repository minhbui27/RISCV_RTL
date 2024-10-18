`timescale 1ns/1ns

// instructions being tested are listed in the imem

module pipeline_tb();
	// wires
	logic clk, rst;	
	
	// Fetch stage wires
	logic [31:0] pc_i, PC_F, PC4_F, inst_F;

	// Decode stage wires
	logic [31:0] inst_D, PC_D, PC4_D, imm_o_D, rs1_data_D, rs2_data_D;
	logic [4:0] rd_D;
	logic [6:0] brc_input_D;	

	logic reg_wr_D, sel_a_D, sel_b_D, mem_wr_D, mem_rd_D;
	logic [1:0] sel_wb_D;
	logic [2:0] br_type_D, mem_mask_D;
	logic [3:0] alu_op_D;

	assign brc_input_D = inst_D[6:0];
	assign rd_D = inst_D[11:7];

	// Execute stage wires
	logic [31:0] rs1_data_E, rs2_data_E, imm_o_E, PC_E, PC4_E, alu_o_E, mux_a_out, mux_b_out;	
	logic [4:0] rd_E;
	logic [6:0] brc_input_E;

	logic reg_wr_E, sel_a_E, sel_b_E, mem_wr_E, mem_rd_E;
	logic [1:0] sel_wb_E;
	logic [2:0] br_type_E, mem_mask_E;
	logic [3:0] alu_op_E;

	// Mem r/w stage wires
	logic [31:0] alu_o_M, wr_data_M, PC4_M, rd_data_M;	
	logic [4:0] rd_M;

	logic reg_wr_M, mem_wr_M, mem_rd_M;
	logic [1:0] sel_wb_M;
	logic [2:0] mem_mask_M;

	// Writeback stage wires
	logic reg_wr_W;
	logic [1:0] sel_wb_W;
	logic [31:0] alu_o_W, rd_data_W, PC4_W, mux_wb_out_W;
	logic [4:0] rd_W;

	//====================================== Fetch Stage ====================================== 
	pc pc(
		.clk (clk),
		.rst (rst),
		.pc_i(pc_i),
		.pc_o(PC_F)
	);
	
	pc_add4 pc_add(
		.pc_o(PC_F),
		.pc_pc4(PC4_F)
	);
   	
	mux2_1 pc_sel (
		.data1(PC4_F),
		.data2(alu_o_E),
		.sel(br_en_E),
		.mux_out(pc_i)
	); 

    imem imem_dut(
       .addr_i(PC_F),
       .instr_o(inst_F) 
    );

	//====================================== Decode Stage ====================================== 
    
    reg_file regf_dut (
        .clk(clk),
        .rst(rst),
        .reg_wr(reg_wr_W),
        .wr_data(mux_wb_out_W),
        .rs1_addr(inst_D[19:15]),
        .rs2_addr(inst_D[24:20]),
        .wr_addr(rd_W),
        .rs1_data(rs1_data_D),
        .rs2_data(rs2_data_D)
    );
        
    imm_gen imm_gen_dut (
        .inst(inst_D),
        .imm_o(imm_o_D)
    );

    main_ctrl main_ctrl_dut(
        .inst_i (inst_D),
        .reg_wr (reg_wr_D),
        .alu_op (alu_op_D),
        .sel_a (sel_a_D),
        .sel_b (sel_b_D),
        .mem_wr (mem_wr_D),
        .mem_rd (mem_rd_D),
        .mask (mem_mask_D),
        .sel_wb (sel_wb_D),
		.br_type (br_type_D)
    );

	//====================================== Execute Stage ====================================== 

    mux2_1 mux_a (
        .data1(PC_E),
        .data2(rs1_data_E),
        .sel(sel_a_E),
        .mux_out(mux_a_out)
    );
    
    mux2_1 mux_b (
        .data1(rs2_data_E),
        .data2(imm_o_E),
        .sel(sel_b_E),
        .mux_out(mux_b_out)
    );
    
	branch_ctrl branch_ctrl_dut (
		.br_type (br_type_E),
		.op_code (brc_input_E),
		.rs1_data (rs1_data_E),
		.rs2_data (rs2_data_E),
		.br_en (br_en_E)
	);

    alu alu_dut (
        .a (mux_a_out),
        .b (mux_b_out),
        .alu_op (alu_op_E),
        .alu_o (alu_o_E)
    );
   
	//====================================== Memory Stage ====================================== 
	
    dmem dmem_dut(
         .clk (clk),
         .addr (alu_o_M),
         .wr_data (wr_data_M),
         .mem_wr (mem_wr_M),
         .mem_rd (mem_rd_M),
         .mask  (mem_mask_M),
         .dmem_o (rd_data_M)
    );
   
	//====================================== Writeback Stage ====================================== 
    mux4_1 mux_wb_dut (
        .data1 (rd_data_W),
        .data2 (alu_o_W),
        .data3 (PC4_W),
        .data4 (PC4_W),
        .sel (sel_wb_W),
        .mux_o (mux_wb_out_W)
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

