module controller(
    input clk,
    input lt,
    input gt,
    input eq,
    input start,
    output reg ldA,
    output reg ldB,
    output reg sel1,
    output reg sel2,
    output reg sel_in,
    output reg done
);
    reg [2:0] state, next_state;

    localparam
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100,
        S5 = 3'b101,
        S6 = 3'b110;

    always @(posedge clk)
        state <= next_state;

    always @* begin
        case (state)
            S0: if (start) next_state = S1; else next_state = S0;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: if (eq)
                    next_state = S6;
                else if (lt)
                    next_state = S4;
                else if (gt)
                    next_state = S5;
                else
                    next_state = S3;
            S4, S5: next_state = S3;
            S6: next_state = S0;
            default: next_state = S0;
        endcase
    end

    always @* begin
        ldA = 0;
        ldB = 0;
        sel1 = 0;
        sel2 = 0;
        sel_in = 0;
        done = 0;

        case (state)
            S0: begin
                ldA = 1'b1;
                sel_in = 1'b1;
            end
            S1: begin
                ldB = 1'b1;
                sel_in = 1'b1;
            end
            S2, S3: begin
                // Idle / Compare states
            end
            S4: begin
                // B = B - A
                sel1 = 1'b1;
                sel2 = 1'b0;
                ldB = 1'b1;
            end
            S5: begin
                // A = A - B
                sel1 = 1'b0;
                sel2 = 1'b1;
                ldA = 1'b1;
            end
            S6: begin
                done = 1'b1;
            end
        endcase
    end
endmodule
