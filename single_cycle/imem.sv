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
        #1;
        // ADD t0, a0, a1
        imem[0] = 32'b0000000_01010_01011_000_00101_0110011;
        // addi t1, zero, 33
        imem[1] = 32'b000000100001_00000_000_00110_0010011;
        // sw   t1, 8(zero)
        imem[2] = 32'b0000000_00110_00000_010_01000_0100011;
        // beq zero, zero, 0x20 (0000_0000_0000_0000_0000_0000_0010_0000)
        imem[3] = 32'b0000001_00000_00000_000_00000_1100011;
    end

    // shift right two for byte offset
    assign instr_o = imem[addr_i >> 2];
endmodule


