module pc_add4 (
    input  logic [31:0] pc_o,
    output logic [31:0] pc_pc4
);

assign pc_pc4 = pc_o + 32'h4;

endmodule