`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:17 11/16/2016 
// Design Name: 
// Module Name:    Controler 
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
module Controller(
    input [5:0] Op,
    input [5:0] Funct,
	 input zero,
	 output reg [1:0] MemtoReg,
	 output reg MemWrite,
	 output reg ALUAsrc,
	 output reg [1:0] ALUBsrc,
	 output reg [1:0] RegDst,
	 output reg RegWrite,
	 output reg [1:0] PCControl,
	 output reg [2:0] ALUControl
    );
	always @(*) begin
		case(Op)
			6'b001011:
			begin
				MemtoReg = 0;
				MemWrite = 0;
				ALUAsrc = 0;
				ALUBsrc = 1;
				RegDst = 0;
				RegWrite = 1;
				PCControl = 0;
				ALUControl = 6;
			end
			6'b001101:
			begin
				MemtoReg = 0;
				MemWrite = 0;
				ALUAsrc = 0;
				ALUBsrc = 2;
				RegDst = 0;
				RegWrite = 1;
				PCControl = 2'b00;
				ALUControl = 1;
			end
			6'b100011:
			begin
				MemtoReg = 1;
				MemWrite = 0;
				ALUAsrc = 0;
				ALUBsrc = 1;
				RegDst = 0;
				RegWrite = 1;
				PCControl = 2'b00;
				ALUControl = 2;
			end
			6'b101011:
			begin
				MemWrite = 1;
				ALUAsrc = 0;
				ALUBsrc = 1;
				RegWrite = 0;
				PCControl = 2'b00;
				ALUControl = 2;
			end
			6'b000100:
			begin
				MemWrite = 0;
				ALUAsrc = 0;
				ALUBsrc = 0;
				RegWrite = 0;
				ALUControl = 3;
				PCControl = zero ? 2'b01 : 2'b00;
			end
			6'b001111:
			begin
				MemtoReg = 2;
				MemWrite = 0;
				RegDst = 0;
				RegWrite = 1;
				PCControl = 2'b00;
			end
			6'b000011:
			begin
				MemtoReg = 3;
				MemWrite = 0;
				RegDst = 2;
				RegWrite = 1;
				PCControl = 2'b11;
			end
			6'b000000:
			begin
				MemtoReg = 0;
				MemWrite = 0;
				ALUBsrc = 0;
				RegDst = 1;
				RegWrite = 1;
				PCControl = 2'b00;
				ALUAsrc = 0;
				case (Funct)
					6'b100001: ALUControl = 2;
					6'b100011: ALUControl = 3;
					6'b001000: 
					begin
						ALUControl = 1;
						PCControl = 2'b10;
					end
					6'b000000:
					begin
						ALUControl = 4;
						ALUAsrc = 1;
					end
					default: RegWrite = 0;
				endcase
			end
			default:
			begin
				MemWrite = 0;
				RegWrite = 0;
			end
		endcase
	end
endmodule
