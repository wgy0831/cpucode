`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:39 11/30/2016 
// Design Name: 
// Module Name:    cmp 
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
`define beq 3'b000
module cmp(
    input [3:0] btype,
    input [31:0] RData1,
    input [31:0] RData2,
    output reg cmpout
    );
	always @(*)
	case (btype)
		`beq: cmpout = RData1 == RData2;
		default cmpout = 0;
	endcase
endmodule
