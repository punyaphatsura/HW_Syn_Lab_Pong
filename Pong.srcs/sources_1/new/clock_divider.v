`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2023 07:34:05 PM
// Design Name: 
// Module Name: clock_div
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


module clock_divider (
    input clk,
    output clk_out
);

reg clk_out;

initial
begin
    clk_out = 0;
end

always @(posedge clk) begin
    clk_out = ~clk_out;
end
endmodule
