#include "testing_clk.h"
#ifndef __linux__
int testing_clk_CfgInitialize(testing_clk *InstancePtr, testing_clk_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->testing_clk_BaseAddress = ConfigPtr->testing_clk_BaseAddress;

    InstancePtr->IsReady = 1;
    return XST_SUCCESS;
}
#endif
void testing_clk_add_opa_write(testing_clk *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    testing_clk_WriteReg(InstancePtr->testing_clk_BaseAddress, 0, Data);
}
int testing_clk_add_opa_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 0);
    return Data;
}
void testing_clk_add_opb_write(testing_clk *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    testing_clk_WriteReg(InstancePtr->testing_clk_BaseAddress, 4, Data);
}
int testing_clk_add_opb_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 4);
    return Data;
}
void testing_clk_sine_selector_write(testing_clk *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    testing_clk_WriteReg(InstancePtr->testing_clk_BaseAddress, 8, Data);
}
u32 testing_clk_sine_selector_read(testing_clk *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 8);
    return Data;
}
void testing_clk_add2_opa_write(testing_clk *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    testing_clk_WriteReg(InstancePtr->testing_clk_BaseAddress, 12, Data);
}
int testing_clk_add2_opa_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 12);
    return Data;
}
void testing_clk_add2_opb_write(testing_clk *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    testing_clk_WriteReg(InstancePtr->testing_clk_BaseAddress, 16, Data);
}
int testing_clk_add2_opb_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 16);
    return Data;
}
int testing_clk_add2_out_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 20);
    return Data;
}
int testing_clk_sine_axi_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 24);
    return Data;
}
u8 testing_clk_counter_read(testing_clk *InstancePtr) {

    u8 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 28);
    return Data;
}
int testing_clk_sine_axi_muxi_read(testing_clk *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 32);
    return Data;
}
u32 testing_clk_add_out_read(testing_clk *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = testing_clk_ReadReg(InstancePtr->testing_clk_BaseAddress, 36);
    return Data;
}
