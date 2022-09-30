/**
* @file emulator_sinit.c
*
* The implementation of the emulator driver's static initialzation
* functionality.
*
* @note
*
* None
*
*/
#ifndef __linux__
#include "xstatus.h"
#include "xparameters.h"
#include "emulator.h"
extern emulator_Config emulator_ConfigTable[];
/**
* Lookup the device configuration based on the unique device ID.  The table
* ConfigTable contains the configuration info for each device in the system.
*
* @param DeviceId is the device identifier to lookup.
*
* @return
*     - A pointer of data type emulator_Config which
*    points to the device configuration if DeviceID is found.
*    - NULL if DeviceID is not found.
*
* @note    None.
*
*/
emulator_Config *emulator_LookupConfig(u16 DeviceId) {
    emulator_Config *ConfigPtr = NULL;
    int Index;
    for (Index = 0; Index < XPAR_EMULATOR_NUM_INSTANCES; Index++) {
        if (emulator_ConfigTable[Index].DeviceId == DeviceId) {
            ConfigPtr = &emulator_ConfigTable[Index];
            break;
        }
    }
    return ConfigPtr;
}
int emulator_Initialize(emulator *InstancePtr, u16 DeviceId) {
    emulator_Config *ConfigPtr;
    Xil_AssertNonvoid(InstancePtr != NULL);
    ConfigPtr = emulator_LookupConfig(DeviceId);
    if (ConfigPtr == NULL) {
        InstancePtr->IsReady = 0;
        return (XST_DEVICE_NOT_FOUND);
    }
    return emulator_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif
