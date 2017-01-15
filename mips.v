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
`include"dataEXT.v"
`include"muldivpart.v"
`include"bridge.v"
`include"cp0.v"
module mipscpu(
    input clk,
    input reset,
	 output [31:0] praddr,
	 input [31:0] prrd,
	 output [31:0] prwd,
	 output prwe,
	 input [7:2] HWInt
    );  
	 wire busy, used, stall, ForRTM, cmpout, extcon, npcsel, ALUAsrc, ALUBsrc, MemWrite;
	 wire [31:0] HI, LO, InstrD, InstrE, InstrM, InstrW, RData1, AOM, PC4_M, Drs, Dout, AOE;
	 wire [31:0] RData2, Drt, rsE, PC4_W, WData, Ers, Ert, rtE,rtM, Mrt, pc, Instr, finalPC;
	 wire [31:0] PCinput, ADD4, NPCout, PC4_D, RegAddr, extout, PC4_E,extE, SrcA, SrcB;
	 wire [31:0] ALUResult, Memout, AOW, DRW, EPC, cp0out, Memoutdm, newPCinput, tuse0data;
	 wire [1:0] ForRSD, ForRTD, PCCon, RegDst, RegDa, ForRSE, ForRTE, dmCon, EAO;
	 wire [3:0] ALUControl;
	 wire [2:0] mdCon, ECon;
	 wire [6:2] ExcCode;
	 wire regWriteD, regWriteE, regWriteM, regWriteW, c0we, EXLclr, IntReq, stall_E;
	// assign pca4 = pc + 4;
	// assign luidata = zimm16 << 16;
	// assign MemAddr = ALUResult;
	// assign Memdata = RData2;
	 hazardunit mhazardunit(InstrD, InstrE, InstrM, InstrW, regWriteE, regWriteM, regWriteW, busy, stall, stall_E, ForRSD, ForRTD, ForRSE, ForRTE, ForRTM);
	 mux4 MFRSD(ForRSD, RData1, PC4_E, PC4_M, AOM, Drs);
	 mux4 MFRTD(ForRTD, RData2, PC4_E, PC4_M, AOM, Drt);
	 mux4 MFRSE(ForRSE, rsE, PC4_M, AOM, WData, Ers);
	 mux4 MFRTE(ForRTE, rtE, PC4_M, AOM, WData, Ert);
	 mux2 MFRTM(ForRTM, rtM, WData, Mrt);
	 
	 im mim(pc[12:2], Instr);
	 mux2 intpcsel(EXLclr, PCinput, EPC, newPCinput);
	 mux2 entrance(IntReq, newPCinput, 32'h4180, finalPC);
	 ifu mifu(finalPC, clk, reset, stall, IntReq, pc, ADD4);
	 mux4 MUX_PC(PCCon, ADD4, NPCout, Drs, 32'bx, PCinput);
	 
	 registersD mregistersD(Instr, InstrD, ADD4, PC4_D, clk, stall, reset || IntReq || EXLclr, stall_E);
	 //assign ExcCode = 5'b0;
	 ControllerD mControllerD(InstrD, cmpout, PCCon, extcon, npcsel, regWriteD, c0we, EXLclr, tuse0sel);
	 cp0 mcp0(InstrD[15:11], Drt, pc, HWInt, PCCon == 1 || PCCon == 2, stall_E, c0we, EXLclr, clk, reset, IntReq, EPC, cp0out);
	 grf mgrf(clk, reset, InstrD[25:21], InstrD[20:16], RegAddr[4:0], regWriteW, WData, RData1, RData2);
	 ext mext(InstrD[15:0], extcon, extout);
	// Controller controller(instr[31:26],instr[5:0],zero,MemtoReg,MemWrite,ALUAsrc,ALUBsrc,RegDst,RegWrite,PCControl,ALUControl);
    cmp mcmp(InstrD, Drs, Drt, cmpout);
	 npc mnpc(npcsel, PC4_D, InstrD[25:0], InstrD[15:0], NPCout);
	 mux2 tuse0(tuse0sel, PC4_D + 4, cp0out, tuse0data);
	 
	 registersE mregistersE(clk, stall, stall_E, InstrD, InstrE, tuse0data, PC4_E, Drs, rsE, Drt, rtE, extout, extE, regWriteD, regWriteE, reset);
	 
	 ControllerE mControllerE(InstrE, ALUAsrc, ALUBsrc, ALUControl, used, mdCon, EAO);
	 mux2 ALUAsel(ALUAsrc, Ers, {27'b0,InstrE[10:6]}, SrcA);
	 mux2 ALUBsel(ALUBsrc, Ert, extE, SrcB);
	 alu malu(SrcA, SrcB, ALUResult, ALUControl);
	 muldivpart mmuldiv(SrcA, SrcB, mdCon, HI, LO, busy, used, reset, clk);
	 mux4 AOMsel(EAO, ALUResult, HI, LO, 32'bx, AOE);
	 
	 registersM mregistersM(clk, InstrE, InstrM, PC4_E, PC4_M, AOE, AOM, Ert, rtM, regWriteE, regWriteM, reset || stall_E);
	 
	 assign praddr = AOM;
	 assign prwd = Mrt;
	 assign prwe = MemWrite;
	 ControllerM mControllerM(InstrM[31:26], MemWrite, dmCon);
	 dm mdm(AOM, Mrt, MemWrite && !AOM[13], clk, reset, Memoutdm, dmCon);
	 mux2 dmoutsel(AOM[13], Memoutdm, prrd, Memout);
	 registersW mregistersW(clk, InstrM, InstrW, PC4_M, PC4_W, AOM, AOW, Memout, DRW, regWriteM, regWriteW, reset);
	 
	 dataEXT mdataEXT(AOW[1:0], DRW, ECon, Dout);
	 ControllerW mControllerW(InstrW, RegDst, RegDa, ECon);
	 mux4 RegDstsel(RegDst, {27'b0,InstrW[20:16]}, {27'b0, InstrW[15:11]}, 32'h1f, 32'bx, RegAddr);
	 mux4 RegWrsel(RegDa, AOW, PC4_W, Dout, 32'bx, WData);
	/* 
	 mux4 toreg(MemtoReg, ALUResult, Memout, luidata, pc2reg, WData);
	 mux2 aluas(ALUAsrc, RData1, {27'b0, instr[10:6]}, SrcA);
	 mux4 alubs(ALUBsrc, RData2, simm16, zimm16, 32'bx, SrcB);
	 mux4 Regdst(RegDst, {27'b0, instr[20:16]}, {27'b0, instr[15:11]}, 32'h0000001f, 32'bx, RegAddr);
*/
endmodule
module mips(
    input clk,
    input reset
    );  
	 wire [31:0] addr;
	 wire [31:0] prrd, prwd;
	 wire prwe;
	 wire [7:2] HWInt;
	mipscpu cpu(clk, reset, addr, prrd, prwd, prwe, HWInt);
	bridge mbridge(clk, reset, addr, prrd, prwd, prwe, HWInt);
endmodule
