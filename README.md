# Pipelined 5-stage RISC-V Processor Implementation
This repository contains the Verilog implementation of a pipelined 5-stage RISC-V processor. The processor architecture follows the standard RISC-V ISA (Instruction Set Architecture) and is organized into five pipeline stages: Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back.
## Overview
The RISC-V processor in this project is designed with a pipelined architecture, allowing for improved instruction throughput and performance. Each pipeline stage is responsible for a specific set of tasks, resulting in efficient and parallel execution of instructions.

### The 5 stages of the pipeline are as follows:
**1.IF (Instruction Fetch):** Fetches instructions from memory - implemented in ```IF.v```

**2.ID (Instruction Decode):** Decodes instructions and reads register values - implemented in ```ID.v```

**3.EX (Execute):** Performs arithmetic and logic operations - implemented in ```EX.v```

**4.MEM (Memory Access):** Handles memory operations (load and store) - implemented in ```EX_MEM.v```

**5.WB (Write Back):** Writes the results back to registers - implemented in ```MEM_WB.v```

These 5 stages are linked together using pipe registers to create the complete processor in ```RISC_V_COMPLETE.v```

## How to use:
Clone the repository, then use a Verilog simulator to simulate the ```RISC_V_COMPLETE_TB``` file.
If you own a copy of Xylinx Vivado, just open the ```RISC_V_IF_ID.xpr``` project file and from the environment select ```Run Behavioral Simulation```

## Complete Circuit Schematic of the Processor:
![Circuit_schematic](https://github.com/IonutBirjovanu/RISC-V-Processor-Implementation/assets/44101580/3979d6d0-bdb6-47cf-bbdf-930cdde7f9ca)
