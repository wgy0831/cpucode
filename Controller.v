`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:24 11/28/2016 
// Design Name: 
// Module Name:    Controller 
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
module ControllerD(
    input [5:0] Op,
    input [5:0] Funct,
	 input b,
    output reg [1:0] PCControl,
	 output reg EXTCon,
	 output npcsel
    );
	 assign npcsel = Op == `j || Op == `jal;
	 always @(*) begin
		 case(Op)
		   `ori: EXTCon = 0;
			`lw: EXTCon = 1;
			`sw: EXTCon = 1;
			`sltiu: EXTCon = 1;
			`beq: PCControl = b? 1 : 0;
			`jal: PCControl = 3;
			`j  : PCControl = 3;
			`special : 
				if (Funct == 6'b001001 || Funct == 6'b001000) PCControl = 2;
				else PCControl = 0;
			default: PCControl = 0;
		endcase
	end

endmodule
module ControllerE(
    input [5:0] Op,
    input [5:0] Funct,
    output reg ALUAsrc,
    output reg ALUBsrc,
    output reg [2:0] ALUControl
    );
	always @(*) begin
		case (Op)
		`lui:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 7;
		end
		`sltiu: 
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 6;
			end
		`ori: 
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 1;
			end
		`lw: 
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 2;
			end
		`sw: 
			begin
				ALUAsrc = 0;
				ALUBsrc = 1;
				ALUControl = 2;
			end
		`special: 
			begin
				ALUAsrc = 0;
				ALUBsrc = 0;
				case (Funct)
					`addu: ALUControl = 2; 
					`subu: ALUControl = 3;
					`sll: 
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
module ControllerM(
    input [5:0] Op,
    output MemWrite
    );
	assign MemWrite = Op == `sw;

endmodule
module ControllerW(
    input [5:0] Op,
    output reg RegWrite,
	 output reg [1:0] RegDst,
    output reg [1:0] MemtoReg
    );
	 always @(*) begin
		 case(Op)
		/*	`sltiu:
			begin
				MemtoReg = 0;
				RegWrite = 1;
				RegDst = 0;
			end */
			`ori: 
			begin
				MemtoReg = 0;
				RegWrite = 1;
				RegDst = 0;
			end
			`lw: 
			begin
				MemtoReg = 2;
				RegWrite = 1;
				RegDst = 0;
			end
			`sw: RegWrite = 0; 
			`beq: RegWrite = 0;
			`lui: 
			begin
				MemtoReg = 0;
				RegDst = 0;
				RegWrite = 1;
			end
			`jal: 
			begin
				MemtoReg = 1;
				RegDst = 2;
				RegWrite = 1;
			end
			`special: 
			begin
				MemtoReg = 0;
				RegDst = 1;
				RegWrite = 1;
			end
			default: RegWrite = 0;
		endcase
	end
endmodule

