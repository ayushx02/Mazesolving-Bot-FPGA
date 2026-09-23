# 🤖 FPGA Maze Solving Robot

An autonomous maze-solving robot built for the **e-Yantra Robotics Competition (eYRC)**. The project combines FPGA-based digital design with real-world robotics to navigate unknown mazes using onboard sensors and custom navigation logic.

### 🚀 Highlights

* 🧩 Autonomous maze navigation
* ⚡ Navigation logic implemented in **Verilog HDL**
* 🔧 Runs on an **FPGA** with custom hardware
* 🤖 Real-time wall detection and motor control
* 🏁 Designed for the e-Yantra robotics challenge

### 1. The Algorithm:
The robot uses a Modified Left-Wall Following (LWF) algorithm.

Unlike a conventional wall-following approach that can stop as soon as the exit is reached, this implementation continues exploring the maze until all 81 cells have been explored.

Once complete exploration is achieved, the robot switches to a retrace mode and uses the stored location information to navigate back toward the exit.

During normal exploration, the robot gives priority to the left path, followed by the forward path, right path, and finally a U-turn when no other path is available. The movement decision is generated from the three wall-sensor inputs and the current orientation of the robot. The controller supports four basic movement commands: STOP, FORWARD, LEFT, RIGHT, and U-TURN.

Instead of stopping immediately when the robot reaches the exit, the implemented algorithm continues exploring the maze until all 81 cells of the 9×9 maze have been visited. Each cell is represented using a visited_cell array, while a unique-cell counter keeps track of the number of previously unexplored cells encountered by the robot. This allows the controller to maintain an internal representation of the exploration progress and determine when the complete maze has been explored.

The controller maintains the robot's current position using a cell-index-based representation. The starting position is represented by bot_pos = 76, corresponding to the specified start location (4,8). Movement between adjacent cells is calculated using directional position offsets, with -9, +1, +9, and -1 corresponding to movement in the four cardinal directions. The robot's orientation is simultaneously tracked using a 2-bit facing register representing North, East, South, and West.

When the robot reaches the exit before completing the exploration of all 81 cells, the controller enters a separate DFS-style exploration mode instead of terminating the run. During this phase, the robot records junctions and its traversal path using dedicated branch and location stacks. Dead ends are detected using the number of surrounding walls, allowing the controller to backtrack to previously encountered junctions and continue exploring unexplored sections of the maze.

When the robot reaches the exit before completing the exploration of all 81 cells, the controller enters a separate DFS-style exploration mode instead of terminating the run. During this phase, the robot records junctions and its traversal path using dedicated branch and location stacks. Dead ends are detected using the number of surrounding walls, allowing the controller to backtrack to previously encountered junctions and continue exploring unexplored sections of the maze.

Two stack-based data structures are used to manage the exploration path. The branch stack stores important junction positions where alternative routes are available, while the location stack records the sequence of positions visited during exploration. When the robot reaches a dead end, the controller uses these stored positions to backtrack toward the latest relevant junction and continue exploring another available branch. This provides the controller with a structured way to manage multiple paths within the maze.

### 2. Path Retracing:
Once all 81 cells have been explored, the controller switches from exploration mode to retrace mode. The stored location information is used to determine the direction required to move from one previously visited cell to another. The controller compares consecutive cell positions and generates the appropriate left, right, or forward movement command based on the robot's current orientation. This allows the robot to reconstruct its route and navigate back toward the designated exit position.

### 3. Verilog Implementation:
The main controller is implemented as the t2c_maze_explorer Verilog module. The module receives the system clock, reset signal, and three wall-sensor inputs and produces a 3-bit movement command. The design uses sequential logic for maintaining the robot's position, orientation, exploration state, stack pointers, and visited-cell information, while combinational logic is used to process the current wall-sensor inputs.

### 🛠️ Tech Stack

`Verilog` • `FPGA` • `Digital Design` • `FSM` • `Embedded Systems`

### 📸 Preview

> <img width="900" height="1600" alt="side_view" src="https://github.com/user-attachments/assets/815a98e1-bccc-426f-bbf3-0987e0625088" />

<img width="1599" height="899" alt="WhatsApp Image 2026-09-23 at 15 44 40" src="https://github.com/user-attachments/assets/015fa6b6-e8dd-4caf-acd2-7d70d622d4f2" />
<img width="1599" height="899" alt="WhatsApp Image 2026-09-23 at 15 44 40" src="https://github.com/user-attachments/assets/29c4bf13-71d9-47d2-a4a4-86d4abff3e84" />


<img width="983" height="792" alt="WhatsApp Image 2026-09-23 at 15 54 43" src="https://github.com/user-attachments/assets/b763204f-13d9-4115-afdb-0aa9f871a3c6" />


### 📹 Demo

Coming soon...
