`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 03:43:20 PM
// Design Name: 
// Module Name: modulo24
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


module modulo24(input clk, rst, en,upDown,output [4:0] count);

counter_x_bit  #(5,24) mod24 (.clk(clk), .reset(rst), .en(en),.upDown(upDown), .count(count));  // Calls the counter passing appropriate parameters

endmodule
