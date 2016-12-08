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
`define op 31:26
`define funct 5:0
module ControllerD(
    input [31:0] Instr,
	 input b,
    output reg [1:0] PCControl,
	 output reg EXTCon,
	 output npcsel,
	 output RegWrite
    );
	 wire [5:0] Op, Funct;
	 assign Op = Instr[`op];
	 assign Funct = Instr[`funct];
	 assign npcsel = Op == `j || Op == `jal;
	 assign RegWrite = Op == `ori || Op == `lw || Op == `jal || 
						Op == `lui || Op == `addi || Op == `addiu || 
						Op == `xori || Op == `slti || Op == `sltiu ||
						(Op == `special && Funct != `jr);
	 always @(*) begin
		 case(Op)
			`regimm: PCControl = b ? 1 : 0;
//
			`bgtz: PCControl = b ? 1 : 0;
			`blez: PCControl = b ? 1 : 0;
			`sltiu: begin
				EXTCon = 1;
				PCControl = 0;
			end
			`slti: begin
				EXTCon = 1;
				PCControl = 0;
			end
			`xori: begin
				EXTCon = 0;
				PCControl = 0;
			end
			`addi: begin
				EXTCon = 1;
				PCControl = 0;
			end
			`addiu: begin
				EXTCon = 1;
				PCControl = 0;
			end
		   `ori: begin 
				EXTCon = 0;
				PCControl = 0;
			end
			`lw: begin
				EXTCon = 1;
				PCControl = 0;
			end
			`sw: begin
				EXTCon = 1;
				PCControl = 0;
			end
			`bne: PCControl = b? 1 : 0;
			`beq: PCControl = b? 1 : 0;
			`jal: PCControl = 1;
			`j  : PCControl = 1;
			`special : 
				if (Funct == `jalr || Funct == `jr) PCControl = 2;
				else PCControl = 0;
			default: PCControl = 0;
		endcase
	end

endmodule
module ControllerE(
    input [31:0] Instr,
    output reg ALUAsrc,
    output reg ALUBsrc,
    output reg [3:0] ALUControl
    );
	 wire [5:0] Op, Funct;
	 assign Op = Instr[`op];
	 assign Funct = Instr[`funct];
	always @(*) begin
		case (Op)
		`sltiu:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 11;
		end
		`slti:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 10;
		end
		`xori:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 6;
		end
		`addi:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 2;
		end
		`addiu:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 2;
		end
		`lui:
		begin
			ALUAsrc = 0;
			ALUBsrc = 1;
			ALUControl = 7;
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
					`sltu: ALUControl = 11;
					`sub: ALUControl = 3;
					`srl: 
					begin
						ALUControl = 5;
						ALUAsrc = 1;
					end
					`and: ALUControl = 0;
					`or: ALUControl = 1;
					`xor: ALUControl = 6;
					`add: ALUControl = 2;
					`addu: ALUControl = 2; 
					`subu: ALUControl = 3;
					`sll: 
					begin
						ALUControl = 4;
						ALUAsrc = 1;
					end
					`sra:
					begin
						ALUControl = 8;
						ALUAsrc = 1;
					end
					`sllv: ALUControl = 4;
					`srlv: ALUControl = 5;
					`srav: ALUControl = 8;
					`nor: ALUControl = 9;
					`slt: ALUControl = 10;
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
    input [31:0] Instr,
	 output reg [1:0] RegDst,
    output reg [1:0] MemtoReg
    );
	 wire [5:0] Op, Funct;
	 assign Op = Instr[`op];
	 assign Funct = Instr[`funct];
	 always @(*) begin
		 case(Op)
			`sltiu:
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`slti:
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`xori:
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`addi:
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`addiu:
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`ori: 
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`lw: 
			begin
				MemtoReg = 2;
				RegDst = 0;
			end 
			`lui: 
			begin
				MemtoReg = 0;
				RegDst = 0;
			end
			`jal: 
			begin
				MemtoReg = 1;
				RegDst = 2;
			end
			`special: 
				if (Funct == `jalr)
				begin
					MemtoReg = 1;
					RegDst = 2;
				end else begin
					MemtoReg = 0;
					RegDst = 1;
				end
			default: begin
				MemtoReg = 0;
				RegDst = 0;
			end
		endcase
	end
endmodule

