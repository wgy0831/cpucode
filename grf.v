`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:17:14 11/16/2016 
// Design Name: 
// Module Name:    grf 
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
module grf(
    input Clk,
    input Reset,
    input [4:0] RS1,
    input [4:0] RS2,
    input [4:0] RD,
    input RegWrite,
    input [31:0] WData,
    output [31:0] RData1,
    output [31:0] RData2
    );
	reg [31:0] __reg [31:1];
	
	integer i;
	/*
	initial begin
		for(i = 0; i < 32; i=i+1) begin
			__reg[i] = 0;
		end
	end */
	always @(posedge Clk) begin
		if (Reset) begin
			for(i = 1; i < 32; i=i+1) begin
				__reg[i] = 0;
			end
	//		__reg[28] = 32'h00001800;
	//		__reg[29] = 32'h00002ffc;
		end
		else
		if (RegWrite & RD != 0) begin
			__reg[RD] = WData;
			$display("$%d <= %h", RD, WData);
		end
	end
	assign RData1 = RS1 == 0 ? 0 : __reg[RS1];
	assign RData2 = RS2 == 0 ? 0 : __reg[RS2];


endmodule
