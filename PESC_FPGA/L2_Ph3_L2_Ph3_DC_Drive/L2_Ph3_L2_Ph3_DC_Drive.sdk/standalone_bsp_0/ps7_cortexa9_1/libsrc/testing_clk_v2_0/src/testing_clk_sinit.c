/**
* @file testing_clk_sinit.c
*
* The implementation of the testing_clk driver's static initialzation
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
#include "testing_clk.h"
extern testing_clk_Config testing_clk_ConfigTable[];
/**
* Lookup the device configuration based on the unique device ID.  The table
* ConfigTable contains the configuration info for each device in the system.
*
* @param DeviceId is the device identifier to lookup.
*
* @return
*     - A pointer of data type testing_clk_Config which
*    points to the device configuration if DeviceID is found.
*    - NULL if DeviceID is not found.
*
* @note    None.
*
*/
testing_clk_Config *testing_clk_LookupConfig(u16 DeviceId) {
    testing_clk_Config *ConfigPtr = NULL;
    int Index;
    for (Index = 0; Index < XPAR_TESTING_CLK_NUM_INSTANCES; Index++) {
        if (testing_clk_ConfigTable[Index].DeviceId == DeviceId) {
            ConfigPtr = &testing_clk_ConfigTable[Index];
            break;
        }
    }
    return ConfigPtr;
}
int testing_clk_Initialize(testing_clk *InstancePtr, u16 DeviceId) {
    testing_clk_Config *ConfigPtr;
    Xil_AssertNonvoid(InstancePtr != NULL);
    ConfigPtr = testing_clk_LookupConfig(DeviceId);
    if (ConfigPtr == NULL) {
        InstancePtr->IsReady = 0;
        return (XST_DEVICE_NOT_FOUND);
    }
    return testing_clk_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif
