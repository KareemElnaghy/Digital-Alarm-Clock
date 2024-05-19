`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 03:21:37 PM
// Design Name: 
// Module Name: modulo60
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


module modulo60(input clk, rst, en,upDown,output [5:0] count);

counter_x_bit  #(6,60) mod60 (.clk(clk), .reset(rst), .en(en),.upDown(upDown), .count(count)); // Calls the counter passing appropriate parameters

endmodule
