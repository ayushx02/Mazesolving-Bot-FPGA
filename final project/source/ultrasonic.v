/*
Module HC_SR04 Ultrasonic Sensor

This module will detect objects present in front of the range, and give the distance in mm.

Input:  clk_50M - 50 MHz clock
        reset   - reset input signal (Use negative reset)
        echo_rx - receive echo from the sensor

Output: trig    - trigger sensor for the sensor
        op     -  output signal to indicate object is present.
        distance_out - distance in mm, if object is present.
*/

// module Declaration
	
module ultrasonic(
    input clk_50M, new_measure, echo_rx,
    output reg trig,
    output  reg obstacle,
    output wire [20:0] distance_out
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

/*
# Team ID:          2434
# Theme:            MazeSover Bot
# Author List:      Ashutosh Sahu, Ayush Mritunjay, Satyam
# Filename:         t1b_ultasonic.v
# File Description: controller for HC-SC-04, FSM style verilog module to control and read signal from sensor.. All syncronous, working on posedge of clk
# Global variables: None
*/

//////////////////////////////////////////////////////////////////////////////


reg [19:0] main_counter = 0;
reg [16:0] echo_counter = 0;
reg [1:0] state = 2'b00;
reg [20:0] distance;

//main_counter: commom counter used for counting 1us, 10us and 12ms actions
//echo_counter: counting cycles for which echo_rx is HIGH, used for distance calculation

localparam
        S1_RST = 2'b00,
        S2_TRIG = 2'b01,
        S3_ECHO   = 2'b10;




always @(posedge clk_50M) begin
/*
Purpose:
For Syncronous State Change and Reset
*/


    if (!new_measure) begin
        trig <= 0;
        state <= S1_RST;
        main_counter <= 0;
        echo_counter <= 0;
 
    end

    else if(new_measure)  begin
        case(state)
        S1_RST: begin
            main_counter <= main_counter + 1;
            if(main_counter == 6'd50)  begin
                state <= S2_TRIG;
                main_counter <= 0;
                echo_counter <= 0;
            end
            else begin
                state <= S1_RST;
            end
        end


        S2_TRIG: begin
            main_counter <= main_counter + 1;
            trig <= 1;
            if (main_counter == 9'd499) begin
                state <= S3_ECHO;
                main_counter <= 0;
					 echo_counter <= 0;
            end
            else begin
                state <= S2_TRIG;
                
            end          
        end


        S3_ECHO: begin

            main_counter <= main_counter + 1;
            trig <= 0;

            if(echo_rx == 0) begin
                if(echo_counter > 0) begin
                    distance <= echo_counter / 11'd2900;   // distance in cm;
                    obstacle <= (echo_counter < 21'h6000) ? 1'b1 : 1'b0; 

                    
         
            
                end
                else begin
                    distance <= 0;
          

                end

                    
                 
            end


            else if(echo_rx)begin
                state <= S3_ECHO;
                echo_counter <= echo_counter + 1;
            end
            else 
                state <= S3_ECHO;

        end


        default: state <= S1_RST;
        endcase      
        
    end


end

assign distance_out = distance;
 



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
