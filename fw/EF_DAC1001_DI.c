#ifndef EF_DAC1001_DI_C
#define EF_DAC1001_DI_C

#include <EF_DAC1001_DI.h>

void EF_DAC1001_DI_setDataReg (uint32_t dac_base, int value) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;
    dac->DATA = value;

}

void EF_DAC1001_DI_setCtrlReg (uint32_t dac_base, int value) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;
    dac->CTRL = value;

}

int EF_DAC1001_DI_getCtrlReg (uint32_t dac_base) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;
   return (dac->CTRL);

}

void EF_DAC1001_DI_setFIFOlevel (uint32_t dac_base, int value) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    dac->FIFOT = value;

}

int EF_DAC1001_DI_getFIFOlevel (uint32_t dac_base) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

   return (dac->FIFOT);

}

void EF_DAC1001_DI_setSampleCtrlReg (uint32_t dac_base, int value) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    dac->SAMPCTRL = value;

}

int EF_DAC1001_DI_getSampleCtrlReg (uint32_t dac_base) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

   return (dac->SAMPCTRL);

}

int EF_DAC1001_DI_getRawStatusReg (uint32_t dac_base) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    return (dac->ris);
}

int EF_DAC1001_DI_getMaskStatusReg (uint32_t dac_base) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    return (dac->mis);
}

void EF_DAC1001_DI_setInterruptMaskReg (uint32_t dac_base, int value) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    dac->im = value;
}

int EF_DAC1001_DI_getInterruptMaskReg (uint32_t dac_base) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    return (dac->im);
}

void EF_DAC1001_DI_setInterruptClearReg (uint32_t dac_base, int value) {

    EF_DAC1001_DI_TYPE* dac = (EF_DAC1001_DI_TYPE*)dac_base;

    dac->icr = value;
}

#endif