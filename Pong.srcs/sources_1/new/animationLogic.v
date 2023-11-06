`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Thanat Wongsamut
// 
// Create Date: 11/06/2023 09:43:00 PM
// Design Name: Animation Logic
// Module Name: animationLogic
// Project Name: Pong
// Target Devices: BASYS3
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


module animationLogic(
    input clk,
    input reset,
    input [9:0] x,
    input [9:0] y,
    input videoOn,
    input player1Up,
    input player1Down,
    input player2Up,
    input player2Down,
    input stopBall,
    output [2:0] rgb,
    output scorePlayer1,
    output scorePlayer2
);

    reg [2:0] rgb;
    reg scorePlayer1;
    reg scorePlayer2;
    reg scoreCheckerPlayer1;
    reg scoreCheckerPlayer2;
    reg scorer; 
    reg scorerNext;

    // Parameter
    parameter paddleWidth = 10; // width of the paddle
    parameter paddleHeight = 120; // height of the paddle
    parameter paddleVelocity = 10; // velocity of the paddle
    
    parameter ballDefaultX = 300; // default value of the distance between the ball and left side of the screen
    parameter ballDefaultY = 300; // default value of the distance between the ball and top side of the screen
    parameter ballRadius = 8; // radius of the ball
    parameter velocityX = 3; // Horizontal velocity of the ball
    parameter velocityY = 3; // Vertical velocity of the ball

    // Player 1
    integer leftPaddleY; // the distance between paddle and top side of screen
    integer leftPaddleNextY; // the distance between paddle and top side of screen
    parameter leftPaddleX = 20 // the distance between bar and left side of screen
    wire displayLeftPaddle; // to display player 1's paddle in vga
    wire[2:0] rgbLeftPaddle; // player 1's paddle color

    // Player 2
    integer rightPaddleY; // the distance between paddle and top side of screen
    integer rightPaddleNextY; // the distance between paddle and top side of screen
    parameter rightPaddleX = 610 // the distance between bar and left side of screen
    wire displayRightPaddle; // to display player 2's paddle in vga
    wire[2:0] rgbRightPaddle; // player 2's paddle color

    // Ball
    integer ballX; // the distance between the ball and left side of the screen
    integer ballNextX; // the distance between the ball and left side of the screen
    integer ballY; // the distance between the ball and top side of the screen
    integer ballNextY; // the distance between the ball and top side of the screen
    integer velocityXReg; // current horizontal velocity of the ball
    integer velocityXNext; // next horizontal velocity of the ball
    integer velocityYReg; // current vertical velocity of the ball
    integer velocityYNext; // next vertical velocity of the ball
    wire displayBall; // to display ball in vga
    wire[2:0] rgbBall; // ball color

    // Refresh the display
    integer refreshReg;
    integer refreshNext;
    parameter refreshConstant = 830000;
    wire refreshRate;

    // Mux to display
    wire[3:0] outputMux;

    // RGB buffer
    reg[2:0] rgbReg; 
    wire[2:0] rgbNext; 

    // Initialize
    initial begin
        velocityYReg = 0;
        velocityYNext = 0;
        velocityXReg = 0;
        velocityXNext = 0;
        ballX = 300;
        ballNextX = 300;
        ballY = 300;
        ballNextY = 300;

        leftPaddleY = 260;
        leftPaddleNextY = 260;

        rightPaddleY = 260;
        rightPaddleNextY = 260;
    end

    // Refreshing
    always @(posedge clk) begin
        refreshReg <= refreshNext;   
    end

    // Assign refresh logics
    assign refreshNext = refreshReg === refreshConstant ? 0 : refreshReg + 1; 
    assign refreshRate = refreshReg === 0 ? 1'b1 : 1'b0; 

    // Register part
    always @(posedge clk or posedge reset) begin
        if (reset === 1'b1) begin
            // to reset the game
            ballX <= ballDefaultX;
            ballY <= ballDefaultY;
            leftPaddleX <= 260;
            rightPaddleX <= 260;
            velocityXReg <= 0;
            velocityYReg <= 0;
        end
        else begin
            velocityXReg <= velocityXNext; // assigns horizontal velocity
            velocityYReg <= velocityYNext; // assigns vertical velocity

            if (stopBall === 1'b1) begin
                // throw the ball

                if (scorer === 1'b0) begin
                    // if scorer is player 2 throw the ball to player 1.
            
                    velocityXReg <= -3;
                    velocityYReg <= -3;
                end
                else begin
                    // if scorer is player 1 throw the ball to player 2.
                    velocityXReg <= 3;
                    velocityYReg <= 3;
                end
            end

            ballX <= ballNextX; // assigns the next value of the ball's location from the left side of the screen to it's location.
            ballY <= ballNextY; // assigns the next value of the ball's location from the top side of the screen to it's location.  
            leftPaddleY <= leftPaddleNextY; // assigns the next value of the left paddle's location from the top side of the screen to it's location.
            rightPaddleY <= rightPaddleNextY; // assigns the next value of the right paddle's location from the top side of the screen to it's location.
            scorer <= scorerNext;
        end
    end


    // Player 1 animation
    always @(leftPaddleY or refreshRate or player1Up or player1Down) begin
        leftPaddleNextY <= leftPaddleY; // assign leftPaddleY to it's next value   
        if (refreshRate === 1'b1) begin
            // every refreshRate's posedge

            if (player1Up === 1'b1 & leftPaddleY - paddleHeight > paddleVelocity) begin 
                // up button is pressed and paddle can move to up, which mean paddle is not on the top side of the screen.
                leftPaddleNextY <= leftPaddleY - paddleVelocity; // move paddle to the up   
            end

            else if (player1Down === 1'b1 & leftPaddleY < 479 - paddleVelocity) begin
                // down button is pressed and paddle can move down, which mean paddle is not on the bottom side of the screen
                leftPaddleNextY <= leftPaddleY + paddleVelocity;   // move paddle to the down.
            end

            else begin
                leftPaddleNextY <= leftPaddleY;   
            end
        end
    end

    // Player 2 animation
    always @(rightPaddleY or refreshRate or player2Up or player2Down) begin
        rightPaddleNextY <= rightPaddleY; // assign rightPaddleY to it's next value   
        if (refreshRate === 1'b1) begin
            // every refreshRate's posedge

            if (player2Up === 1'b1 & rightPaddleY - paddleHeight > paddleVelocity) begin 
                // up button is pressed and paddle can move to up, which mean paddle is not on the top side of the screen.
                rightPaddleNextY <= rightPaddleY - paddleVelocity; // move paddle to the up   
            end

            else if (player2Down === 1'b1 & rightPaddleY < 479 - paddleVelocity) begin
                // down button is pressed and paddle can move down, which mean paddle is not on the bottom side of the screen
                rightPaddleNextY <= rightPaddleY + paddleVelocity;   // move paddle to the down.
            end

            else begin
                rightPaddleNextY <= rightPaddleY;   
            end
        end
    end

    // Ball animation
    always @(refreshRate or ballX or ballY or velocityXReg or velocityYReg) begin
        ballNextX <= ballX;
        ballNextY <= ballY;

        velocityXNext <= velocityXReg;
        velocityYNext <= velocityYReg;

        scorerNext <= scorer;
        scoreCheckerPlayer1 <= 1'b0; // player 1 did not scored, default value
        scoreCheckerPlayer2 <= 1'b0; // player 2 did not scored, default value

        if (refreshRate === 1'b1) begin
            // every refreshRate's posedge

            if (ballY <= leftPaddleY & ballY >= leftPaddleY - paddleHeight & ballX === leftPaddleX + paddleWidth) begin
                // if ball hits the left paddle
                velocityXNext <= velocityX; // set the direction of horizontal velocity positive
            end

            else if (ballY <= leftPaddleY & ballY >= leftPaddleY - paddleHeight & ballX === rightPaddleX) begin
                // if ball hits the right paddle
                velocityXNext <= -velocityX; // set the direction of horizontal velocity negative
            end

            else if (ballY < 1) begin
                // if ball hits the top side of the screen
                velocityYNext <= velocityY; // set the direction of vertical velocity positive
            end

            else if (ballY > 479) begin
                // if ball hits the top side of the screen
                velocityYNext <= -velocityY; // set the direction of vertical velocity negative
            end

            ballNextX <= ballX + velocityXReg; // move the ball's horizontal location   
            ballNextY <= ballY + velocityYReg; // move the ball's vertical location.

            
            
            
            if (ballX >= 632) begin
                // if player 1 scores, ball passes through the horizontal location of right paddle.
                
                //reset the ball's location to its default
                ballNextX = ballDefaultX
                ballNextY = ballDefaultY

                // stop the ball
                velocityXNext <= 0;
                velocityYNext <= 0;

                // player 1 scored
                scorerNext <= 1'b0;
                scoreCheckerPlayer1 <= 1'b1;
            end
            else begin
                scoreCheckerPlayer1 <= 1'b0;   
            end

            if (ballX <= 8) begin
                // if player 2 scores, ball passes through the horizontal location of left paddle.
                
                //reset the ball's location to its default
                ballNextX = ballDefaultX
                ballNextY = ballDefaultY

                // stop the ball
                velocityXNext <= 0;
                velocityYNext <= 0;

                // player 1 scored
                scorerNext <= 1'b1;
                scoreCheckerPlayer2 <= 1'b1;
            end
            else begin
                scoreCheckerPlayer2 <= 1'b0;   
            end
        end
    end

    // display left paddle object on the screen
    assign displayLeftPaddle = y < leftPaddleY & y > leftPaddleY - paddleHeight & x > leftPaddleX & x < leftPaddleX + paddleWidth ? 1'b1 : 1'b0; 
    assign rgbLeftPaddle = 3'b100; // color of left paddle: blue

    // display right paddle object on the screen
    assign displayRightPaddle = y < rightPaddleY & y > rightPaddleY - paddleHeight & x > rightPaddleX & x < rightPaddleX + paddleWidth ? 1'b1 : 1'b0; 
    assign rgbLeftPaddle = 3'b001; // color of left paddle: red

    // display ball object on the screen
    assign displayBall = (x - ballX) * (x - ballX) + (y - ballY) * (y - ballY) <= ballRadius * ballRadius ? 1'b1 : 1'b0; 
    assign rgbBall = 3'b111; // color of ball: white

    always @(posedge clk) begin 
        rgbReg <= rgbNext;   
    end

    // mux
    assign outputMux = {videoOn, displayLeftPaddle, displayRightPaddle, displayBall}; 

    // assign rgbNext from outputMux.
    assign rgbNext = outputMux === 4'b1000 ? 3'b000: 
                    output_mux === 4'b1100 ? rgbLeftPaddle: 
                    output_mux === 4'b1101 ? rgbLeftPaddle: 
                    output_mux === 4'b1010 ? rgbRightPaddle: 
                    output_mux === 4'b1011 ? rgbRightPaddle: 
                    output_mux === 4'b1001 ? rgbBall:
                    3'b000;
 
    // output part
    assign rgb = rgbReg; 
    assign scorePlayer1 = scoreCheckerPlayer1; 
    assign scorePlayer2 = scoreCheckerPlayer2; 

endmodule