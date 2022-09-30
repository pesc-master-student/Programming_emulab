#include "emulator.h"
#ifndef __linux__
int emulator_CfgInitialize(emulator *InstancePtr, emulator_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->emulator_BaseAddress = ConfigPtr->emulator_BaseAddress;

    InstancePtr->IsReady = 1;
    return XST_SUCCESS;
}
#endif
void emulator_voltage_pu_bit_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 0, Data);
}
int emulator_voltage_pu_bit_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 0);
    return Data;
}
void emulator_ra_write(emulator *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 4, Data);
}
u32 emulator_ra_read(emulator *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 4);
    return Data;
}
void emulator_polepairs_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 8, Data);
}
int emulator_polepairs_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 8);
    return Data;
}
void emulator_kn_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 12, Data);
}
int emulator_kn_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 12);
    return Data;
}
void emulator_current_pu_bit_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 16, Data);
}
int emulator_current_pu_bit_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 16);
    return Data;
}
void emulator_vdc2_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 20, Data);
}
int emulator_vdc2_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 20);
    return Data;
}
void emulator_vdc1_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 24, Data);
}
int emulator_vdc1_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 24);
    return Data;
}
void emulator_ts_la_write(emulator *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 28, Data);
}
u32 emulator_ts_la_read(emulator *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 28);
    return Data;
}
void emulator_ts_tm_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 32, Data);
}
int emulator_ts_tm_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 32);
    return Data;
}
void emulator_ts_tf_write(emulator *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 36, Data);
}
u32 emulator_ts_tf_read(emulator *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 36);
    return Data;
}
void emulator_tl_write(emulator *InstancePtr, int Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    emulator_WriteReg(InstancePtr->emulator_BaseAddress, 40, Data);
}
int emulator_tl_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 40);
    return Data;
}
int emulator_ia_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 44);
    return Data;
}
int emulator_if_x0_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 48);
    return Data;
}
u32 emulator_motor_id_read(emulator *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 52);
    return Data;
}
int emulator_speed_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 56);
    return Data;
}
int emulator_te_read(emulator *InstancePtr) {

    int Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = emulator_ReadReg(InstancePtr->emulator_BaseAddress, 60);
    return Data;
}
