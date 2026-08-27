`timescale 1ns/1ps

module traffic_light_controller_tb;

    reg clk;
    reg reset;
    reg emergency;

    wire roadA_red, roadA_yellow, roadA_green;
    wire roadB_red, roadB_yellow, roadB_green;
    wire [1:0] state_debug;

    traffic_light_controller DUT (
        .clk(clk),
        .reset(reset),
        .emergency(emergency),
        .roadA_red(roadA_red),
        .roadA_yellow(roadA_yellow),
        .roadA_green(roadA_green),
        .roadB_red(roadB_red),
        .roadB_yellow(roadB_yellow),
        .roadB_green(roadB_green),
        .state_debug(state_debug)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        emergency = 0;

        #20 reset = 0;
        #100 emergency = 1;
        #30 emergency = 0;
        #100 $finish;
    end

    initial begin
        $monitor(
            "TIME=%0t | RESET=%b | EMERGENCY=%b | STATE=%b | "
            "A_RED=%b A_YELLOW=%b A_GREEN=%b | "
            "B_RED=%b B_YELLOW=%b B_GREEN=%b",
            $time, reset, emergency, state_debug,
            roadA_red, roadA_yellow, roadA_green,
            roadB_red, roadB_yellow, roadB_green
        );
    end

    initial begin
        $dumpfile("traffic_light_controller.vcd");
        $dumpvars(0, traffic_light_controller_tb);
    end
endmodule
