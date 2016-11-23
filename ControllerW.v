`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:50 11/23/2016 
// Design Name: 
// Module Name:    ControllerW 
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
module ControllerW(
    input [5:0] Op,
    output reg RegWrite,
	 output reg [1:0] RegDst,
    output reg [1:0] MemtoReg
    );
	 always @(*) begin
		 case(Op)
			6'b001011: //sltiu
			begin
				MemtoReg = 0;
				RegWrite = 1;
				RegDst = 0;
			end
			6'b001101: //ori
			begin
				MemtoReg = 0;
				RegWrite = 1;
				RegDst = 0;
			end
			6'b100011: //lw
			begin
				MemtoReg = 1;
				RegWrite = 1;
				RegDst = 0;
			end
			6'b101011: RegWrite = 0; //sw
			6'b000100: RegWrite = 0; //beq
			6'b001111: //lui
			begin
				MemtoReg = 2;
				RegDst = 0;
				RegWrite = 1;
			end
			6'b000011: //jal
			begin
				MemtoReg = 3;
				RegDst = 2;
				RegWrite = 1;
			end
			6'b000000: //special
			begin
				MemtoReg = 0;
				RegDst = 1;
				RegWrite = 1;
			end
			default: RegWrite = 0;
		endcase
	end
endmodule
