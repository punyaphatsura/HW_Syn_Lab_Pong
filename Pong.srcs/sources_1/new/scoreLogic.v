`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Punyaphat
// 
// Create Date: 12/09/2023 09:33:43 PM
// Design Name: 
// Module Name: scoreLogic
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


module scoreLogic(
    input clk,
    input reset,
    input scorePlayer1Count,
    input scorePlayer2Count,
    output wire [7:0] player1Score,
    output wire [7:0] player2Score
);

reg [7:0] p1sReg;
reg [7:0] p2sReg;

assign player1Score = p1sReg;
assign player2Score = p2sReg;

always @(posedge clk) begin
    if(reset == 1) begin 
        p1sReg = 8'd0; // reset score player1
        p2sReg = 8'd0; // reset score player2
    end
    else if (scorePlayer1Count == 1) begin // if player1 score count is 1 then add player1 score
        if(p1sReg[3:0] < 4'd9) p1sReg[3:0] = p1sReg[3:0] + 1;
        else begin
            if(player1Score[7:4] < 4'd9) // If player1 1's unit digit score is 9, then add 1 to the tens and set 1s to 0
            begin
                p1sReg[3:0] = 4'd0;
                p1sReg[7:4] = p1sReg[7:4] + 1;
            end
        end
    end
    else if (scorePlayer2Count == 1) begin // if player2 score count is 1 then add player2 score
        if(p2sReg[3:0] < 4'd9) p2sReg[3:0] = p2sReg[3:0] + 1;
        else begin
            if(player2Score[7:4] < 4'd9) // If player2 1's unit digit score is 9, then add 1 to the tens and set 1s to 0
            begin
                p2sReg[3:0] = 4'd0;
                p2sReg[7:4] = p2sReg[7:4] + 1;
            end
        end
    end
end

endmodule

