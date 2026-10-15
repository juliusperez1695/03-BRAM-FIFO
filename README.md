# Lab 3 - BRAM-FIFO

## Overview
This lab assignment involves the design of a FIFO memory unit which utilizes Block RAM (BRAM).  With BRAM, the system clock controls both write and read access by stepping the respective pointers through each address.  The appropriate flags are also implemented at the output to track the status of the BRAM such as when it is about to reach capacity and when it is full.  Similarly, the availability of memory will be tracked via "empty" flags.  A "valid" flag at the output will represent whether a successful read has occurred (i.e. read is enabled and there is something to read from memory -> empty flag is low).  Lastly, a data-read pipeline will be included such that the referenced data will only appear at the output of the FIFO block once a specified number of clock cycles have elapsed.  For proper state propagation of the data, the valid flag shall also propagate through the pipeline.

## Design Summary
![FIFO Block Diagram](images/FIFO_Block_Diagram.png)
Notes:
* For diagram simplification, data I/O for the pipeline block includes both the reference data and the valid flag
* BRAM was implemented through instantiation of an array of registers, and the r_addr and w_addr inputs are included as reg variables within the same verilog module as the FIFO implementation
    * BRAM is shown as its own block for conceptual clarity only

## Verification and Results
Please refer to the included Lab3_Simulation_Output.txt file showing the results of the simulation.

Test Case 0: Assert srst, fill some memory, then reassert srst (Track the output flags and data_count to confirm functionality)
* Results:
    * After initial reset, I partially filled memory to clear the empty flags and add to data_count
    * Reasserting srst resulted in the reassertion of empty/almost_empty and resetting of data_count

Test Case 1: Write din = 0xFFFF, Read back data
* Results:
    * 0xFFFF was successfully read at dout; propagation delay between din and dout was observed as expected (here and throughout all test cases)

Test Case 2: Write din = 0x0000, Read back data
* Results:
    * 0x0000 was successfully read at dout

Test Case 3: Write/Read alternating bit pattern 0xAAAA
* Results:
    * 0xAAAA was successfully read at dout

Test Case 4: Write to every address, then read every address
* Results:
    * 0x5555 was written to all addresses
    * Readback was successful
    * almost_full and full flags were set appropriately upon approaching/reaching capacity

Test Case 5: Fill memory to capacity, then attempt to write again (confirm no change due to flag)
* Results:
    * 0x5555 was written to all addresses
    * Subsequent write of 0x1111 was attempted after reaching capacity
    * Readback was performed and 0x5555 was read back as expected, almost_full and full flags were asserted

Test Case 6: Perform a simultaneous read/write
* Results:
    * Partially filled memory with 0xAAAA to ensure there was data to read back
    * Simultaneously wrote 0x5555 and read from memory - confirmed success

## Known Issues and Limitations
* The most significant hurdle was establishing the appropriate formatting of din when generating the input text file using a Python script (generate_fifo_data.py).  At first, I concatenated the first 3 control bits (srst, r_en, w_en) directly with din which was formatted as hex.  This resulted in the completely wrong hex value being used as input to the FIFO block which of course led to useless simulation output.  After reviewing the verilog code for proper design, I finally checked the text file and noticed the incorrect number of hex digits for 19 total bits.  Addressing this formatting error resulted in the expected outputs given the test inputs listed in the python-generated text file.

## References
https://docs.amd.com/r/2023.1-English/ug901-vivado-synthesis/Memory-Inference-Capabilities
* For introduction to Block RAM concepts and Verilog coding templates

ECE520 Lab 3 Instructions
* For general design guidelines
