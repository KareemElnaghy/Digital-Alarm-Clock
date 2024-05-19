`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 03:36:25 PM
// Design Name: 
// Module Name: minSecCount
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


module minSecHourCount(input clk, rst, en,adjustAlarm, [1:0] enableMins_Hours, input upDown, output [15:0] displayDigits, output [7:0] secondDigits);

wire [5:0] seconds;
wire [5:0] minutes ;
wire [4:0] hours ;
wire enableMins, enableHours;

modulo60 secondsCounter(.clk(clk), .rst(rst), .en(en),.upDown(1), .count(seconds));

assign enableMins = en ? (seconds == 59): (enableMins_Hours[0] & enableMins_Hours[1]);
modulo60 minutesCounter(.clk(clk), .rst(rst), .en((~adjustAlarm) & enableMins),.upDown(upDown), .count(minutes));

assign enableHours = en ? ((minutes==59) &(seconds ==59)): ((~enableMins_Hours[0]) & enableMins_Hours[1]);
modulo24 hoursCounter(.clk(clk), .rst(rst), .en((~adjustAlarm)& enableHours),.upDown(upDown), .count(hours));

assign displayDigits[3:0] = minutes%10;
assign displayDigits[7:4] = minutes/10; 
assign displayDigits[11:8] = hours%10;
assign displayDigits[15:12] = hours/10;
assign secondDigits [3:0] = seconds%10;
assign secondDigits [7:4] = seconds/10;

endmodule
