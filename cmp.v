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
`define beq 6'b000100
`define bne 6'b000101
`define blez    6'b000110
`define bgtz    6'b000111
`define regimm  6'b000001
`define bltz    5'b00000
`define bgez    5'b00001
module cmp(
    input [31:0] Instr,
    input [31:0] RData1,
    input [31:0] RData2,
    output reg cmpout
    );
	wire [5:0] op;
	assign op = Instr[31:26];
	always @(*)
	case (op)
		`bne: cmpout = RData1 != RData2;
		`beq: cmpout = RData1 == RData2;
		`blez: cmpout = RData1[31] || RData1 == 0;
		`bgtz: cmpout = ! RData1[31] && RData1 > 0;
		`regimm: case(Instr[20:16])
						`bltz: cmpout = RData1[31];
						`bgez: cmpout = ! RData1[31] && RData1 >= 0;
						default: cmpout = 0;
					endcase
		default: cmpout = 0;
	endcase
endmodule
