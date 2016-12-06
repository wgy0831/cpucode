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
							 Op == `special && Funct == `jalr;
	 always @(*) begin
		 case(Op)
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
    output reg [2:0] ALUControl
    );
	 wire [5:0] Op, Funct;
	 assign Op = Instr[`op];
	 assign Funct = Instr[`funct];
	always @(*) begin
		case (Op)
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

