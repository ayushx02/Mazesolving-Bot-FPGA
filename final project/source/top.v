module top(

    input clk_50M, 
    input rst_n,
    input echo_rx1,
    output trig1,
    input echo_rx2,
    output trig2,
    input echo_rx3,
    output trig3,
    output reg led1,
    output reg led2,
    output reg led3,


    output Motor1_A,
    output Motor1_B,
    output Motor2_A,
    output Motor2_B,

    output reg [20:0] distance1,
    output reg [20:0] distance2,
    output reg [20:0] distance3,
    output reg signed [15:0] pid

);






reg start1;
reg start2 ;
reg start3;
reg [2:0] sel;
wire obstacle1,obstacle2,obstacle3;
reg  wall1,wall2,wall3;
reg ina1,ina2,inb1,inb2;
reg [7:0] dutya;
reg [7:0] dutyb;
wire [20:0] distance_raw1;
wire [20:0] distance_raw2;
wire [20:0] distance_raw3;

wire signed [16:0] dutyA_tmp;
wire signed [16:0] dutyB_tmp;

wire signed [15:0] error;

assign error = $signed(distance1) - $signed(distance3) + 16'sd3;

wire signed [17:0] pid_scaled;

assign pid_scaled = (error * 7) / 10;












reg [24:0] counter_ping;

localparam CLK_MHZ = 50;	 // horloge 50MHz
localparam PERIOD_PING_MS = 100;  // période des ping en ms

localparam COUNTER_MAX_PING = CLK_MHZ * PERIOD_PING_MS * 1000;






ultrasonic U1 (	.clk_50M(clk_50M),
                        .trig(trig1),
                        .echo_rx(echo_rx1),
                        .new_measure(start1),
                        .obstacle(obstacle1),
                        .distance_out(distance_raw1)

                    );

ultrasonic U2 (	.clk_50M(clk_50M),
                        .trig(trig2),
                        .echo_rx(echo_rx2),
                        .new_measure(start2),
                        .obstacle(obstacle2),
                        .distance_out(distance_raw2)

);


ultrasonic U3 (	.clk_50M(clk_50M),
                        .trig(trig3),
                        .echo_rx(echo_rx3),
                        .new_measure(start3),
                        .obstacle(obstacle3),
                        .distance_out(distance_raw3)

                    );

motor_driver M1 (.clk_50M(clk_50M),
                 .duty(dutya),
                 .in1(ina1),
                 .in2(ina2),
                 .out1(Motor1_A),
                 .out2(Motor1_B)
);

motor_driver M2 (.clk_50M(clk_50M),
                 .duty(dutyb),
                 .in1(inb1),
                 .in2(inb2),
                 .out1(Motor2_A),
                 .out2(Motor2_B)
);


assign dutyA_tmp = 17'sd167 - pid_scaled;
assign dutyB_tmp = 17'sd167 + pid_scaled;



always @(*) begin
    wall1 <= obstacle1;
    wall2 <= obstacle2;
    wall3 <= obstacle3;
    distance1 <= distance_raw1;
    distance2 <= distance_raw2;
    distance3 <= distance_raw3;
end


always @(posedge clk_50M) begin


    if(!rst_n) begin
        sel <= 3'd0;
        counter_ping <= 0;

    end

    else if(rst_n)begin






        // default OFF
        start1 <= 0;
        start2 <= 0;
        start3 <= 0;

        if (counter_ping == COUNTER_MAX_PING - 1) begin
            counter_ping <= 25'd0;

            // rotate selection
            if (sel == 3'd0)
                sel <= 3'd1;
            else if (sel == 3'd1)
                sel <= 3'd2;
            else if (sel == 3'd2)
                sel <= 3'd3;
            else if(sel == 3'd3)
                sel <= 3'd4;
            else
                sel <= 3'd0;

        end else begin
            counter_ping <= counter_ping + 25'd1;
        end

        // decode selection (one-hot)
        case (sel)
            3'd0: begin
                start1 <= 1;
            end
            3'd1: begin
                start2 <= 1;
            end
            3'd2: begin
                start3 <= 1;
            end
            3'd3: begin
               pid <= $signed(distance1) - $signed(distance3) + 8'sd3;

            end


            3'd4: begin

                dutya <= dutyA_tmp[7:0];
                ina1 <= 1;
                ina2 <= 0;

                dutyb <= dutyB_tmp[7:0];
                inb1 <= 1;
                inb2 <= 0;



            end


            default: begin
                start1 <= 0;
                start2 <= 0;
                start3 <= 0;

            end
        endcase

    end

end








endmodule
