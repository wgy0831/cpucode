`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:02:55 11/16/2016 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [31:0] SrcA,
    input [31:0] SrcB,
    output reg [31:0] Result,
    output zero,
    input [2:0] ALUControl
    );
	 assign zero = Result == 0;
	always @(*) begin
		case(ALUControl)
		0 : Result = SrcA & SrcB;
		1 : Result = SrcA | SrcB;
		2 : Result = SrcA + SrcB;
		3 : Result = SrcA - SrcB;
		4 : Result = SrcB << SrcA;
		5 : Result = SrcB >> SrcA;
		6 : Result = SrcA < SrcB;
		default : Result = 0;
		endcase
	end
endmodule
