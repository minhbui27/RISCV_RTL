`timescale 1ns/1ns
module mux4_1 (
    input logic [31:0] data1, data2, data3, data4,
    input logic [1:0] sel,
    output logic [31:0] mux_o
);
    always_comb begin
        case(sel)
            2'b00: mux_o = data1;
            2'b01: mux_o = data2;
            2'b10: mux_o = data3;
            2'b11: mux_o = data4;
            default: mux_o = 0;
        endcase
    end

endmodule

