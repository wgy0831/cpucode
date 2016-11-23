`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:28:52 11/23/2016 
// Design Name: 
// Module Name:    decoder 
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
module decoder(
    input [31:0] Instr,
    output [3:0] InstrType
    );
	always @(*) begin
		case (Instr[31:26])
			6'b001111: InstrType = 2;
			6'b001101: InstrType = 2;
			6'b000000: InstrType = 1;
			6'b000100: InstrType = 3;
			6'b100011: InstrType = 4;
			default: InstrType = 0;
		endcase
	end
endmodule
