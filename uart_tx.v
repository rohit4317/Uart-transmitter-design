`timescale 1ns/1ps

module uart_tx #(
    parameter integer CLKS_PER_BIT = 16
) (
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);

    localparam [1:0] IDLE  = 2'd0,
                     START = 2'd1,
                     DATA  = 2'd2,
                     STOP  = 2'd3;

    reg [1:0] state;
    integer clock_count;
    reg [2:0] bit_index;
    reg [7:0] data_latch;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            tx_done <= 1'b0;
            clock_count <= 0;
            bit_index <= 0;
            data_latch <= 0;
        end else begin
            tx_done <= 1'b0;
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    clock_count <= 0;
                    bit_index <= 0;
                    if (tx_start) begin
                        data_latch <= tx_data;
                        tx_busy <= 1'b1;
                        state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    if (clock_count == CLKS_PER_BIT-1) begin
                        clock_count <= 0;
                        state <= DATA;
                    end else clock_count <= clock_count + 1;
                end

                DATA: begin
                    tx <= data_latch[bit_index];
                    if (clock_count == CLKS_PER_BIT-1) begin
                        clock_count <= 0;
                        if (bit_index == 3'd7) begin
                            bit_index <= 0;
                            state <= STOP;
                        end else bit_index <= bit_index + 1'b1;
                    end else clock_count <= clock_count + 1;
                end

                STOP: begin
                    tx <= 1'b1;
                    if (clock_count == CLKS_PER_BIT-1) begin
                        clock_count <= 0;
                        tx_done <= 1'b1;
                        tx_busy <= 1'b0;
                        state <= IDLE;
                    end else clock_count <= clock_count + 1;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
