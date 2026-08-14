module motor_driver(input clk_50M, in1,in2,
            input [7:0] duty,
            output  out1, 
            output  out2
            );


wire pwm;

pwm_generator PWM_M1 (
    .clk_50M(clk_50M),
    .duty(duty),
    .pwm_out(pwm)
);



assign out1 = pwm & in1;
assign out2 = pwm & in2;




endmodule




module pwm_generator (
    input        clk_50M,
    input [7:0] duty,
    output reg   pwm_out
);



reg [7:0] pwm_cnt;

always @(posedge clk_50M) begin

        pwm_cnt <= pwm_cnt + 1'b1;
end

always @(posedge clk_50M) begin
    pwm_out <= (pwm_cnt < duty);
end

endmodule
