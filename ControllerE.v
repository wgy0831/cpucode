`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:54 11/23/2016 
// Design Name: 
// Module Name:    ControllerE 
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
module ControllerE(
    input [5:0] Op,
    input [5:0] Funct,
    output reg ALUAsrc,
    output reg [1:0] ALUBsrc,
    output reg [2:0] ALUControl
    );
	always @(*) begin
		case (Op)
		6'b001011: //sltiu
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 6;
			end
		6'b001101: //ori
			begin
				ALUAsrc = 0;
				ALUBsrc = 2;
				ALUControl = 1;
			end
		6'b100011: //lw
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 2;
			end
		6'b101011: //sw
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 2;
			end
		6'b000000: //special
			begin
				ALUAsrc = 0;
				ALUBsrc = 0;
				case (Funct)
					6'b100001: ALUControl = 2; //addu
					6'b100011: ALUControl = 3; //subu
					6'b000000: //sll
					begin
						ALUControl = 4;
						ALUAsrc = 1;
					end
					default: ALUControl = 1;
				endcase
			end
			default: ALUControl = 1;
		endcase
	end
endmodule
