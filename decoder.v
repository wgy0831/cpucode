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
`define ori     6'b001101
`define lw      6'b100011
`define sw      6'b101011
`define addu    6'b100001
`define subu    6'b100011
`define sll     6'b000000
`define jr      6'b001000
`define lui     6'b001111
`define add     6'b100000
`define addi    6'b001000
`define addiu   6'b001001
`define sub     6'b100010
`define bne     6'b000101
`define srl     6'b000010
`define and     6'b100100
`define or      6'b100101
`define xor     6'b100110
`define jalr    6'b001001
`define lb      6'b100000
`define lbu     6'b100100
`define lh      6'b100001
`define lhu     6'b100101
`define sb      6'b101000
`define sh      6'b101001
`define mult    6'b011000
`define multu   6'b011001
`define div     6'b011010
`define divu    6'b011011
`define sra     6'b000011
`define sllv    6'b000100
`define srlv    6'b000110
`define srav    6'b000111
`define nor     6'b100111
`define xori    6'b001110
`define slt     6'b101010
`define slti    6'b001010
`define sltiu   6'b001011
`define sltu    6'b101011
`define blez    6'b000110
`define bgtz    6'b000111
`define regimm  6'b000001
`define bltz    5'b00000
`define bgez    5'b00001
`define mfhi    6'b010000
`define mflo    6'b010010
`define mthi    6'b010001
`define mtlo    6'b010011
`define andi    6'b001100
`define op 31:26
`define funct 5:0

module decoderTuse(
    input [31:0] Instr,
    output reg krt,
	 output reg [1:0] Tuse1,
	 output reg [1:0] Tuse2,
	 output tag
	 );
	 
	 assign tag = (Instr[`funct] == `mult || Instr[`funct] == `multu || Instr[`funct] == `div ||
					  Instr[`funct] == `divu || Instr[`funct] == `mthi || Instr[`funct] == `mtlo ||
					  Instr[`funct] == `mfhi || Instr[`funct] == `mflo) && Instr[`op] == `special;
	 always @(*) begin
		case (Instr[`op])
			`andi: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`regimm:  begin
				krt = 0;
				Tuse1 = 2'b00;
				Tuse2 = 2'b00;
			end
	//						
			`bgtz: begin
				krt = 0;
				Tuse1 = 2'b00;
				Tuse2 = 2'b00;
			end
			`blez: begin
				krt = 0;
				Tuse1 = 2'b00;
				Tuse2 = 2'b00;
			end
			`sltiu: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`slti: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`xori: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`addi: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`addiu: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`lui: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`ori: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`special:
				if(Instr[`funct] == `jr || Instr[`funct] == `jalr) begin
					krt = 0;
					Tuse1 = 2'b00;
					Tuse2 = 2'b00;
				end else begin
					krt = 1;
					Tuse1 = 2'b01;
					Tuse2 = 2'b01;
				end
			`beq: begin
				krt = 1;
				Tuse1 = 2'b00;
				Tuse2 = 2'b00;
			end
			`bne: begin
				krt = 1;
				Tuse1 = 2'b00;
				Tuse2 = 2'b00;
			end
			`lb: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`lbu: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`lh: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`lhu: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`lw: begin
				krt = 0;
				Tuse1 = 2'b01;
				Tuse2 = 2'b00;
			end
			`sb: begin
				krt = 1;
				Tuse1 = 2'b01;
				Tuse2 = 2'b10;
			end
			`sh: begin
				krt = 1;
				Tuse1 = 2'b01;
				Tuse2 = 2'b10;
			end
			`sw: begin
				krt = 1;
				Tuse1 = 2'b01;
				Tuse2 = 2'b10;
			end
			default: begin
				krt = 0;
				Tuse1 = 2'b11;
				Tuse2 = 2'b00;
			end
		endcase
	end
endmodule
module decoderTnew(
    input [31:0] Instr,
    output reg [1:0] dreg,
	 output reg [1:0] Tnew 
	 );
	  always @(*) begin
		case (Instr[`op])
			`andi: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`sltiu: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`slti: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`xori: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`addi: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`addiu: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`lui: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`ori: begin
				dreg = 0;
				Tnew = 2'b10;
			end
			`jal: begin
				dreg = 2'b10;
				Tnew = 2'b01;
			end
			`special:
				if (Instr[`funct] == `jalr) begin
					dreg = 2'b01;
					Tnew = 2'b01;
				end else
				begin
					dreg = 2'b01;
					Tnew = 2'b10;
				end
			`lb: begin
				dreg = 0;
				Tnew = 2'b11;
			end
			`lbu: begin
				dreg = 0;
				Tnew = 2'b11;
			end
			`lh: begin
				dreg = 0;
				Tnew = 2'b11;
			end
			`lhu: begin
				dreg = 0;
				Tnew = 2'b11;
			end
			`lw: begin
				dreg = 0;
				Tnew = 2'b11;
			end
			default: begin
				dreg = 2'b11;
				Tnew = 2'b00;
			end
		endcase
	end
endmodule
