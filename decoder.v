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
`define beq     6'b000100
`define jal     6'b000011
`define j       6'b000010
`define special 6'b000000
`define sltiu   6'b001011
`define ori     6'b001101
`define lw      6'b100011
`define sw      6'b101011
`define addu    6'b100001
`define subu    6'b100011
`define sll     6'b000000
`define jr      6'b001000
`define lui     6'b001111
`define op 31:26
`define funct 5:0
module decoder(
    input [31:0] Instr,
    output reg [3:0] InstrType //2 means imm, 1 means r, 3 means bxx, 4 means load, 5 means jr, 6means jal, 7 means store
    );
	always @(*) begin
		case (Instr[`op])
			`lui: InstrType = 2;
			`ori: InstrType = 2;
			`special: case(Instr[`funct])
				`jr:InstrType = 5;
				default: InstrType = 1;
				endcase
			`jal: InstrType = 6;
			`beq: InstrType = 3;
			`lw: InstrType = 4;
			`sw: InstrType = 7;
			default: InstrType = 0;
		endcase
	end
endmodule
