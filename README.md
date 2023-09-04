# EF_DAC1001
A digital controller with a FIFO and bus wrappers for a 10-Bit Switching Capacitor Array [DAC](https://github.com/efabless/EF_DACSCA1001). 
## Registers
|Register|Offset|Mode|Size|Description|
|--------|-------|----|---|-------|
|DATA|0x0000|W|10|Write to this register to fill the FIFO|
|CTRL|0x0004|RW|1|Control Register<br>```0: Enable```|
|FIFOT|0x0008|RW|5|FIFO level threshold|
|SAMPCTRL|0x0008|RW|5|Sample Control Register<br>```0: Enable the sample timer```<br>```27-8: Sample Clock Divider```|
| IC | 0x0F00 | W |  4|Interrupts Clear Register; write 1 to clear the flag |
| RIS | 0x0F04 | R | 4|Raw Status Register |
| IM | 0x0F08 | RW |  4|Interrupts Masking Register; enable and disables interrupts |
| MIS | 0x0F0C | R |  4|Masked Status Register |

## Interrupt Flags 
The following applies to registers: RIS, MIS, IM and IC.
|bit|flag|
|---|----|
|0| FIFO is Empty |
|1| FIFO level is below the value in the TX FIFO Level Threshold |
