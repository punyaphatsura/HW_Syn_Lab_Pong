`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2023 09:23:51 PM
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input RsRx,
    input btnU,
    output [6:0] seg,
    output [3:0] an,
    output [15:0] led
    );
    
    reg scoreCount1;
    reg scoreCount2;
    reg [7:0] player1Score;
    reg [7:0] player2Score;
    wire [3:0] ps11,ps12,ps21,ps22;
    wire [3:0] ws85;
    wire [19:0] clk_div;
    
    assign led = an;
    assign clk_div[0] = clk;
    assign ps11 = player1Score[7:4];
    assign ps12 = player1Score[3:0];
    assign ps21 = player2Score[7:4];
    assign ps22 = player2Score[3:0];
    
    generate for(genvar i = 0;i<19;i = i+1) begin
        clock_divider div1(clk_div[i],clk_div[i+1]);
    end endgenerate
    
//    assign clockdiv = clk_div[19];
    
//    uart keyboardInput(clk, RsRx, ws85);
    
    initial begin
        scoreCount1 = 1'b0;
        scoreCount2 = 1'b0;
        player1Score = {4'd5,4'd8};
        player2Score = {4'd6,4'd9};
    end
    
    always @(posedge clk, posedge btnU)
    begin
        if (player1Score == 9 || btnU == 1)
            player1Score <= 0;
        else if (scoreCount1 == 1) begin
            if(player1Score[3:0] < 4'd9) player1Score[3:0] = player1Score[3:0] + 1;
            else begin
                if(player1Score[7:4] < 4'd9)
                begin
                    player1Score[3:0] = 4'd0;
                    player1Score[7:4] = player1Score[7:4] + 1;
                end
            end
        end
    end

    always @(posedge clk, posedge btnU)
    begin
        if (player2Score == 9 || btnU == 1)
            player2Score <= 0;
        else if (scoreCount2 == 1) begin
            if(player2Score[3:0] < 4'd9) player2Score[3:0] = player2Score[3:0] + 1;
            else begin
                if(player2Score[7:4] < 4'd9)
                begin
                    player2Score[3:0] = 4'd0;
                    player2Score[7:4] = player2Score[7:4] + 1;
                end
            end
        end
    end
    
    seven_segment_tdm segment_controller(clk_div[19],ps11,ps12,ps21,ps22,seg,an,1);
endmodule