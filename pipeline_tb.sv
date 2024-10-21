`timescale 1ns/1ns

// instructions being tested are listed in the imem

module pipeline_tb();
	// wires
	logic clk, rst;	
	
	// Fetch stage wires
	logic [31:0] pc_i, PC_F, PC4_F, inst_F;

	// Decode stage wires
	logic [31:0] inst_D, PC_D, PC4_D, imm_o_D, rs1_data_D, rs2_data_D;

	logic reg_wr_D, sel_a_D, sel_b_D, mem_wr_D, mem_rd_D;
	logic [1:0] sel_wb_D;
	logic [2:0] br_type_D, mem_mask_D;
	logic [3:0] alu_op_D;

    logic [4:0] rd_D;
	assign brc_input_D = inst_D[6:0];
	assign rd_D = inst_D[11:7];

	// Execute stage wires
	logic [31:0] rs1_data_E, rs2_data_E, imm_o_E, PC_E, PC4_E, alu_o_E, mux_a_out, mux_b_out, wr_data_E;	
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

	// Forward MUX selectors for E stage RAW hazard
	logic [1:0] forwardAE, forwardBE;
	logic [31:0] mux_fw_a, mux_fw_b, mux_fw_M;
	logic forwardM, forwardCM;
	// flush and stall signals
	logic stallF, stallD, flushD, flushE;	
	// rs1 and rs2 for hazard destination
	logic [4:0] rs1_addr_E, rs2_addr_E, rs2_addr_M;
	//====================================== Fetch Stage ====================================== 
	pc pc(
		.clk (clk),
		.rst (rst),
		.pc_i(pc_i),
		.pc_o(PC_F),
		.stallF(stallF)
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

	pipe_fetch pipe_fetch_dut (
		.clk (clk),
		.rst (rst),
		.stall (stallD),
		.flush (flushD),
		.INST_F (inst_F),
		.PC_F (PC_F),
		.PC4_F (PC4_F),
		.INST_D (inst_D),
		.PC_D (PC_D),
		.PC4_D (PC4_D)
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

	pipe_decode pipe_decode_dut (
		// inputs
		.clk			(clk),
		.reset			(rst),
		.flush			(flushE),
		.stall			('0),
		.rs1_data_D		(rs1_data_D),
		.rs2_data_D		(rs2_data_D),
		.imm_o_D		(imm_o_D),
		.brc_input_D	(inst_D[6:0]),
		.PC_D			(PC_D),
		.PC4_D			(PC4_D),
		.rd_D			(inst_D[11:7]),
		.reg_wr_D		(reg_wr_D),
		.br_type_D		(br_type_D),
		.sel_a_D		(sel_a_D),
		.sel_b_D		(sel_b_D),
 		.alu_op_D		(alu_op_D),
		.mem_wr_D		(mem_wr_D),
		.mem_rd_D		(mem_rd_D),
 		.mem_mask_D		(mem_mask_D),
		.sel_wb_D		(sel_wb_D),
		.rs1_addr_D		(inst_D[19:15]),
		.rs2_addr_D		(inst_D[24:20]),
		// outputs
		.rs1_data_E		(rs1_data_E),
		.rs2_data_E		(rs2_data_E),
		.imm_o_E		(imm_o_E),
		.brc_input_E	(brc_input_E),
		.PC_E			(PC_E),
		.PC4_E			(PC4_E),
		.rd_E			(rd_E),
		.reg_wr_E		(reg_wr_E),
		.br_type_E		(br_type_E),
		.sel_a_E		(sel_a_E),
		.sel_b_E		(sel_b_E),
 		.alu_op_E		(alu_op_E),
		.mem_wr_E		(mem_wr_E),
		.mem_rd_E		(mem_rd_E),
 		.mem_mask_E		(mem_mask_E),
		.sel_wb_E		(sel_wb_E),
		.rs1_addr_E		(rs1_addr_E),
		.rs2_addr_E		(rs2_addr_E)

	);
	//====================================== Execute Stage ====================================== 
	mux4_1 forward_a (
		.data1(rs1_data_E),
		.data2(mux_wb_out_W),
		.data3(mux_wb_out_W),
		.data4(alu_o_M),
		.sel(forwardAE),
		.mux_o(mux_fw_a)
	);

	mux4_1 forward_b (
		.data1(rs2_data_E),
		.data2(mux_wb_out_W),
		.data3(mux_wb_out_W),
		.data4(alu_o_M),
		.sel(forwardBE),
		.mux_o(mux_fw_b)
	);

    mux2_1 mux_a (
        .data1(mux_fw_a),
        .data2(PC_E),
        .sel(sel_a_E),
        .mux_out(mux_a_out)
    );
    
    mux2_1 mux_b (
        .data1(mux_fw_b),
        .data2(imm_o_E),
        .sel(sel_b_E),
        .mux_out(mux_b_out)
    );
    
    mux2_1 forward_ce (
        .data1(rs2_data_E),
        .data2(alu_o_W),
        .sel(forwardCM),
        .mux_out(wr_data_E)
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
   
	pipe_execute pipe_execute_dut (
		// input()s
		.clk			(clk),
		.rst			(rst),
		.stall			('0),
		.flush			('0),
		.reg_wr_E		(reg_wr_E),
		.mem_wr_E		(mem_wr_E),
		.mem_rd_E		(mem_rd_E),
		.mem_mask_E		(mem_mask_E),
		.sel_wb_E		(sel_wb_E),
		.alu_o_E		(alu_o_E),
		.wr_data_E		(wr_data_E),
		.rd_E			(rd_E),
		.PC4_E			(PC4_E),
		.rs2_addr_E     (rs2_addr_E),
		// output()s
		.alu_o_M		(alu_o_M),
		.wr_data_M		(wr_data_M),
		.rd_M			(rd_M),
 		.PC4_M			(PC4_M),
		.reg_wr_M		(reg_wr_M),
		.mem_wr_M		(mem_wr_M),
		.mem_rd_M		(mem_rd_M),
 		.mem_mask_M		(mem_mask_M),
		.sel_wb_M		(sel_wb_M),
		.rs2_addr_M     (rs2_addr_M)  
	);
	//====================================== Memory Stage ====================================== 
	
	mux2_1 muxM (
        .data1(wr_data_M),
	    .data2(alu_o_W),
	    .sel(forwardM),
	    .mux_out(mux_fw_M)
	);	
    
    dmem dmem_dut(
         .clk (clk),
         .addr (alu_o_M),
         .wr_data (mux_fw_M),
         .mem_wr (mem_wr_M),
         .mem_rd (mem_rd_M),
         .mask  (mem_mask_M),
         .dmem_o (rd_data_M)
    );
   
	pipe_memory pipe_mem_dut (
		.clk			(clk),
		.rst			(rst),
		.stall			('0),
		.flush			('0),
		.reg_wr_M		(reg_wr_M),
		.sel_wb_M		(sel_wb_M),
		.alu_o_M		(alu_o_M),
		.rd_data_M		(rd_data_M),
		.PC4_M			(PC4_M),
		.rd_M			(rd_M),
		.alu_o_W		(alu_o_W),
		.rd_data_W		(rd_data_W),
		.PC4_W			(PC4_W),
		.rd_W			(rd_W),
		.reg_wr_W		(reg_wr_W),
		.sel_wb_W		(sel_wb_W)
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
	

	//====================================== Hazard Unit ====================================== 
	hazard_unit hazard_unit_dut (
		.rs1_D			(inst_D[19:15]),
		.rs2_D			(inst_D[24:20]),
	
		.rd_E			(rd_E),
		.rd_M			(rd_M),
		.rd_W			(rd_W),
		.rs1_E			(rs1_addr_E),
		.rs2_E			(rs2_addr_E),
		.rs2_M          (rs2_addr_M),
		.reg_wr_M		(reg_wr_M),
		.reg_wr_W		(reg_wr_W),
		.br_en_E		(br_en_E),
		.sel_wb_E		(sel_wb_E),
	
		.stallF			(stallF),
		.stallD			(stallD),
		.flushE			(flushE),
		.flushD			(flushD),
	
		.forwardAE		(forwardAE),
		.forwardBE		(forwardBE),
		.forwardM       (forwardM),
		.forwardCM      (forwardCM)
	
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
		#2;
		rst <= 0;
		

		#200;
		$finish;
	end
endmodule

