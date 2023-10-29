
/*
	Copyright 2023 Efabless Corporation

	Author: Ahmed Reda (ahmed.reda@efabless.com)

	This file is auto-generated by wrapper_gen.py on 2023-10-26

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





module EF_DAC1001_DI_apb (
	output	wire 		RST,
	output	wire 		EN,
	output	wire 		SELD0,
	output	wire 		SELD1,
	output	wire 		SELD2,
	output	wire 		SELD3,
	output	wire 		SELD4,
	output	wire 		SELD5,
	output	wire 		SELD6,
	output	wire 		SELD7,
	output	wire 		SELD8,
	output	wire 		SELD9,
	input	wire 		PCLK,
	input	wire 		PRESETn,
	input	wire [31:0]	PADDR,
	input	wire 		PWRITE,
	input	wire 		PSEL,
	input	wire 		PENABLE,
	input	wire [31:0]	PWDATA,
	output	wire [31:0]	PRDATA,
	output	wire 		PREADY,
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

	reg	[31:0]	CTRL_REG;
	reg	[4:0]	FIFOT_REG;
	reg	[31:0]	SAMPCTRL_REG;
	reg	[1:0]	RIS_REG;
	reg	[1:0]	ICR_REG;
	reg	[1:0]	IM_REG;

	wire		en	= CTRL_REG[0:0];
	wire[4:0]	fifo_threshold	= FIFOT_REG[4:0];
	wire		clk_en	= SAMPCTRL_REG[0:0];
	wire[19:0]	clkdiv	= SAMPCTRL_REG[27:8];
	wire		empty;
	wire		_FIFO_EMPTY_FLAG_	= empty;
	wire		low;
	wire		_FIFO_LOW_FLAG_	= low;
	wire[1:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		apb_valid	= PSEL & PENABLE;
	wire		apb_we	= PWRITE & apb_valid;
	wire		apb_re	= ~PWRITE & apb_valid;
	wire		_clk_	= PCLK;
	wire		_rst_	= ~PRESETn;
	wire		wr	= (apb_we & (PADDR[15:0]==DATA_REG_ADDR));
	wire[9:0]	data	= PWDATA[9:0];

	EF_DAC1001_DI inst_to_wrap (
		.clk(_clk_),
		.rst_n(~_rst_),
		.data(data),
		.clkdiv(clkdiv),
		.fifo_threshold(fifo_threshold),
		.wr(wr),
		.clk_en(clk_en),
		.en(en),
		.EN(EN),
		.low(low),
		.empty(empty),
		.RST(RST),
		.SELD0(SELD0),
		.SELD1(SELD1),
		.SELD2(SELD2),
		.SELD3(SELD3),
		.SELD4(SELD4),
		.SELD5(SELD5),
		.SELD6(SELD6),
		.SELD7(SELD7),
		.SELD8(SELD8),
		.SELD9 (SELD9 )
	);

	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) CTRL_REG <= 0; else if(apb_we & (PADDR[15:0]==CTRL_REG_ADDR)) CTRL_REG <= PWDATA[32-1:0];
	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) FIFOT_REG <= 0; else if(apb_we & (PADDR[15:0]==FIFOT_REG_ADDR)) FIFOT_REG <= PWDATA[5-1:0];
	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) SAMPCTRL_REG <= 0; else if(apb_we & (PADDR[15:0]==SAMPCTRL_REG_ADDR)) SAMPCTRL_REG <= PWDATA[32-1:0];
	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) IM_REG <= 0; else if(apb_we & (PADDR[15:0]==IM_REG_ADDR)) IM_REG <= PWDATA[2-1:0];

	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) ICR_REG <= 2'b0; else if(apb_we & (PADDR[15:0]==ICR_REG_ADDR)) ICR_REG <= PWDATA[2-1:0]; else ICR_REG <= 2'd0;

	always @(posedge PCLK or negedge PRESETn)
		if(~PRESETn) RIS_REG <= 2'd0;
		else begin
			if(_FIFO_EMPTY_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_FIFO_LOW_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	PRDATA = 
			(PADDR[15:0] == CTRL_REG_ADDR) ? CTRL_REG :
			(PADDR[15:0] == FIFOT_REG_ADDR) ? FIFOT_REG :
			(PADDR[15:0] == SAMPCTRL_REG_ADDR) ? SAMPCTRL_REG :
			(PADDR[15:0] == RIS_REG_ADDR) ? RIS_REG :
			(PADDR[15:0] == ICR_REG_ADDR) ? ICR_REG :
			(PADDR[15:0] == IM_REG_ADDR) ? IM_REG :
			(PADDR[15:0] == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign PREADY = 1'b1;

endmodule
