`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:55 11/16/2016 
// Design Name: 
// Module Name:    dm 
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
module dm(
    input [31:0] MemAddr,
    input [31:0] Memdata,
    input MemWrite,
    input Clk,
	 input reset,
    output [31:0] Memout,
	 input [1:0] dmCon
    );
	 /*
	wire [3:0] be;
	assign be = dmCon == 0 ? 4'hf :
					dmCon == 1 ? MemAddr[1] ? 4'b1100 : 4'b0011 :
					dmCon == 2 ? MemAddr[1:0] == 0 ? 4'h1 : MemAddr[1:0] == 1 ? 4'h2 : MemAddr[1:0] == 2 ? 4'h4 : 4'h8 :
					0;
		*/
	reg [31:0] ram [2047:0];
	wire [12:2] addr;
	assign addr = MemAddr[12:2];
	assign Memout = ram[addr];
	reg [31:0] memin;
	always @(*)
	case (dmCon)
		0: memin = Memdata;
		1: memin = MemAddr[1] ? {Memdata[15:0],ram[addr][15:0]} : {ram[addr][31:16], Memdata[15:0]};
		2: memin = MemAddr[1:0] == 0? {ram[addr][31:8], Memdata[7:0]} :
					  MemAddr[1:0] == 1? {ram[addr][31:16], Memdata[7:0], ram[addr][7:0]} :
					  MemAddr[1:0] == 2? {ram[addr][31:24], Memdata[7:0], ram[addr][15:0]} :
					  {Memdata[7:0], ram[addr][23:0]};
		3: memin = 0;
	endcase
	
	integer i;
	always @(posedge Clk) begin
	if (reset) begin
		for(i = 0; i <2048; i=i+1) ram[i] <= 0;
	end else
		if (MemWrite) begin
					ram[addr] <= memin;
					case (dmCon)
						0: $display("*%h <= %h", MemAddr, Memdata);
						1: $display("*%h <= %h", MemAddr, Memdata[15:0]);
						2: $display("*%h <= %h", MemAddr, Memdata[7:0]);
						3: $display("error!");
					endcase
		end
	end
endmodule
