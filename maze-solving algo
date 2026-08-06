
// Task 2C - MazeSolver Bot

module t2c_maze_explorer (
    input clk,
    input rst_n,
    input left, mid, right, // 0 - no wall, 1 - wall
    output reg [2:0] move
);

/*

| cmd | move  | meaning   |
|-----|-------|-----------|
| 000 | 0     | STOP      |
| 001 | 1     | FORWARD   |
| 010 | 2     | LEFT      |
| 011 | 3     | RIGHT     |
| 100 | 4     | U_TURN    |

START POS   : 4,8
EXIT POS    : 4,0
DEADENDS    : 9

*/
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

/*
# Team ID:          2434
# Theme:            MazeSolver Bot
# Author List:      Ayush Mritunjay
# Filename:         t2c_maze_explorer.v
# File Description: Used Modified LWF Algo...which doesnt exit the maze until fully explored...till then it ignores exiting from exit point(4,0) and takes next priority turn
                    After completing all 81 blocks exploration...it traces back to the exit point..(for that used localisation(current path) and mapping(for explorating unique cells) methods)
                    funtional code...can be improved:/ (its logic and registers)

                    Note: rst_n resets back to starting position(4,8) and all variables.

# Global variables: None
*/

/////////////////////////////////////////////////////////////////////////////

reg [2:0] get_walls;
reg [1:0] wall_sum;
reg visited_cell [0:80];   // 81 cells, each 1-bit

reg [7:0] bot_pos = 8'd76;
reg [7:0] unique_cell_counter = 0;

reg [1:0] facing = 2'b00;        // 00=N, 01=E, 10=S, 11=W
reg flag = 0;


reg dfs_mode = 1'b0; // when reached end point before exploring all cells, enter dfs mode to explore all cells and to use it to retrace back to end
reg retrace_mode = 1'b0; // after dfs mode is over, retrace back to end point using location stack
reg [7:0] branch_stack [0:80];
reg [7:0] location_stack [0:80];
reg [7:0] branch_sp = 0;  // stack pointer (index of top element)
reg [7:0] location_sp = 0;
reg pop_flag = 1'b0;
reg [1:0] counter = 0;



integer delta [0:3];
integer j; // for simulation; synthesis will ignore initialization below

localparam  CMD_STOP    = 3'b000,
            CMD_FORWARD = 3'b001,
            CMD_LEFT    = 3'b010,
            CMD_RIGHT   = 3'b011,
            CMD_UTURN   = 3'b100;


localparam  NORTH = 2'b00,
            EAST  = 2'b01,
            SOUTH = 2'b10,
            WEST  = 2'b11;

//LEFT or  or even UTURN  MOVE means turn to that directon and move to next forward block in that direction....the facing will automatically get set:)


//0- unexplored, 1- explored onc, 2- explored twice..blocked(if its explored twice prolly its coming bach fro blocked path ahead...hence that road is not usable, so block that cell, for futture use)



initial begin

    visited_cell[0]  = 1'b0;  visited_cell[1]  = 1'b0;  visited_cell[2]  = 1'b0;
    visited_cell[3]  = 1'b0;  visited_cell[4]  = 1'b0;  visited_cell[5]  = 1'b0;
    visited_cell[6]  = 1'b0;  visited_cell[7]  = 1'b0;  visited_cell[8]  = 1'b0;
    visited_cell[9]  = 1'b0;  visited_cell[10] = 1'b0;  visited_cell[11] = 1'b0;
    visited_cell[12] = 1'b0;  visited_cell[13] = 1'b0;  visited_cell[14] = 1'b0;
    visited_cell[15] = 1'b0;  visited_cell[16] = 1'b0;  visited_cell[17] = 1'b0;
    visited_cell[18] = 1'b0;  visited_cell[19] = 1'b0;  visited_cell[20] = 1'b0;
    visited_cell[21] = 1'b0;  visited_cell[22] = 1'b0;  visited_cell[23] = 1'b0;
    visited_cell[24] = 1'b0;  visited_cell[25] = 1'b0;  visited_cell[26] = 1'b0;
    visited_cell[27] = 1'b0;  visited_cell[28] = 1'b0;  visited_cell[29] = 1'b0;
    visited_cell[30] = 1'b0;  visited_cell[31] = 1'b0;  visited_cell[32] = 1'b0;
    visited_cell[33] = 1'b0;  visited_cell[34] = 1'b0;  visited_cell[35] = 1'b0;
    visited_cell[36] = 1'b0;  visited_cell[37] = 1'b0;  visited_cell[38] = 1'b0;
    visited_cell[39] = 1'b0;  visited_cell[40] = 1'b0;  visited_cell[41] = 1'b0;
    visited_cell[42] = 1'b0;  visited_cell[43] = 1'b0;  visited_cell[44] = 1'b0;
    visited_cell[45] = 1'b0;  visited_cell[46] = 1'b0;  visited_cell[47] = 1'b0;
    visited_cell[48] = 1'b0;  visited_cell[49] = 1'b0;  visited_cell[50] = 1'b0;
    visited_cell[51] = 1'b0;  visited_cell[52] = 1'b0;  visited_cell[53] = 1'b0;
    visited_cell[54] = 1'b0;  visited_cell[55] = 1'b0;  visited_cell[56] = 1'b0;
    visited_cell[57] = 1'b0;  visited_cell[58] = 1'b0;  visited_cell[59] = 1'b0;
    visited_cell[60] = 1'b0;  visited_cell[61] = 1'b0;  visited_cell[62] = 1'b0;
    visited_cell[63] = 1'b0;  visited_cell[64] = 1'b0;  visited_cell[65] = 1'b0;
    visited_cell[66] = 1'b0;  visited_cell[67] = 1'b0;  visited_cell[68] = 1'b0;
    visited_cell[69] = 1'b0;  visited_cell[70] = 1'b0;  visited_cell[71] = 1'b0;
    visited_cell[72] = 1'b0;  visited_cell[73] = 1'b0;  visited_cell[74] = 1'b0;
    visited_cell[75] = 1'b0;  visited_cell[76] = 1'b0;  visited_cell[77] = 1'b0;
    visited_cell[78] = 1'b0;  visited_cell[79] = 1'b0;  visited_cell[80] = 1'b0;

    delta[0] = -9;
    delta[1] =  1;
    delta[2] =  9;
    delta[3] = -1;

    move = CMD_STOP;
end

always @(*) begin

/*
Purpose: To get wall sum and wall info as sooon as possible, so we can use it in posedge clk block
*/
    get_walls = {left, mid, right};
    wall_sum = left + mid + right;
end

always @(posedge clk) begin
/*

Purpose: Main logic block, all decisions taken here
*/

    if(rst_n) begin

        if(counter < 2) begin         //2 cycle delay after rst_n comes back from low..(according testbench )
            counter <= counter + 1;
            move <= CMD_STOP;           //till then cmd_stop
        end
        
        else begin

///////////////////////////////////////////

            if(flag == 1'b0) begin // all happens on first clock 

                if(unique_cell_counter == 8'd81 && dfs_mode == 1'b1) begin //giving one cycle delay and starting retrace path to reach end point
                    dfs_mode <= 1'b0;
                    retrace_mode <= 1'b1;
                    location_sp <= location_sp - 1;
                    move <= CMD_STOP;
                    flag <= 1;
                end

                else if (unique_cell_counter == 8'd81 && retrace_mode == 1'b1 && location_sp > 0) begin //retracing process

                    if(location_stack[location_sp] - location_stack[location_sp - 1] == 9) begin
                        if(facing == EAST) begin 
                            move <= CMD_LEFT;
                            facing <= NORTH;
                            flag <= 1;

                        end
                        else if(facing == WEST) begin
                            move <= CMD_RIGHT;
                            facing <= NORTH;
                            flag <= 1;

                        end

                        else begin
                            move <= CMD_FORWARD;
                            flag <= 1;
                        end
                    end

                    else if(location_stack[location_sp] - location_stack[location_sp - 1] == -1) begin
                        if(facing == NORTH) begin
                            move <= CMD_RIGHT;
                            facing <= EAST;
                            flag <= 1;

                        end
                        else if(facing == SOUTH) begin
                            move <= CMD_LEFT;
                            facing <= EAST;
                            flag <= 1;
                        end

                        else begin
                            move <= CMD_FORWARD;
                            flag <= 1;
                        end
                    end

                    else if(location_stack[location_sp] - location_stack[location_sp - 1] == 1) begin
                        if(facing == NORTH) begin
                            move<=CMD_LEFT;
                            facing<=WEST;
                            flag <= 1;
                        end
                        else if(facing == SOUTH) begin
                            move<=CMD_RIGHT;
                            facing<=WEST;
                            flag <= 1;
                        end

                        else begin
                            move<=CMD_FORWARD;
                            flag <= 1;
                        end

                    end

                    else if(location_stack[location_sp] - location_stack[location_sp - 1] == -9) begin
                        if(facing == WEST) begin
                            move<=CMD_LEFT;
                            facing<=SOUTH;
                            flag <= 1;
                        end
                        else if(facing == EAST) begin
                            move<=CMD_RIGHT;
                            facing<=SOUTH;
                            flag <= 1;
                        end

                        else begin
                            move<=CMD_FORWARD;
                            flag <= 1;
                        end
                    end


                    location_sp <= location_sp - 1;


                end


                else if (unique_cell_counter == 8'd81 && retrace_mode == 1'b1 && location_sp == 0) begin 

                    case(facing)
                        NORTH: begin
                            move <= CMD_FORWARD;
                            flag <= 1;
                        end

                        EAST: begin
                            move <= CMD_LEFT;
                            facing <= NORTH;
                            flag <= 1;
                        end

                        WEST: begin
                            move <= CMD_RIGHT;
                            facing <= NORTH;
                            flag <= 1;
                        end

                        default: move <= CMD_STOP;
                    endcase
                end

                else if(bot_pos == 8'd4 && unique_cell_counter < 81 && dfs_mode ==1'b0) begin // will start dfs from end.. branch stack and position stack, and retrack if once all 81 cells are explored

                    dfs_mode <= 1'b1;
                    branch_sp <= 0;
                    location_sp <= 0;   
                    if(facing == NORTH) begin
                        casez (get_walls)       
                            3'b0??:  begin
                                move <= CMD_LEFT;
                                facing <= facing - 1;
                                flag <= 1;
                                end

                            3'b1?0:  begin
                                move <= CMD_RIGHT;
                                facing <= facing + 1;
                                flag <= 1;
                                end

                            3'b1?1:  begin
                                move <= CMD_UTURN;
                                facing <= facing + 2;
                                flag <= 1;
                                end

                            default: move <= CMD_STOP;
                        endcase
                    end

                    else if(facing == EAST) begin
                        casez (get_walls)       
                            3'b?0?:  begin
                                move <= CMD_FORWARD;
                                flag <= 1;
                                end

                            3'b?10:  begin
                                move <= CMD_RIGHT;
                                facing <= facing + 1;
                                flag <= 1;
                                end

                            3'b?11:  begin
                                move <= CMD_UTURN;
                                facing <= facing + 2;
                                flag <= 1;
                                end

                            default: move <= CMD_STOP;
                        endcase
                    end  


                    else if(facing == WEST) begin
                        casez (get_walls)       
                            3'b0??:  begin
                                move <= CMD_LEFT;
                                facing <= facing - 1;
                                flag <= 1;
                                end

                            3'b10?:  begin
                                move <= CMD_FORWARD;
                                flag <= 1;
                                end

                            3'b11?:  begin
                                move <= CMD_UTURN;
                                facing <= facing + 2;
                                flag <= 1;
                                end

                            default: move <= CMD_STOP;
                        endcase
                    end  

                    //NO south facing case needed       

                end

                else if(bot_pos == 8'd4 && unique_cell_counter < 81) begin

                    if(facing == NORTH) begin
                        casez (get_walls)       
                            3'b0??:  begin
                                move <= CMD_LEFT;
                                facing <= facing - 1;
                                flag <= 1;
                                end

                            3'b1?0:  begin
                                move <= CMD_RIGHT;
                                facing <= facing + 1;
                                flag <= 1;
                                end

                            3'b1?1:  begin
                                move <= CMD_UTURN;
                                facing <= facing + 2;
                                flag <= 1;
                                end

                            default: move <= CMD_STOP;
                        endcase
                    end

                    else if(facing == EAST) begin
                        casez (get_walls)       
                            3'b?0?:  begin
                                move <= CMD_FORWARD;
                                flag <= 1;
                                end

                            3'b?10:  begin
                                move <= CMD_RIGHT;
                                facing <= facing + 1;
                                flag <= 1;
                                end

                            3'b?11:  begin
                                move <= CMD_UTURN;
                                facing <= facing + 2;
                                flag <= 1;
                                end

                            default: move <= CMD_STOP;
                        endcase
                    end  


                    else if(facing == WEST) begin
                        casez (get_walls)       
                            3'b0??:  begin
                                move <= CMD_LEFT;
                                facing <= facing - 1;
                                flag <= 1;
                                end

                            3'b10?:  begin
                                move <= CMD_FORWARD;
                                flag <= 1;
                                end

                            3'b11?:  begin
                                move <= CMD_UTURN;
                                facing <= facing + 2;
                                flag <= 1;
                                end

                            default: move <= CMD_STOP;
                        endcase
                    end  


                end



                




                else begin                               //if nothing is going on, normal exploring mode
                        casez (get_walls)       
                                3'b0??:  begin
                                    move <= CMD_LEFT;
                                    facing <= facing - 1;
                                    flag <= 1;
                                    end

                                3'b10?:  begin
                                    move <= CMD_FORWARD;
                                    flag <= 1;
                                    end

                                3'b110:  begin
                                    move <= CMD_RIGHT;
                                    facing <= facing + 1;
                                    flag <= 1;
                                    end

                                3'b111:  begin
                                    move <= CMD_UTURN;
                                    facing <= facing + 2;
                                    flag <= 1;
                                    end

                                default: move <= CMD_STOP;
                        endcase
                    end

                    flag <= 1;
                end
        
    ////////////////////////////////

            if (flag == 1) begin      //for second clock, it is for registering bot info and other stuff added: reverse dfs and retracing
                if(move != CMD_STOP) begin
                    bot_pos <= bot_pos + delta[facing];
                    flag <= 0;

                    if (dfs_mode) begin                //dfs mode, recording the paths(using branch stack and location stack)
                        if(!pop_flag) begin
                            if(wall_sum == 2'd3) begin  // deadend, retrace back to latest junction in pop mode   
                                pop_flag <= 1'b1;
                            end
                            else if(wall_sum == 2'd1 && (bot_pos != branch_stack[branch_sp - 1] || branch_sp == 2'd0)) begin     //managing brach stack.// 1 branch stack entries for 2 open way
                                branch_stack[branch_sp] <= bot_pos;
                                branch_sp <= branch_sp + 1;
                                location_stack[location_sp] <= bot_pos;
                                location_sp <= location_sp + 1;
                            end
                            else if(wall_sum == 2'd0 && (bot_pos != branch_stack[branch_sp - 1] || branch_sp == 2'd0)) begin  //2 branch stack entries for 3 open ways
                                branch_stack[branch_sp] <= bot_pos;
                                branch_stack[branch_sp + 1] <= bot_pos;
                                branch_sp <= branch_sp + 2;          //pointing to next empty location 
                                location_stack[location_sp] <= bot_pos;
                                location_sp <= location_sp + 1;
                            end

                            else begin                  //moving straight
                                location_stack[location_sp] <= bot_pos;
                                location_sp <= location_sp + 1;
                            end
                        end


                        if(pop_flag) begin    
                            if(bot_pos == location_stack[location_sp - 1] && location_stack[location_sp - 1] != branch_stack[branch_sp - 1] ) begin   //if retracing, keep popping location stack until reaching latest junction
                                location_sp <= location_sp - 1;
                            end

                            if(bot_pos == location_stack[location_sp - 1] && location_stack[location_sp - 1] == branch_stack[branch_sp - 1]) begin
                                branch_sp <= branch_sp - 1;   
                                pop_flag <= 1'b0;
                            end 

                        end
                    end


                    if (visited_cell[bot_pos] == 1'b0) begin            //unique cell counter management, we want to explore all 81 cells
                        visited_cell[bot_pos] <= 1'b1;   // mark as explored once
                        unique_cell_counter <= unique_cell_counter + 1;
                    end
                end 
        

                else begin
                    bot_pos <= bot_pos;
                    if (visited_cell[bot_pos] == 1'b0) begin            //unique cell counter management, we want to explore all 81 cells
                        visited_cell[bot_pos] <= 1'b1;   // mark as explored once
                        unique_cell_counter <= unique_cell_counter + 1;
                    end
                    flag <= 0;
                end
            end


        end


 //////////////////////       
    end

    else begin
        move <= CMD_STOP;
        counter <= 0;
        bot_pos <= 8'd76;
        unique_cell_counter <= 0;
        facing <= 2'b00;
        flag <= 0;
        dfs_mode <= 1'b0;
        retrace_mode <= 1'b0;
        branch_sp <= 0;
        location_sp <= 0;
        pop_flag <= 1'b0;

    end

end




//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule

