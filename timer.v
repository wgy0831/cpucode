`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:05:12 12/20/2016 
// Design Name: 
// Module Name:    timer 
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
module timer(
    input clk,
    input reset,
    input [3:2] addr,
    input we,
    input [31:0] datai,
    output reg [31:0] datao,
    output irq
    );
	 reg im, enable;
	 reg [2:1] mode;
	 reg [31:0] preset, count;
	 always @(*)
		case(addr)
			0: datao = {28'b0, im, mode, enable};
			1: datao = preset;
			2: datao = count;
			3: datao = 0;
		endcase
	assign irq = mode == 0 && count == 0 && im;
	always @(posedge clk)
		if (reset) begin
			im <= 0;
			enable <= 0;
			mode <= 0;
			preset <= 0;
			count <= 0;
		end else begin
			if (count > 0 && enable) count <= count - 1;
			if (count == 0 && mode == 1) count <= preset;
			if (we)
				case(addr)
					0: begin im <= datai[3]; mode <= datai[2:1]; enable <= datai[0]; end
					1: preset <= datai;
					2: count <= datai;
				endcase
		end

endmodule
