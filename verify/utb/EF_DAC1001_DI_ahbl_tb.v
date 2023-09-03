/*
	Copyright 2020 Efabless Corp.

	Author: Mohamed Shalan (mshalan@efabless.com)
	
	Licensed under the Apache License, Version 2.0 (the "License"); 
	you may not use this file except in compliance with the License. 
	You may obtain a copy of the License at:
	http://www.apache.org/licenses/LICENSE-2.0
	Unless required by applicable law or agreed to in writing, software 
	distributed under the License is distributed on an "AS IS" BASIS, 
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the License for the specific language governing permissions and 
	limitations under the License.
*/

`timescale              1ns/1ps

module EF_DAC1001_DI_ahbl_tb;
    wire[3:0]       dio;
    reg            HCLK = 0;
    reg            HRESETn = 0;
    reg            HSEL = 1;
    reg [31:0]     HADDR;
    reg [31:0]     HWDATA;
    reg [1:0]      HTRANS = 0;
    reg            HWRITE = 0;
    reg [2:0]      HSIZE;
    wire           HREADY;
    wire           HREADYOUT;
    wire [31:0]    HRDATA;
    
    wire            irq;
    wire            OUT;
    reg             VL = 0;
    reg             VH = 1;
    
    `include "AHB_tasks.vh"

    EF_DAC1001_DI_ahbl muv (

        .OUT(OUT),
        .VL(VL),
        .VH(VH),
	    .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HWRITE(HWRITE),
        .HREADY(HREADY),
        .HREADYOUT(HREADYOUT),
        .HRDATA(HRDATA),
	    .irq(irq)
    );
    
    // To avoid limitation of syntheizing real wires, we will enforce VH and VL directly
    initial begin
        force muv.inst_to_wrap.DAC_AN.VL=0.0;
        force muv.inst_to_wrap.DAC_AN.VH=2.048;
    end

    initial begin
        $dumpfile("EF_DAC1001_DI_ahbl_tb.vcd");
        $dumpvars;
        #999;
        @(posedge HCLK)
            HRESETn <= 1;
        #100_000 $finish;
    end

    always #25 HCLK = ~HCLK;
    
    localparam[15:0] DATA_REG_ADDR = 16'h0000;
	localparam[15:0] CTRL_REG_ADDR = 16'h0004;
	localparam[15:0] FIFOT_REG_ADDR = 16'h0008;
	localparam[15:0] SAMPCTRL_REG_ADDR = 16'h000c;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;

    initial begin
        @(posedge HRESETn);
        #999;
        
        $display("TB: Configure the DAC controller");
        AHB_WRITE_WORD(SAMPCTRL_REG_ADDR, 32'h0_00010_01);
        AHB_WRITE_WORD(FIFOT_REG_ADDR, 32'h8);

        $display("TB: Write some data to the DAC FIFO");
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h1);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h2);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h3);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h4);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h5);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h6);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h7);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h8);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'h9);
        AHB_WRITE_WORD(DATA_REG_ADDR, 32'hA);

        $display("TB: Enable the DAC controller");
        AHB_WRITE_WORD(CTRL_REG_ADDR, 32'h1);
        
        #10000;
        $finish;
    end

    assign HREADY = HREADYOUT;


endmodule