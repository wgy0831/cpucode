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
`include"Controller.v"
`include"alu.v"
`include"dm.v"
`include"ext.v"
`include"grf.v"
`include"im.v"
`include"hazardunit.v"
`include"registers.v"
`include"cmp.v"
`include"npc.v"
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
module mux8(
	input [2:0] sel,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [31:0] D,
	input [31:0] E,
	input [31:0] F,
	input [31:0] G,
	input [31:0] H,
	output [31:0] I
	);
	wire [31:0] low, high;
	mux4 lowmux(sel[1:0], A, B, C, D, low);
	mux4 highmux(sel[1:0], E, F, G, H, high);
	mux2 finalmux(sel[2], low, high, I);
endmodule
module mips(
    input clk,
    input reset
    );
	 wire stall, ForRTM, cmpout, RegWrite, extcon, npcsel, ALUAsrc, ALUBsrc, MemWrite;
	 wire [31:0] InstrD, InstrE, InstrM, InstrW, RData1, PC4A_E, AOM, PC4_M, Drs;
	 wire [31:0] RData2, Drt, rsE, PC4_W, WData, Ers, Ert, rtE,rtM, Mrt, pc, Instr;
	 wire [31:0] PCinput, ADD4, NPCout, PC4_D, RegAddr, extout, PC4_E,extE, SrcA, SrcB;
	 wire [31:0] ALUResult, Memout, AOW, DRW;
	 wire [1:0] ForRSD, ForRTD, PCCon, RegDst, RegDa, ForRSE, ForRTE;
	 wire [2:0] ALUControl;
	// assign pca4 = pc + 4;
	// assign luidata = zimm16 << 16;
	// assign MemAddr = ALUResult;
	// assign Memdata = RData2;
	 hazardunit mhazardunit(InstrD, InstrE, InstrM, InstrW, stall, ForRSD, ForRTD, ForRSE, ForRTE, ForRTM);
	 mux4 MFRSD(ForRSD, RData1, PC4_E, PC4_M, AOM, Drs);
	 mux4 MFRTD(ForRTD, RData2, PC4_E, PC4_M, AOM, Drt);
	 mux4 MFRSE(ForRSE, rsE, PC4_M, AOM, WData, Ers);
	 mux4 MFRTE(ForRTE, rtE, PC4_M, AOM, WData, Ert);
	 mux2 MFRTM(ForRTM, rtM, WData, Mrt);
	 im mim(pc[11:2], Instr);
	 ifu mifu(PCinput, clk, reset, stall, pc, ADD4);
	 mux4 MUX_PC(PCCon, ADD4, NPCout, Drs, 32'bx, PCinput);
	 
	 registersD mregistersD(Instr, InstrD, ADD4, PC4_D, clk, stall, reset);
	 
	 ControllerD mControllerD(InstrD[31:26], InstrD[5:0], cmpout, PCCon, extcon, npcsel);
	 grf mgrf(clk, reset, InstrD[25:21], InstrD[20:16], RegAddr[4:0], RegWrite, WData, RData1, RData2);
	 ext mext(InstrD[15:0], extcon, extout);
	// Controller controller(instr[31:26],instr[5:0],zero,MemtoReg,MemWrite,ALUAsrc,ALUBsrc,RegDst,RegWrite,PCControl,ALUControl);
    cmp mcmp(InstrD[31:26], Drs, Drt, cmpout);
	 npc mnpc(npcsel, PC4_D, InstrD[25:0], InstrD[15:0], NPCout);
	 
	 registersE mregistersE(clk, stall, InstrD, InstrE, PC4_D + 4, PC4_E, Drs, rsE, Drt, rtE, extout, extE, reset);
	 
	 ControllerE mControllerE(InstrE[31:26], InstrE[5:0], ALUAsrc, ALUBsrc, ALUControl);
	 mux2 ALUAsel(ALUAsrc, Ers, {27'b0,InstrE[10:6]}, SrcA);
	 mux2 ALUBsel(ALUBsrc, Ert, extE, SrcB);
	 alu malu(SrcA, SrcB, ALUResult, ALUControl);
	 
	 registersM mregistersM(clk, InstrE, InstrM, PC4_E, PC4_M, ALUResult, AOM, Ert, rtM, reset);
	 
	 ControllerM mControllerM(InstrM[31:26], MemWrite);
	 dm mdm(AOM, Mrt, MemWrite, clk, reset, Memout);
	 
	 registersW mregistersW(clk, InstrM, InstrW, PC4_M, PC4_W, AOM, AOW, Memout, DRW, reset);
	 
	 ControllerW mControllerW(InstrW[31:26], RegWrite, RegDst, RegDa);
	 mux4 RegDstsel(RegDst, {27'b0,InstrW[20:16]}, {27'b0, InstrW[15:11]}, 32'h1f, 32'bx, RegAddr);
	 mux4 RegWrsel(RegDa, AOW, PC4_W, DRW, 32'bx, WData);
	/* 
	 mux4 toreg(MemtoReg, ALUResult, Memout, luidata, pc2reg, WData);
	 mux2 aluas(ALUAsrc, RData1, {27'b0, instr[10:6]}, SrcA);
	 mux4 alubs(ALUBsrc, RData2, simm16, zimm16, 32'bx, SrcB);
	 mux4 Regdst(RegDst, {27'b0, instr[20:16]}, {27'b0, instr[15:11]}, 32'h0000001f, 32'bx, RegAddr);
*/
endmodule
