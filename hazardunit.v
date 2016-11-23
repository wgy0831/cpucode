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
module hazardunit(
	input [31:0] InstrD,
	input [31:0] InstrE,
	input [31:0] InstrM,
	output stall
    );
	wire  cal_r_E, cal_i_E, load_E, load_M, btypeD, cal_r_D, cal_i_D, load_D, equalErd, equalErt, equalMrt;
	wire stall_b, stall_cal_r_D, stall_cal_i_D, stall_load_D;
	wire [3:0] iEt, iMt, iDt;
	decoder Ddecoder(InstrD, iDt);
	decoder Edecoder(InstrE, iEt);
	decoder Mdecoder(InstrM, iMt);
	assign cal_r_E = iEt == 1;
	assign btypeD = iDt == 3;
	assign cal_i_E = iEt == 2;
	assign load_E = iEt == 4;
	assign load_M = iMt == 4;
	assign cal_r_D = iDt == 1;
	assign cal_i_D = iDt == 2;
	assign load_D = iDt == 4;
	assign equalErd = (InstrD[`rs] == InstrE[`rd]) || (InstrD[`rt] == InstrE[`rd]);
	assign equalErt = (InstrD[`rs] == InstrE[`rt]) || (InstrD[`rt] == InstrE[`rt]);
	assign equalMrt = (InstrD[`rs] == InstrM[`rt]) || (InstrD[`rt] == InstrM[`rt]);
	assign stall_b =  beq && (cal_r_E && equalErd ||
									  cal_i_E && equalErt ||
									  load_E  && equalErt ||
									  load_M  && equalMrt  );
	assign stall_cal_r_D = cal_r_D && load_E && equalErt;
	assign stall_cal_i_D = cal_i_D && load_E && equalErt;
	assign stall_load_D = load_D && load_E && equalErt;
	assign stall = stall_b || stall_cal_r_D || stall_cal_i_D || stall_load_D;

endmodule
