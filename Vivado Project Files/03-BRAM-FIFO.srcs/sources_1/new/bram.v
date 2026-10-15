`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 04:49:06 PM
// Design Name: 
// Module Name: bram
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


module bram #(
    parameter WIDTH = 16,
    parameter DEPTH = 32
)(
    input clk,
    input r_en,
    input w_en,
    input srst,
    input [DEPTH-1:0] r_addr, w_addr,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);

reg [DEPTH-1:0] ram [WIDTH-1:0];

always @(posedge clk)
begin
if (srst) //active high reset
    dout <= 0;
if (r_en && !w_en) //read only
    dout <= ram[r_addr];
else if (!r_en && w_en) //write only
    ram[w_addr] <= din;
else if (r_en && w_en) //simultaneous read and write
    dout <= ram[r_addr];
    ram[w_addr] <= din;
end

endmodule
