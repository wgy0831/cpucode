`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:21:03 12/20/2016 
// Design Name: 
// Module Name:    bridge 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "timer.v"
module bridge(
    input clk,
	 input reset,
    input [31:0] addr,
    output [31:0] dataO,
    input [31:0] dataI,
    input we,
    output [7:2] HWInt
    );
	wire selt0, selt1, irq0, irq1;
	wire [31:0] dataO0, dataO1;
	assign selt0 = addr[15:8] == 8'h7f && !addr[4];
	assign selt1 = addr[15:8] == 8'h7f && addr[4];
	timer timer0(clk, reset, addr[3:2], we && selt0, dataI, dataO0, irq0);
	timer timer1(clk, reset, addr[3:2], we && selt1, dataI, dataO1, irq1);
	assign dataO = selt0? dataO0 : selt1 ? dataO1 : 0;
	assign HWInt = {4'b0, irq1, irq0};

endmodule
