module traffic_light_controller (
    input  wire clk,
    input  wire reset,
    input  wire emergency,

    output reg roadA_red,
    output reg roadA_yellow,
    output reg roadA_green,

    output reg roadB_red,
    output reg roadB_yellow,
    output reg roadB_green,

    output reg [1:0] state_debug
);

    parameter A_GREEN  = 2'b00;
    parameter A_YELLOW = 2'b01;
    parameter B_GREEN  = 2'b10;
    parameter B_YELLOW = 2'b11;

    reg [1:0] state;
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state   <= A_GREEN;
            counter <= 0;
        end
        else if (emergency) begin
            state   <= B_GREEN;
            counter <= 0;
        end
        else begin
            case (state)
                A_GREEN: begin
                    if (counter == 4) begin
                        counter <= 0;
                        state <= A_YELLOW;
                    end else counter <= counter + 1;
                end

                A_YELLOW: begin
                    if (counter == 1) begin
                        counter <= 0;
                        state <= B_GREEN;
                    end else counter <= counter + 1;
                end

                B_GREEN: begin
                    if (counter == 4) begin
                        counter <= 0;
                        state <= B_YELLOW;
                    end else counter <= counter + 1;
                end

                B_YELLOW: begin
                    if (counter == 1) begin
                        counter <= 0;
                        state <= A_GREEN;
                    end else counter <= counter + 1;
                end

                default: begin
                    state <= A_GREEN;
                    counter <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        roadA_red = 0; roadA_yellow = 0; roadA_green = 0;
        roadB_red = 0; roadB_yellow = 0; roadB_green = 0;

        case (state)
            A_GREEN: begin roadA_green = 1; roadB_red = 1; end
            A_YELLOW: begin roadA_yellow = 1; roadB_red = 1; end
            B_GREEN: begin roadA_red = 1; roadB_green = 1; end
            B_YELLOW: begin roadA_red = 1; roadB_yellow = 1; end
            default: begin roadA_red = 1; roadB_red = 1; end
        endcase
    end

    always @(*) state_debug = state;
endmodule
