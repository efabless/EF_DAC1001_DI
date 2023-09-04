module EF_DACSCA1001 (
    input wire  VDD,
    input wire  VSS,
    input wire  DVDD,
    input wire  DVSS,
    input wire  EN,
    input wire  RST,
    input wire  SELD0,
    input wire  SELD1,
    input wire  SELD2,
    input wire  SELD3,
    input wire  SELD4,
    input wire  SELD5,
    input wire  SELD6,
    input wire  SELD7,
    input wire  SELD8,
    input wire  SELD9,
    input real  VL,
    input real  VH,
    output real OUT
);

    real    value;
    wire real    num = {SELD9, SELD8, SELD7, SELD6, SELD5, SELD4, SELD3, SELD2, SELD1, SELD0};
    wire #10 rst = RST;
    always @(negedge rst)
        value <= num;

    //assign      OUT = (VDD & DVDD & ~VSS & ~DVSS & EN)  ?   (VH-VL)/1024.0*value    :   0.0 ;
    assign      OUT = (EN)  ?   (VH-VL)/1024.0*value    :   0.0 ;

endmodule