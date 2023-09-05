module clock_divider #(parameter CLKDIV_WIDTH = 8)(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [CLKDIV_WIDTH-1:0] clkdiv,
    output wire clko
);
    reg [CLKDIV_WIDTH-1:0] clkdiv_ctr;
    
    reg clken;

    // Clock Divider
    wire clkdiv_match = (clkdiv_ctr == clkdiv);
    always @(posedge clk or negedge rst_n)
        if(!rst_n)
            clkdiv_ctr <= 'b0;
        else 
            if(clkdiv_match)
                clkdiv_ctr <= 'b0;
            else if(en)
                clkdiv_ctr <= clkdiv_ctr + 'b1;
    always @(posedge clk or negedge rst_n)
        if(!rst_n)
            clken <= 1'b0;
        else
            if(clken) 
                clken <= 1'b0;
            else if(clkdiv_match)
                clken <= 1'b1;

    assign clko = clken;

endmodule

module fifo #(parameter DW=8, AW=4)(
    input     wire            clk,
    input     wire            rst_n,
    input     wire            rd,
    input     wire            wr,
    input     wire [DW-1:0]   w_data,
    output    wire            empty,
    output    wire            full,
    output    wire [DW-1:0]   r_data,
    output    wire [AW-1:0]   level    
);

    localparam  DEPTH = 2**AW;

    //Internal Signal declarations
    reg [DW-1:0]  array_reg [DEPTH-1:0];
    reg [AW-1:0]  w_ptr_reg;
    reg [AW-1:0]  w_ptr_next;
    reg [AW-1:0]  w_ptr_succ;
    reg [AW-1:0]  r_ptr_reg;
    reg [AW-1:0]  r_ptr_next;
    reg [AW-1:0]  r_ptr_succ;

  // Level
    reg [AW-1:0] level_reg;
    reg [AW-1:0] level_next;      
    reg full_reg;
    reg empty_reg;
    reg full_next;
    reg empty_next;
  
  wire w_en;
  

  always @ (posedge clk)
    if(w_en)
    begin
      array_reg[w_ptr_reg] <= w_data;
    end

  assign r_data = array_reg[r_ptr_reg];   

  assign w_en = wr & ~full_reg;           

//State Machine
  always @ (posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      begin
        w_ptr_reg <= 0;
        r_ptr_reg <= 0;
        full_reg <= 1'b0;
        empty_reg <= 1'b1;
        level_reg <= 4'd0;
      end
    else
      begin
        w_ptr_reg <= w_ptr_next;
        r_ptr_reg <= r_ptr_next;
        full_reg <= full_next;
        empty_reg <= empty_next;
        level_reg <= level_next;
      end
  end


//Next State Logic
  always @*
  begin
    w_ptr_succ = w_ptr_reg + 1;
    r_ptr_succ = r_ptr_reg + 1;
    
    w_ptr_next = w_ptr_reg;
    r_ptr_next = r_ptr_reg;
    full_next = full_reg;
    empty_next = empty_reg;
    level_next = level_reg;
    
    case({w_en,rd})
      //2'b00: nop
      2'b01:
        if(~empty_reg)
          begin
            r_ptr_next = r_ptr_succ;
            full_next = 1'b0;
            level_next = level_reg - 1;
            if (r_ptr_succ == w_ptr_reg)
              empty_next = 1'b1;
          end
      2'b10:
        if(~full_reg)
          begin
            w_ptr_next = w_ptr_succ;
            empty_next = 1'b0;
            level_next = level_reg + 1;
            if (w_ptr_succ == r_ptr_reg)
              full_next = 1'b1;
          end
      2'b11:
        begin
          w_ptr_next = w_ptr_succ;
          r_ptr_next = r_ptr_succ;
        end
    endcase
  end

    //Set Full and Empty

  assign full = full_reg;
  assign empty = empty_reg;

  assign level = level_reg;
  
endmodule

module EF_DAC1001_DI #(parameter FIFO_AW = 5) (
    input wire                  clk,
    input wire                  rst_n,
    input wire [9:0]            data,
    input wire [19:0]           clkdiv,
    input wire [FIFO_AW-1:0]    fifo_threshold,
    input wire                  wr,
    input wire                  clk_en,
    input wire                  en,
    output wire                 low,
    output wire                 empty,
    output wire                  EN,
    output wire                 RST,
    output wire                  SELD0,
    output wire                  SELD1,
    output wire                  SELD2,
    output wire                  SELD3,
    output wire                  SELD4,
    output wire                  SELD5,
    output wire                  SELD6,
    output wire                  SELD7,
    output wire                  SELD8,
    output wire                  SELD9    
);
    wire                fifo_wr = wr;
    reg                 fifo_rd;
    wire                fifo_full;
    wire                fifo_empty;
    wire [9:0]          fifo_wdata,
                        fifo_rdata;
    wire [FIFO_AW-1: 0] fifo_level;

    assign    RST = fifo_rd;
    assign    EN = en;
    
    wire    sample_en;

    assign      {SELD9, SELD8, SELD7, SELD6, SELD5, SELD4, SELD3, SELD2, SELD1, SELD0} = fifo_rdata;
    assign      fifo_wdata = data;

    always @(posedge clk or negedge rst_n)
        if(!rst_n)
            fifo_rd <= 1'b0;
        else
            if(fifo_rd)
            fifo_rd <= 1'b0; 
            else if(~fifo_empty & sample_en)
                fifo_rd <= 1'b1;

    // Clock Dividers
    clock_divider #(.CLKDIV_WIDTH(20)) CLKDIV (
        .clk(clk),
        .rst_n(rst_n),
        .en(clk_en & EN),
        .clkdiv(clkdiv),
        .clko(sample_en)
    );

    fifo  #(.DW(10), .AW(FIFO_AW)) DACFIFO (
        .clk(clk),
        .rst_n(rst_n),
        .rd(fifo_rd),
        .wr(fifo_wr),
        .w_data(fifo_wdata),
        .empty(fifo_empty),
        .full(fifo_full),
        .r_data(fifo_rdata),
        .level (fifo_level)
    ); 



    assign empty=   fifo_empty;
    assign low  =   (fifo_level < fifo_threshold);

endmodule
