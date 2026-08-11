module uart_receiver #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,

    output reg [7:0]  data_out,
    output reg        data_valid
);

    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count;
    reg [3:0]  bit_count;
    reg [7:0]  rx_data;
    reg [2:0]  state;

    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA  = 3'd2;
    localparam STOP  = 3'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count  <= 0;
            bit_count  <= 0;
            rx_data    <= 0;
            data_out   <= 0;
            data_valid <= 0;
            state      <= IDLE;
        end
        else begin
            data_valid <= 0;

            case (state)

                IDLE: begin
                    clk_count <= 0;
                    bit_count <= 0;

                    if (rx == 1'b0)
                        state <= START;
                end

                START: begin
                    if (clk_count == (CLKS_PER_BIT/2)-1) begin
                        if (rx == 1'b0) begin
                            clk_count <= 0;
                            state <= DATA;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        rx_data[bit_count] <= rx;

                        if (bit_count == 7) begin
                            bit_count <= 0;
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1;
                        end
                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;

                        if (rx == 1'b1) begin
                            data_out <= rx_data;
                            data_valid <= 1'b1;
                        end

                        state <= IDLE;
                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule