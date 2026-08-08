module uart_tx #(
    parameter CLKS_PER_BIT = 16
)(
    input        clk,
    input        reset,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output reg   tx_busy
);

    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA  = 3'd2;
    localparam STOP  = 3'd3;

    reg [2:0] state;
    reg [3:0] bit_index;
    reg [7:0] data_reg;
    reg [15:0] clk_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            bit_index <= 4'd0;
            data_reg  <= 8'd0;
            clk_count <= 16'd0;
        end
        else begin
            case (state)

                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b0;
                    clk_count <= 16'd0;
                    bit_index <= 4'd0;

                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy  <= 1'b1;
                        state    <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;

                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end
                    else begin
                        clk_count <= 16'd0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_index];

                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end
                    else begin
                        clk_count <= 16'd0;

                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1'b1;
                        end
                        else begin
                            bit_index <= 4'd0;
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;

                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end
                    else begin
                        clk_count <= 16'd0;
                        tx_busy <= 1'b0;
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                end

            endcase
        end
    end

endmodule