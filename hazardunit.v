`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:12 11/23/2016 
// Design Name: 
// Module Name:    hazardunit 
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
`define op 31:26
`define funct 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`include"decoder.v"
`include"mux.v"
module hazardunit(
	input [31:0] InstrD,
	input [31:0] InstrE,
	input [31:0] InstrM,
	input [31:0] InstrW,
	input regWriteE,
	input regWriteM,
	input regWriteW,
	input busy,
	output stall,
	output stall_E,
	output [1:0] ForwardRSD,
	output [1:0] ForwardRTD,
	output [1:0] ForwardRSE,
	output [1:0] ForwardRTE,
	output ForwardRTM
    );
	wire krtD, krtE, krtM, mdtagD, mdtagE, mdtagW;
	wire [1:0] Tuse1D, Tuse2D;
	wire [1:0] Tuse1E, Tuse2E, dregE, TnewE;
	wire [1:0] Tuse1M, Tuse2M, dregM, TnewM;
	wire [1:0] dregW, TnewW;
	wire stall_rt, stall_rs, stall_md;
	wire [4:0] regaddE, regaddM, regaddW;
	wire [4:0] tregaddE, tregaddM, tregaddW;
	
	decoderTuse DdecoderTuse(InstrD, krtD, Tuse1D, Tuse2D, mdtagD);
	decoderTuse EdecoderTuse(InstrE, krtE, Tuse1E, Tuse2E, mdtagE);
	decoderTuse MdecoderTuse(InstrM, krtM, Tuse1M, Tuse2M, mdtagW);

	decoderTnew EdecoderTnew(InstrE, dregE, TnewE);
	decoderTnew MdecoderTnew(InstrM, dregM, TnewM);
	decoderTnew WdecoderTnew(InstrW, dregW, TnewW);
	mux4_5 Emux(dregE, InstrE[`rt], InstrE[`rd], 5'h1f, 5'h00, tregaddE);
	mux4_5 Mmux(dregM, InstrM[`rt], InstrM[`rd], 5'h1f, 5'h00, tregaddM);
	mux4_5 Wmux(dregW, InstrW[`rt], InstrW[`rd], 5'h1f, 5'h00, tregaddW);
	
	assign regaddE = regWriteE ? tregaddE : 5'h00;
	assign regaddM = regWriteM ? tregaddM : 5'h00;
	assign regaddW = regWriteW ? tregaddW : 5'h00;
	
	assign stall_rs = ((regaddE != 0) && (InstrD[`rs] == regaddE) && (Tuse1D < (TnewE - 1))) ||
							((regaddM != 0) && (InstrD[`rs] == regaddM) && (Tuse1D < (TnewM - 2)));
	assign stall_rt = ((regaddE != 0) && (InstrD[`rt] == regaddE) && (Tuse2D < (TnewE - 1))) ||
							((regaddM != 0) && (InstrD[`rt] == regaddM) && (Tuse2D < (TnewM - 2)));
	assign stall_md = busy && mdtagD;
	
	assign stall_E = busy && mdtagE;
	assign stall = stall_rs || (stall_rt && krtD) || stall_md || stall_E;
	
	
	assign ForwardRSD = 
			(Tuse1D == 2'b00) && (TnewE == 2'b01) && (regaddE != 0) && (InstrD[`rs] == regaddE) ? 1 :
			(Tuse1D == 2'b00) && (TnewM == 2'b01) && (regaddM != 0) && (InstrD[`rs] == regaddM) ? 2 :
			(Tuse1D == 2'b00) && (TnewM == 2'b10) && (regaddM != 0) && (InstrD[`rs] == regaddM) ? 3 :
																																0;
	assign ForwardRTD = 
			(krtD && Tuse2D == 2'b00) && (TnewE == 2'b01) && (regaddE != 0) && (InstrD[`rt] == regaddE) ? 1 :
			(krtD && Tuse2D == 2'b00) && (TnewM == 2'b01) && (regaddM != 0) && (InstrD[`rt] == regaddM) ? 2 :
			(krtD && Tuse2D == 2'b00) && (TnewM == 2'b10) && (regaddM != 0) && (InstrD[`rt] == regaddM) ? 3 :
																																			0;
	
	assign ForwardRSE =
			(Tuse1E == 2'b01) && (TnewM == 2'b01) && (regaddM != 0) && (InstrE[`rs] == regaddM) ? 1 :
			(Tuse1E == 2'b01) && (TnewM == 2'b10) && (regaddM != 0) && (InstrE[`rs] == regaddM) ? 2 :	
			(Tuse1E == 2'b01) && (TnewW >= 2'b01) && (regaddW != 0) && (InstrE[`rs] == regaddW) ? 3 :
																																0;
	
	assign ForwardRTE =
			(krtE && Tuse2E <= 2'b10) && (TnewM == 2'b01) && (regaddM != 0) && (InstrE[`rt] == regaddM) ? 1 :
			(krtE && Tuse2E <= 2'b10) && (TnewM == 2'b10) && (regaddM != 0) && (InstrE[`rt] == regaddM) ? 2 :
			(krtE && Tuse2E <= 2'b10) && (TnewW >= 2'b01) && (regaddW != 0) && (InstrE[`rt] == regaddW) ? 3 :
																																			0;
	
	assign ForwardRTM = 
			(krtM && Tuse2M == 2'b10) && (TnewW == 2'b11) && (regaddW != 0) && (InstrM[`rt] == regaddW) ? 1 :
																																			0;
endmodule
