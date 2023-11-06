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
    input [15:0] sw,
    output RsTx,
    output [6:0] seg,
    output [3:0] an,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire Hsync,
    output wire Vsync
    );
    
    reg [7:0] player1Score;
    reg [7:0] player2Score;
    reg videoOn;
    reg stopBall;
    wire [9:0] x,y;
    wire player1Up,player1Down,player2Up,player2Down;
    wire [3:0] ps11,ps12,ps21,ps22;
    wire [3:0] ws85;
    wire [19:0] clk_div;
    wire [2:0] rgb_out;
    wire scorePlayer1;
    wire scorePlayer2;
    
    assign led = an;
    assign clk_div[0] = clk;
    assign ps11 = player1Score[7:4];
    assign ps12 = player1Score[3:0];
    assign ps21 = player2Score[7:4];
    assign ps22 = player2Score[3:0];
    assign {player1Up,player1Down,player2Up,player2Down} = ws85;
    assign vgaBlue = {rgb_out[2],rgb_out[2],rgb_out[2]};
    assign vgaGreen = {rgb_out[1],rgb_out[1],rgb_out[1]};
    assign vgaRed = {rgb_out[0],rgb_out[0],rgb_out[0]};
    
    generate for(genvar i = 0;i<19;i = i+1) begin
        clock_divider div1(clk_div[i],clk_div[i+1]);
    end endgenerate
    
//    assign clockdiv = clk_div[19];
    
    uart keyboardInput(clk, RsRx, RsTx, ws85);
    animationLogic animeLogic(
        clk,// input
        btnU,// reset // input
        x,// input
        y,// input
        1, //videoOn // input
        player1Up,// input
        player1Down,// input
        player2Up,// input
        player2Down,// input
        sw[0], // stopBall // input
        rgb_out,
        scorePlayer1,
        scorePlayer2
    );
    vga vga_render(.clk(clk), .reset(reset), .hsync(Hsync), .vsync(Vsync),
                                .video_on(video_on), .p_tick(), .x(x), .y(y));
    
    initial begin
        player1Score = {ps11,ps12};
        player2Score = {ps21,ps22};
    end
    
    always @(posedge clk)
    begin
        if(btnU == 1) begin
            player1Score = 8'd0;
        end
        else if (scorePlayer1 == 1) begin
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

    always @(posedge clk)
    begin
        if(btnU == 1) begin
            player2Score = 8'd0;
        end
        else if (scorePlayer2 == 1) begin
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