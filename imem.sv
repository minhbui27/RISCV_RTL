`timescale 1ns/1ns
module imem (
    input  logic [31:0] addr_i,
    output logic [31:0] instr_o
);

    // 4 bytes by 256
    logic [31:0] imem [255:0];
    logic [31:0] i;

    initial begin
        for (i=0; i < 256; i = i + 1) begin
            imem[i] = 32'h0;
        end
    end

    // shift right two for byte offset
    assign instr_o = imem[addr_i >> 2];
endmodule
