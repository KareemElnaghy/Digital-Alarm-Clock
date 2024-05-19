`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 04:15:57 PM
// Design Name: 
// Module Name: alarmHourMinCounter
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


module alarmHourMinCounter(input clk, rst, en, [1:0] enableMins_Hours, input upDown, output [15:0] displayDigits);

wire [5:0] minutes ;
wire [4:0] hours ;
wire enableMins, enableHours;

assign enableMins = (enableMins_Hours[0] & enableMins_Hours[1]);
modulo60 minutesCounter(.clk(clk), .rst(rst), .en(en & enableMins),.upDown(upDown), .count(minutes));

assign enableHours = (~enableMins_Hours[0]) & enableMins_Hours[1];
modulo24 hoursCounter(.clk(clk), .rst(rst), .en(en & enableHours),.upDown(upDown), .count(hours));

assign displayDigits[3:0] = minutes%10;
assign displayDigits[7:4] = minutes/10; 
assign displayDigits[11:8] = hours%10;
assign displayDigits[15:12] = hours/10;

endmodule
