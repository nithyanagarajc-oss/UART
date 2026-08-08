`timescale 1ns/1ps

module uart_tx_tb;

    reg       clk;
    reg       reset;
    reg       tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    // Small value used to make simulation faster
    parameter CLKS_PER_BIT = 4;

    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        $monitor("Time=%0t | TX=%b | Busy=%b | Data=%h",
                 $time, tx, tx_busy, tx_data);

        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #20;
        reset = 0;

        // Send ASCII 'A'
        #10;
        tx_data = 8'h41;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait for transmission to finish
        #450;

        // Send ASCII 'B'
        tx_data = 8'h42;
        tx_start = 1;

        #10;
        tx_start = 0;

        #450;

        $finish;
    end

endmodule