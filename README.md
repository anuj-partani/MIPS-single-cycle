# MIPS-single-cycle

This repository contains the Verilog implementation of a single-cycle MIPS processor. The design is a simplified representation of the MIPS architecture, focused on executing basic R-type, I-type, and J-type instructions.


Features


1. Register File: Implements 32 general-purpose registers (each 32-bits )for storing data, with read and write capabilities.
2. ALU (Arithmetic Logic Unit): Performs essential operations such as addition, subtraction, AND, OR, SLT (Set Less Than), and NOR.
3. Instruction Memory: A ROM module initialized with predefined MIPS instructions for simulation.
4. Control Unit: Decodes instruction opcodes and generates appropriate control signals for various modules.
5. Data Memory: Simulates memory operations (load and store) for the MIPS processor.


Modules


1. register_file: Implements the 32-register memory with read and write capabilities.
2. ALU: Executes arithmetic and logical operations based on control signals.
3. ALU_control: Decodes the function field and ALUOp signals to generate ALU control signals.
4. instruction_memory: A ROM that stores and provides instructions based on the program counter.
5. controller: Generates control signals for the entire processor based on the opcode.
6. mux2x1_5bits: A 2-to-1 multiplexer for selecting between two 5-bit inputs.
7. mux2x1_32bits: A 2-to-1 multiplexer for selecting between two 32-bit inputs.
8. MIPS: Top-level module that integrates all components to create a functioning single-cycle MIPS processor.
