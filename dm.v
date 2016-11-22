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
    output [31:0] Memout
    );
	reg [31:0] ram [1023:0];
	assign Memout = ram[MemAddr[11:2]];
	integer i;
	always @(posedge Clk) begin
	if (reset) begin
		for(i = 0; i <1024; i=i+1) ram[i] <= 0;
	end else
		if (MemWrite) begin
		ram[MemAddr[11:2]] <= Memdata;
		$display("*%h <= %h", MemAddr, Memdata);
		end
	end
endmodule
