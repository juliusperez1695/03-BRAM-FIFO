`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 05:00:49 PM
// Design Name: 
// Module Name: tb_sc_fifo
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

module tb_sc_fifo;

localparam WIDTH = 16;
localparam DEPTH = 32;
localparam CLK_PERIOD_NS = 20;
localparam MAX_VECTOR_WIDTH = 19; // {srst}{r_en}{w_en}{din} --> 19 bits
localparam MAX_TEMP_MEMDEPTH = 1000;

reg clk, r_en, w_en, srst;
reg[WIDTH-1:0] din;
reg[MAX_VECTOR_WIDTH-1:0] temp_mem[0:MAX_TEMP_MEMDEPTH-1];
reg[MAX_VECTOR_WIDTH-1:0] input_vector;
integer addr = 0;
wire[$clog2(DEPTH+1)-1:0] data_count;
wire valid;
wire[WIDTH-1:0] dout;
wire almost_full, almost_empty, full, empty;

sc_fifo sc_fifo_UUT(
    .clk(clk),
    .r_en(r_en),
    .w_en(w_en),
    .srst(srst),
    .din(din),
    .data_count(data_count),
    .valid(valid),
    .dout(dout),
    .almost_full(almost_full),
    .almost_empty(almost_empty),
    .full(full),
    .empty(empty)
);

// clock gen
initial begin
    clk = 0;
    forever #(CLK_PERIOD_NS/2) clk = ~clk;
end

// handle test cases and read input vectors from text file
initial begin
    // initialize inputs
    clk = 0;
    r_en = 0;
    w_en = 0;
    srst = 0;
    din = 0;
    
    // read text file into temp_mem
    $readmemh("input_data.txt", temp_mem);
    
    // iteratively update inputs using temp_mem registers
    while(temp_mem[addr] !== 19'bx && addr < MAX_TEMP_MEMDEPTH)
    begin
        @(negedge clk);
        input_vector = temp_mem[addr];
        srst = input_vector[18];
        r_en = input_vector[17];
        w_en = input_vector[16];
        din = input_vector[15:0];
        addr = addr + 1;
    end
    
    #10000
    $finish;
    
end

initial 
begin 
$display("srst | r_en | w_en | valid | din | dout | data_count | almost_empty | empty | almost_full | full");
$monitor("  %b      %b     %b      %b    %h     %h         %d          %b           %b        %b          %b", srst, r_en, w_en, valid, din, dout, data_count, almost_empty, empty, almost_full, full);
end

endmodule
