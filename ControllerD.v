`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:28 11/23/2016 
// Design Name: 
// Module Name:    ControllerD 
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
module ControllerD(
    input [5:0] Op,
    input [5:0] Funct,
	 input b,
    output reg [1:0] PCControl
    );
	 always @(*) begin
		 case(Op)
			6'b000100: PCControl = b? 1 : 0; //beq
			6'b000011: PCControl = 3;//jal
			6'b000010: PCControl = 3; //j
			6'b000000: //special
				if (Funct == 6'b001001 || Funct == 6'b001000) PCControl = 2;
				else PCControl = 0;
			default: PCControl = 0;
		endcase
	end

endmodule
