`timescale 1ns/1ps

module uart_receiver_tb;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] data_out;
    wire       data_valid;

    parameter CLK_FREQ  = 1_000_000;
    parameter BAUD_RATE = 10_000;

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam BIT_TIME = 100_000; // 100 us in ns

    uart_receiver #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // 1 MHz clock
    always #500 clk = ~clk;

    // UART transmit task
    task uart_send_byte;
        input [7:0] data;
        integer i;

        begin
            // Start bit
            rx = 1'b0;
            #(BIT_TIME);

            // Data bits, LSB first
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_TIME);
            end

            // Stop bit
            rx = 1'b1;
            #(BIT_TIME);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        rx  = 1;

        #2000;
        rst = 0;

        // Send A5
        uart_send_byte(8'hA5);

        #20000;

        // Send 55
        uart_send_byte(8'h55);

        #20000;

        $finish;
    end

    initial begin
        $monitor("Time=%0t RX=%b Data=%h Valid=%b",
                 $time, rx, data_out, data_valid);
    end

    initial begin
        $dumpfile("uart_receiver.vcd");
        $dumpvars(0, uart_receiver_tb);
    end

endmodule