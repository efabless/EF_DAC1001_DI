
/*
	Copyright 2023 Efabless Corporation

	Author: Ahmed Reda (ahmed.reda@efabless.com)

	This file is auto-generated by wrapper_gen.py

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/


`timescale			1ns/1ns
`default_nettype	none

`define		AHB_BLOCK(name, init)	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) name <= init;
`define		AHB_REG(name, init)		`AHB_BLOCK(name, init) else if(ahbl_we & (last_HADDR==``name``_ADDR)) name <= HWDATA;
`define		AHB_ICR(sz)				`AHB_BLOCK(ICR_REG, sz'b0) else if(ahbl_we & (last_HADDR==ICR_REG_ADDR)) ICR_REG <= HWDATA; else ICR_REG <= sz'd0;

module EF_DAC1001_DI_ahbl (
	output	wire 		OUT,
	input	wire 		VL,
	input	wire 		VH,
	input	wire 		HCLK,
	input	wire 		HRESETn,
	input	wire [31:0]	HADDR,
	input	wire 		HWRITE,
	input	wire [1:0]	HTRANS,
	input	wire 		HREADY,
	input	wire 		HSEL,
	input	wire [2:0]	HSIZE,
	input	wire [31:0]	HWDATA,
	output	wire [31:0]	HRDATA,
	output	wire 		HREADYOUT,
	output	wire 		irq
);
	localparam[15:0] DATA_REG_ADDR = 16'h0000;
	localparam[15:0] CTRL_REG_ADDR = 16'h0004;
	localparam[15:0] FIFOT_REG_ADDR = 16'h0008;
	localparam[15:0] SAMPCTRL_REG_ADDR = 16'h000c;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;

	reg             last_HSEL;
	reg [31:0]      last_HADDR;
	reg             last_HWRITE;
	reg [1:0]       last_HTRANS;

	always@ (posedge HCLK) begin
		if(HREADY) begin
			last_HSEL       <= HSEL;
			last_HADDR      <= HADDR;
			last_HWRITE     <= HWRITE;
			last_HTRANS     <= HTRANS;
		end
	end

	reg	[31:0]	CTRL_REG;
	reg	[4:0]	FIFOT_REG;
	reg	[31:0]	SAMPCTRL_REG;
	reg	[1:0]	RIS_REG;
	reg	[1:0]	ICR_REG;
	reg	[1:0]	IM_REG;

	wire		EN	= CTRL_REG[0:0];
	wire[4:0]	fifo_threshold	= FIFOT_REG[4:0];
	wire		clk_en	= SAMPCTRL_REG[0:0];
	wire[19:0]	clkdiv	= SAMPCTRL_REG[27:8];
	wire		empty;
	wire		_FIFO_EMPTY_FLAG_	= empty;
	wire		low;
	wire		_FIFO_LOW_FLAG_	= low;
	wire[1:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		ahbl_valid	= last_HSEL & last_HTRANS[1];
	wire		ahbl_we	= last_HWRITE & ahbl_valid;
	wire		ahbl_re	= ~last_HWRITE & ahbl_valid;
	wire		_clk_	= HCLK;
	wire		_rst_	= ~HRESETn;
	wire		wr	= (ahbl_we & (last_HADDR==DATA_REG_ADDR));
	wire[9:0]	data	= HWDATA[9:0];

	EF_DAC1001_DI inst_to_wrap (
		.clk(_clk_),
		.rst_n(~_rst_),
		.data(data),
		.clkdiv(clkdiv),
		.fifo_threshold(fifo_threshold),
		.wr(wr),
		.clk_en(clk_en),
		.EN(EN),
		.low(low),
		.empty(empty),
		.VL(VL),
		.VH(VH),
		.OUT(OUT)
	);

	`AHB_REG(CTRL_REG, 0)
	`AHB_REG(FIFOT_REG, 0)
	`AHB_REG(SAMPCTRL_REG, 0)
	`AHB_REG(IM_REG, 0)

	`AHB_ICR(2)

	always @(posedge HCLK or negedge HRESETn)
		if(~HRESETn) RIS_REG <= 32'd0;
		else begin
			if(_FIFO_EMPTY_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_FIFO_LOW_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	HRDATA = 
			(last_HADDR == CTRL_REG_ADDR) ? CTRL_REG :
			(last_HADDR == FIFOT_REG_ADDR) ? FIFOT_REG :
			(last_HADDR == SAMPCTRL_REG_ADDR) ? SAMPCTRL_REG :
			(last_HADDR == RIS_REG_ADDR) ? RIS_REG :
			(last_HADDR == ICR_REG_ADDR) ? ICR_REG :
			(last_HADDR == IM_REG_ADDR) ? IM_REG :
			(last_HADDR == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign HREADYOUT = 1'b1;

endmodule
