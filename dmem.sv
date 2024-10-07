module dmem (
    input  logic [31:0] addr,
    input  logic [31:0] wr_data,
    input  logic        mem_wr,
    input  logic        mem_rd,
    input  logic [2:0]  mask,
    input  logic        clk,
    output logic [31:0] dmem_o
);

endmodule