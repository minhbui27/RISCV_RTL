`timescale 1ns / 1ns
module branch_ctrl(
    input logic [2:0] br_type,
    input logic [6:0] op_code,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    output logic br_en
    );
    always_comb begin
        case(op_code)
            // jal
            7'b110_1111: begin
                br_en = 1;
            end
            // B types
            7'b110_0011: begin
                case(br_type)
                    // beq
                    3'b000: begin
                        br_en = rs1_data == rs2_data;
                    end
                    // bne
                    3'b001: begin
                        br_en = rs1_data != rs2_data;
                    end
                    // blt
                    3'b100: begin
                        br_en = rs1_data < rs2_data;
                    end
                    // bge
                    3'b101: begin
                        br_en = rs1_data >= rs2_data;
                    end
                    // bltu
                    3'b110: begin
                        br_en = $signed(rs1_data) < $signed(rs2_data);
                    end
                    // bgeu
                    3'b111: begin
                        br_en = $signed(rs1_data) >= $signed(rs2_data);
                    end
                endcase
            end
            default: begin
                br_en = 0;
            end
        endcase
    end
endmodule

