`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:59 11/16/2016 
// Design Name: 
// Module Name:    mips 
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
`include"Controler.v"
`include"alu.v"
`include"dm.v"
`include"ext.v"
`include"grf.v"
`include"im.v"

module mux2(
	input sel,
	input [31:0] A,
	input [31:0] B,
	output [31:0] C
	);
	assign C = sel ? B : A;
endmodule
module mux4(
	input [1:0] sel,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [31:0] D,
	output [31:0] E
	);
	wire [31:0] low, high;
	mux2 lowmux(sel[0], A, B, low);
	mux2 highmux(sel[0], C, D, high);
	mux2 finalmux(sel[1], low, high, E);
endmodule
module mips(
    input clk,
    input reset
    );
	 wire [31:0] instr, pc, pca4, simm16, luidata, zimm16, jdata, pc2reg, ALUResult, SrcA, SrcB, RegAddr, WData, RData1, RData2, MemAddr, Memdata, Memout;
	 wire zero, MemWrite, ALUAsrc, RegWrite, jsel;
	 wire [1:0] MemtoReg, ALUBsrc, RegDst, PCControl;
	 wire [2:0] ALUControl;
	 assign pca4 = pc + 4;
	 assign luidata = zimm16 << 16;
	 assign MemAddr = ALUResult;
	 assign Memdata = RData2;
	 im mim(pc[11:2], instr);
	 ifu mifu(simm16, ALUResult, {pca4[31:28],instr[25:0], 2'b00}, clk, reset, PCControl, pc, pc2reg);
	 Controller controller(instr[31:26],instr[5:0],zero,MemtoReg,MemWrite,ALUAsrc,ALUBsrc,RegDst,RegWrite,PCControl,ALUControl);
	 alu malu(SrcA, SrcB, ALUResult, zero, ALUControl);
	 ext mext(instr[15:0], simm16, zimm16);
	 grf mgrf(clk, reset, instr[25:21], instr[20:16], RegAddr[4:0], RegWrite, WData, RData1, RData2);
	 dm mdm(MemAddr, Memdata, MemWrite, clk, reset, Memout);
	 mux4 toreg(MemtoReg, ALUResult, Memout, luidata, pc2reg, WData);
	 mux2 aluas(ALUAsrc, RData1, {27'b0, instr[10:6]}, SrcA);
	 mux4 alubs(ALUBsrc, RData2, simm16, zimm16, 32'bx, SrcB);
	 mux4 Regdst(RegDst, {27'b0, instr[20:16]}, {27'b0, instr[15:11]}, 32'h0000001f, 32'bx, RegAddr);

endmodule
