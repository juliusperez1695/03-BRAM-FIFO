`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 07:14:54 PM
// Design Name: 
// Module Name: sc_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sc_fifo #(
    parameter WIDTH = 16,
    parameter DEPTH = 32,
    parameter ALMOST_EMPTY_THRESHOLD = 1,
    parameter ALMOST_FULL_THRESHOLD = 31,
    parameter READ_LATENCY = 1
)(
    input clk,
    input r_en,
    input w_en,
    input srst,
    input [WIDTH-1:0] din,
    output reg [$clog2(DEPTH+1)-1:0] data_count,
    output reg valid,
    output reg [WIDTH-1:0] dout,
    output almost_full,
    output almost_empty,
    output full,
    output empty
);

reg [WIDTH-1:0] ram [0:DEPTH-1]; // BRAM array instantiation
reg [$clog2(DEPTH)-1:0] r_addr, w_addr;
reg [WIDTH-1:0] dout_stage [0:READ_LATENCY-1]; // for pipelining of read data
reg [READ_LATENCY-1:0] valid_stage; // for pipelining of valid read state along with data
integer i;
    
always @(posedge clk)
begin
if(srst)
begin
    r_addr <= 0;
    w_addr <= 0;
    data_count <= 0;
    valid <= 0;
    for (i = 0; i < READ_LATENCY; i = i + 1)
    begin
        dout_stage[i] <= 0;
    end
end

if(w_en && !full)
begin
    // update BRAM at current write address, then point to next address
    ram[w_addr] <= din;
    if(w_addr >= DEPTH - 1) w_addr <= 0; // wrap back to address 0
    else w_addr <= w_addr + 1;
end

if(r_en && !empty)
begin
    // fill first stage of read pipeline with BRAM data
    dout_stage[0] <= ram[r_addr];
    // point to next address to be read, wrap back to address 0 after DEPTH-1 is reached
    if(r_addr >= DEPTH - 1) r_addr <= 0;
    else r_addr <= r_addr + 1;
end
else dout_stage[0] <= 0; // clear initial pipeline stage for invalid read

valid_stage[0] <= r_en && !empty; // set the initial pipeline stage for valid read request

// pipelining when READ_LATENCY > 1
if(READ_LATENCY - 1 > 0)
begin
    for(i=1; i<READ_LATENCY; i=i+1)
    begin
        if(valid_stage[i-1]) dout_stage[i] <= dout_stage[i-1];
        valid_stage[i] <= valid_stage[i-1];
    end
end

// passing of final pipeline stage data to FIFO output ports
dout <= dout_stage[READ_LATENCY - 1];
valid <= valid_stage[READ_LATENCY - 1];

// update data_count only for isolated read/write, since simultaneous results in zero change
if(r_en && !w_en && !empty) data_count <= data_count - 1;
else if(!r_en && w_en && !full) data_count <= data_count + 1;

end

// combinational logic for output flags for immediate assertion/deassertion
assign almost_full = data_count >= ALMOST_FULL_THRESHOLD;
assign almost_empty = data_count <= ALMOST_EMPTY_THRESHOLD;
assign full = data_count == DEPTH;
assign empty = data_count == 0;


endmodule
