`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2023 07:28:25 PM
// Design Name: 
// Module Name: seven_segment_tdm
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


module seven_segment_tdm (
    input clk_src,
    input [3:0] num0,num1,num2,num3,
    output [6:0] seg_output,
    output [3:0] an,
    output dot
);

reg [3:0] hexIn;
reg [1:0] tdm_counter = 2'b00;
reg [3:0] dispEn;
wire clk;

wire [6:0] segments;
wire [19:0] clk_div;

assign seg_output = segments;
assign dot = 1;
assign an = ~dispEn;
assign clk_div[0] = clk_src; // assign clk to clk_div[0]
generate for(genvar i = 0;i<19;i = i+1) begin // divine clock by 2^19 for 7 segment display
    clock_divider div1(clk_div[i],clk_div[i+1]);
end endgenerate
assign clk = clk_div[19];
// Instantiate the Hex to 7-Segment Encoder
hex_to_7seg encoder(hexIn,segments);

always @(posedge clk) begin
    tdm_counter = (tdm_counter == 2'b11) ? 2'b00 : tdm_counter+1; 
end

always @(tdm_counter) begin
    // Rotate the display pattern
    case (tdm_counter)
        2'b00: hexIn = num0;
        2'b01: hexIn = num1;
        2'b10: hexIn = num2;
        2'b11: hexIn = num3;
    endcase
end

always @(tdm_counter) begin
    // Rotate the display pattern
    case (tdm_counter)
        2'b00: dispEn = 4'b1000;
        2'b01: dispEn = 4'b0100; // Display 2
        2'b10: dispEn = 4'b0010; // Display 3
        2'b11: dispEn = 4'b0001; // Display 4
    endcase
end

endmodule
