`timescale 1ns/1ps

module tb_uart_tx;
    reg clk, rst, tx_start;
    reg [7:0] tx_data;
    wire tx, tx_busy, tx_done;

    uart_tx #(.CLKS_PER_BIT(4)) dut (
        .clk(clk), .rst(rst), .tx_start(tx_start),
        .tx_data(tx_data), .tx(tx), .tx_busy(tx_busy), .tx_done(tx_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; tx_start = 0; tx_data = 8'hA5;
        repeat (2) @(posedge clk);
        @(negedge clk); rst = 0;
        @(negedge clk); tx_start = 1;
        @(negedge clk); tx_start = 0;

        wait(tx_done);
        $display("UART transmission completed. tx=%b", tx);
        #10 $finish;
    end

    initial begin
        $monitor("t=%0t tx=%b busy=%b done=%b", $time, tx, tx_busy, tx_done);
    end
endmodule
