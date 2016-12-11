`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:55:54 12/11/2016 
// Design Name: 
// Module Name:    muldivpart 
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
module muldivpart(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] Control,
    output [31:0] HI,
    output [31:0] LO,
    output busy,
    input used,
	 input reset,
	 input clk
    );
	reg [63:0] result;
	reg [3:0] state;
	assign HI = result[63:32];
	assign LO = result[31:0];
	assign busy = state > 0;
	always @(posedge clk) begin
		if (reset) begin
			result <= 0;
			state <= 0;
		end
		else if (used) begin
			case (Control)
				2: begin state <= 5; result <= SrcA * SrcB; end
				1: begin state <= 5; result <= $signed(SrcA) * $signed(SrcB); end
				4: begin state <= 10; result <= {SrcA % SrcB, SrcA / SrcB};end
				3: begin state <= 10; result <= {$signed(SrcA) % $signed(SrcB), $signed(SrcA) / $signed(SrcB)}; end
				5: result <= {SrcA, result[31:0]};
				6: result <= {result[63:32], SrcA};
				default: result <= result;
			endcase
		end
		else if (state > 0) state <= state - 1'b1;
	end
endmodule
