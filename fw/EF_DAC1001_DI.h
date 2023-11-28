#ifndef EF_DAC1001_DI_H
#define EF_DAC1001_DI_H

#include <stdint.h>
#include <EF_DAC1001_DI_regs.h>

void EF_DAC1001_DI_setDataReg (uint32_t dac_base, int value);

void EF_DAC1001_DI_setCtrlReg (uint32_t dac_base, int value);

int EF_DAC1001_DI_getCtrlReg (uint32_t dac_base);

void EF_DAC1001_DI_setFIFOlevel (uint32_t dac_base, int value);

int EF_DAC1001_DI_getFIFOlevel (uint32_t dac_base);

void EF_DAC1001_DI_setSampleCtrlReg (uint32_t dac_base, int value);

int EF_DAC1001_DI_getSampleCtrlReg (uint32_t dac_base);

int EF_DAC1001_DI_getRawStatusReg (uint32_t dac_base);

int EF_DAC1001_DI_getMaskStatusReg (uint32_t dac_base);

void EF_DAC1001_DI_setInterruptMaskReg (uint32_t dac_base, int value);

int EF_DAC1001_DI_getInterruptMaskReg (uint32_t dac_base);

void EF_DAC1001_DI_setInterruptClearReg (uint32_t dac_base, int value);

#endif