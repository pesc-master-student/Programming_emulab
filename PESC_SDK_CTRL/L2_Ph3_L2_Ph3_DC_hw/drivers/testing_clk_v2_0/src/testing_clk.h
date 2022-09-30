#ifndef TESTING_CLK__H
#define TESTING_CLK__H
#ifdef __cplusplus
extern "C" {
#endif
/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "testing_clk_hw.h"
/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 testing_clk_BaseAddress;
} testing_clk_Config;
#endif
/**
* The testing_clk driver instance data. The user is required to
* allocate a variable of this type for every testing_clk device in the system.
* A pointer to a variable of this type is then passed to the driver
* API functions.
*/
typedef struct {
    u32 testing_clk_BaseAddress;
    u32 IsReady;
} testing_clk;
/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define testing_clk_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define testing_clk_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define testing_clk_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define testing_clk_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif
/************************** Function Prototypes *****************************/
#ifndef __linux__
int testing_clk_Initialize(testing_clk *InstancePtr, u16 DeviceId);
testing_clk_Config* testing_clk_LookupConfig(u16 DeviceId);
int testing_clk_CfgInitialize(testing_clk *InstancePtr, testing_clk_Config *ConfigPtr);
#else
int testing_clk_Initialize(testing_clk *InstancePtr, const char* InstanceName);
int testing_clk_Release(testing_clk *InstancePtr);
#endif
/**
* Write to add_opa gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add_opa instance to operate on.
* @param	Data is value to be written to gateway add_opa.
*
* @return	None.
*
* @note    .
*
*/
void testing_clk_add_opa_write(testing_clk *InstancePtr, int Data);
/**
* Read from add_opa gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add_opa instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_add_opa_read(testing_clk *InstancePtr);
/**
* Write to add_opb gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add_opb instance to operate on.
* @param	Data is value to be written to gateway add_opb.
*
* @return	None.
*
* @note    .
*
*/
void testing_clk_add_opb_write(testing_clk *InstancePtr, int Data);
/**
* Read from add_opb gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add_opb instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_add_opb_read(testing_clk *InstancePtr);
/**
* Write to sine_selector gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the sine_selector instance to operate on.
* @param	Data is value to be written to gateway sine_selector.
*
* @return	None.
*
* @note    .
*
*/
void testing_clk_sine_selector_write(testing_clk *InstancePtr, u32 Data);
/**
* Read from sine_selector gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the sine_selector instance to operate on.
*
* @return	u32
*
* @note    .
*
*/
u32 testing_clk_sine_selector_read(testing_clk *InstancePtr);
/**
* Write to add2_opa gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add2_opa instance to operate on.
* @param	Data is value to be written to gateway add2_opa.
*
* @return	None.
*
* @note    .
*
*/
void testing_clk_add2_opa_write(testing_clk *InstancePtr, int Data);
/**
* Read from add2_opa gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add2_opa instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_add2_opa_read(testing_clk *InstancePtr);
/**
* Write to add2_opb gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add2_opb instance to operate on.
* @param	Data is value to be written to gateway add2_opb.
*
* @return	None.
*
* @note    .
*
*/
void testing_clk_add2_opb_write(testing_clk *InstancePtr, int Data);
/**
* Read from add2_opb gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add2_opb instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_add2_opb_read(testing_clk *InstancePtr);
/**
* Read from add2_out gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add2_out instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_add2_out_read(testing_clk *InstancePtr);
/**
* Read from sine_axi gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the sine_axi instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_sine_axi_read(testing_clk *InstancePtr);
/**
* Read from counter gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the counter instance to operate on.
*
* @return	u8
*
* @note    .
*
*/
u8 testing_clk_counter_read(testing_clk *InstancePtr);
/**
* Read from sine_axi_muxi gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the sine_axi_muxi instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int testing_clk_sine_axi_muxi_read(testing_clk *InstancePtr);
/**
* Read from add_out gateway of testing_clk. Assignments are LSB-justified.
*
* @param	InstancePtr is the add_out instance to operate on.
*
* @return	u32
*
* @note    .
*
*/
u32 testing_clk_add_out_read(testing_clk *InstancePtr);
#ifdef __cplusplus
}
#endif
#endif
