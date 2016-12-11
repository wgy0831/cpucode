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
    input [3:0] ALUControl
    );
	always @(*) begin
		case(ALUControl)
		0 : Result = SrcA & SrcB;
		1 : Result = SrcA | SrcB;
		2 : Result = SrcA + SrcB;
		3 : Result = SrcA - SrcB;
		4 : Result = SrcB << SrcA[4:0];
		5 : Result = SrcB >> SrcA[4:0];
		6 : Result = SrcA ^ SrcB;
		7 : Result = SrcB << 16;
		8 : Result = $signed(SrcB) >>> SrcA[4:0];
		9 : Result = ~ (SrcA | SrcB);
		10: Result = SrcA[31] == SrcB[31] ? SrcA < SrcB : SrcA[31];
		11: Result = SrcA < SrcB;
		default : Result = 0;
		endcase
	end
endmodule
