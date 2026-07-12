# RISC-V-processor
Design and implementation of a 5-stage RISC-V pipelined processor
What is this project?
I built a RISC-V processor from scratch and evolved it through three main design steps. It started as a basic single-cycle core, turned into a 5-stage pipelined processor to make it run faster, and finally got dedicated hardware blocks to fix pipeline hazards (data conflicts caused by running multiple instructions at once).

The 3 Phases of the Project
Phase 1: Single-Cycle RISC-V Core
First, I built a basic processor where every single instruction has to finish its entire job in just one clock cycle.

The Problem: It was slow. The clock speed had to wait for the absolute longest instruction (like loading data from memory) to finish before the next clock tick could happen. This created a major speed bottleneck.

Phase 2: Moving to a 5-Stage Pipeline
To fix the speed issue, I chopped the processor's work into 5 smaller stages: Fetch, Decode, Execute, Memory, and Writeback. I placed registers between these stages so instructions could move through the processor like an assembly line.

The Result: The clock speed shot up because the path for each cycle became much shorter.

The New Problem: Because multiple instructions were now overlapping in the pipeline, they started crashing into each other. For example, a new instruction would try to read data that an older instruction hadn't finished writing yet.

Phase 3: Fixing the Hazards (The Final Design)
To make the pipeline actually usable without breaking data or calculations, I added two clever control blocks:

Forwarding Unit: This solves most data conflicts. If a new instruction needs a piece of data that is still moving through the pipeline, this unit takes a shortcut and feeds it directly into the ALU inputs, skipping the wait.

Hazard Detection Unit: This handles the tricky stuff that shortcuts can't fix. It pauses the pipeline for 1 cycle (adds a "bubble") if an instruction tries to use data right after a memory load. It also clears out the wrong instructions if the processor guesses a branch path incorrectly.
