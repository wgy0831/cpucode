`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:17 12/06/2016 
// Design Name: 
// Module Name:    mux 
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

module mux2(
	input sel,
	input [31:0] A,
	input [31:0] B,
	output [31:0] C
	);
	assign C = sel ? B : A;
endmodule

module mux4(
	input [1:0] sel,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [31:0] D,
	output [31:0] E
	);
	wire [31:0] low, high;
	mux2 lowmux(sel[0], A, B, low);
	mux2 highmux(sel[0], C, D, high);
	mux2 finalmux(sel[1], low, high, E);
endmodule
module mux2_5(
	input sel,
	input [4:0] A,
	input [4:0] B,
	output [4:0] C
	);
	assign C = sel ? B : A;
endmodule
module mux4_5(
	input [1:0] sel,
	input [4:0] A,
	input [4:0] B,
	input [4:0] C,
	input [4:0] D,
	output [4:0] E
	);
	wire [4:0] low, high;
	mux2_5 lowmux(sel[0], A, B, low);
	mux2_5 highmux(sel[0], C, D, high);
	mux2_5 finalmux(sel[1], low, high, E);
endmodule
module mux8(
	input [2:0] sel,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [31:0] D,
	input [31:0] E,
	input [31:0] F,
	input [31:0] G,
	input [31:0] H,
	output [31:0] I
	);
	wire [31:0] low, high;
	mux4 lowmux(sel[1:0], A, B, C, D, low);
	mux4 highmux(sel[1:0], E, F, G, H, high);
	mux2 finalmux(sel[2], low, high, I);
endmodule
