`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:26 12/20/2016 
// Design Name: 
// Module Name:    cp0 
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
module cp0(
    input [4:0] a1,
    input [31:0] Din,
    input [31:0] PCa4,
   // input [6:2] ExcCode,
    input [5:0] HWInt,
	 input bd,
    input we,
    input EXLClr,
    input clk,
    input reset,
    output IntReq,
    output reg [31:0] EPC,
    output [31:0] Dout
    );
	 reg [6:2] ExcCode;
	 reg [15:10] im, ip;
	 reg exl, ie;
	 reg [31:0] PrID;
	 assign IntReq = (im & HWInt) && !exl && ie;
	 assign Dout = a1 == 12 ? {16'b0, im, 8'b0, exl, ie} : 
						a1 == 13 ? {16'b0, ip, 3'b0, ExcCode, 2'b0} : 
						a1 == 14 ? EPC : 
						a1 == 15 ? PrID : 0;
	 
	 always @(posedge clk)
		if (reset) begin
			im <= 6'h3f;
			exl <= 0;
			ie <= 1;
		end else begin
			if (IntReq) begin
				EPC <= bd ? PCa4-1 : PCa4;
				exl <= 1;
				ip <= HWInt;
				ExcCode <= 0;
			end
			if (EXLClr) exl <= 0;
			if (we)
				case(a1)
					12: begin im <= Din[15:10]; exl <= Din[1]; ie <= Din[0];end//{16'b0, im, 8'b0, exl, ie} <= Din;
					13: begin ip <= Din[15:10]; ExcCode <= Din[6:2]; end
					14: EPC <= Din;
					15: PrID <= Din;
				endcase
		end
			

endmodule
