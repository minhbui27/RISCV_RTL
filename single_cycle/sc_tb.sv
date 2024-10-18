`timescale 1ns/1ns

// instructions being tested are listed in the imem

module sc_tb();
	// wires
	logic clk, rst;	
	// pc wires
	logic [31:0] pc4, pc_o, inst_tb, pc_i_tb;
    // reg file wires
    logic reg_wr_tb;
    logic [31:0] wr_data_tb, rs1_data_tb, rs2_data_tb;
    logic [4:0] rs1_addr_tb, rs2_addr_tb, wr_addr_tb;
    
    // muxes a and b
    logic [31:0] mux_out_a, mux_out_b;
    logic sel_a_tb, sel_b_tb;
    
    // imm gen
    logic [31:0] imm_o_tb;
    
    // alu
    logic [31:0] alu_o_tb;
    logic [3:0] alu_op_tb;
    
    // dmem 
    logic mem_wr_tb, mem_rd_tb;
    logic [2:0] mask_tb;
    logic [31:0] dmem_o_tb;
    
    // ctrl
    logic [1:0] sel_wb_tb;
	logic br_en_tb;
	logic [2:0] br_type_tb;
	// module instantiations
	
	assign rs1_addr_tb = inst_tb[19:15];
	assign rs2_addr_tb = inst_tb[24:20];
	assign wr_addr_tb = inst_tb[11:7];
	
	pc pc(
		.clk (clk),
		.rst (rst),
		.pc_i(pc_i_tb),
		.pc_o(pc_o)
	);
	
	pc_add4 pc_add(
		.pc_o(pc_o),
		.pc_pc4(pc4)
	);
   	
	mux2_1 pc_sel (
		.data1(pc4),
		.data2(alu_o_tb),
		.sel(br_en_tb),
		.mux_out(pc_i_tb)
	); 
    imem imem_dut(
       .addr_i(pc_o),
       .instr_o(inst_tb) 
    );
    
    reg_file regf_dut (
        .clk(clk),
        .rst(rst),
        .reg_wr(reg_wr_tb),
        .wr_data(wr_data_tb),
        .rs1_addr(rs1_addr_tb),
        .rs2_addr(rs2_addr_tb),
        .wr_addr(wr_addr_tb),
        .rs1_data(rs1_data_tb),
        .rs2_data(rs2_data_tb)
    );
        
    mux2_1 mux_a (
        .data1(rs1_data_tb),
        .data2(pc_o),
        .sel(sel_a_tb),
        .mux_out(mux_out_a)
    );
    
    mux2_1 mux_b (
        .data1(rs2_data_tb),
        .data2(imm_o_tb),
        .sel(sel_b_tb),
        .mux_out(mux_out_b)
    );
    
    imm_gen imm_gen_dut (
        .inst(inst_tb),
        .imm_o(imm_o_tb)
    );
    
	branch_ctrl branch_ctrl_dut (
		.br_type (br_type_tb),
		.op_code (inst_tb[6:0]),
		.rs1_data (rs1_data_tb),
		.rs2_data (rs2_data_tb),
		.br_en (br_en_tb)
	);

    alu alu_dut (
        .a (mux_out_a),
        .b (mux_out_b),
        .alu_op (alu_op_tb),
        .alu_o (alu_o_tb)
    );
   
    dmem dmem_dut(
         .clk (clk),
         .addr (alu_o_tb),
         .wr_data (rs2_data_tb),
         .mem_wr (mem_wr_tb),
         .mem_rd (mem_rd_tb),
         .mask  (mask_tb),
         .dmem_o (dmem_o_tb)
    );
   
    main_ctrl main_ctrl_dut(
        .inst_i (inst_tb),
        .reg_wr (reg_wr_tb),
        .alu_op (alu_op_tb),
        .sel_a (sel_a_tb),
        .sel_b (sel_b_tb),
        .mem_wr (mem_wr_tb),
        .mem_rd (mem_rd_tb),
        .mask (mask_tb),
        .sel_wb (sel_wb_tb),
		.br_type (br_type_tb)
    );

    mux4_1 mux_wb_dut (
        .data1 (dmem_o_tb),
        .data2 (alu_o_tb),
        .data3 (pc4),
        .data4 (pc4),
        .sel (sel_wb_tb),
        .mux_o (wr_data_tb)
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

