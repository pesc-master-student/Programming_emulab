#ifndef EMULATOR__H
#define EMULATOR__H
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
#include "emulator_hw.h"
/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 emulator_BaseAddress;
} emulator_Config;
#endif
/**
* The emulator driver instance data. The user is required to
* allocate a variable of this type for every emulator device in the system.
* A pointer to a variable of this type is then passed to the driver
* API functions.
*/
typedef struct {
    u32 emulator_BaseAddress;
    u32 IsReady;
} emulator;
/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define emulator_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define emulator_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define emulator_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define emulator_ReadReg(BaseAddress, RegOffset) \
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
int emulator_Initialize(emulator *InstancePtr, u16 DeviceId);
emulator_Config* emulator_LookupConfig(u16 DeviceId);
int emulator_CfgInitialize(emulator *InstancePtr, emulator_Config *ConfigPtr);
#else
int emulator_Initialize(emulator *InstancePtr, const char* InstanceName);
int emulator_Release(emulator *InstancePtr);
#endif
/**
* Write to voltage_pu_bit gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the voltage_pu_bit instance to operate on.
* @param	Data is value to be written to gateway voltage_pu_bit.
*
* @return	None.
*
* @note    .
*
*/
void emulator_voltage_pu_bit_write(emulator *InstancePtr, int Data);
/**
* Read from voltage_pu_bit gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the voltage_pu_bit instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_voltage_pu_bit_read(emulator *InstancePtr);
/**
* Write to select_load gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the select_load instance to operate on.
* @param	Data is value to be written to gateway select_load.
*
* @return	None.
*
* @note    .
*
*/
void emulator_select_load_write(emulator *InstancePtr, u32 Data);
/**
* Read from select_load gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the select_load instance to operate on.
*
* @return	u32
*
* @note    .
*
*/
u32 emulator_select_load_read(emulator *InstancePtr);
/**
* Write to ra gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ra instance to operate on.
* @param	Data is value to be written to gateway ra.
*
* @return	None.
*
* @note    .
*
*/
void emulator_ra_write(emulator *InstancePtr, int Data);
/**
* Read from ra gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ra instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ra_read(emulator *InstancePtr);
/**
* Write to polepairs gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the polepairs instance to operate on.
* @param	Data is value to be written to gateway polepairs.
*
* @return	None.
*
* @note    .
*
*/
void emulator_polepairs_write(emulator *InstancePtr, int Data);
/**
* Read from polepairs gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the polepairs instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_polepairs_read(emulator *InstancePtr);
/**
* Write to kn gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the kn instance to operate on.
* @param	Data is value to be written to gateway kn.
*
* @return	None.
*
* @note    .
*
*/
void emulator_kn_write(emulator *InstancePtr, int Data);
/**
* Read from kn gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the kn instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_kn_read(emulator *InstancePtr);
/**
* Write to current_pu_bit gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the current_pu_bit instance to operate on.
* @param	Data is value to be written to gateway current_pu_bit.
*
* @return	None.
*
* @note    .
*
*/
void emulator_current_pu_bit_write(emulator *InstancePtr, int Data);
/**
* Read from current_pu_bit gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the current_pu_bit instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_current_pu_bit_read(emulator *InstancePtr);
/**
* Write to vdc2 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the vdc2 instance to operate on.
* @param	Data is value to be written to gateway vdc2.
*
* @return	None.
*
* @note    .
*
*/
void emulator_vdc2_write(emulator *InstancePtr, int Data);
/**
* Read from vdc2 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the vdc2 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_vdc2_read(emulator *InstancePtr);
/**
* Write to vdc1 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the vdc1 instance to operate on.
* @param	Data is value to be written to gateway vdc1.
*
* @return	None.
*
* @note    .
*
*/
void emulator_vdc1_write(emulator *InstancePtr, int Data);
/**
* Read from vdc1 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the vdc1 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_vdc1_read(emulator *InstancePtr);
/**
* Write to ts_la gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ts_la instance to operate on.
* @param	Data is value to be written to gateway ts_la.
*
* @return	None.
*
* @note    .
*
*/
void emulator_ts_la_write(emulator *InstancePtr, int Data);
/**
* Read from ts_la gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ts_la instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ts_la_read(emulator *InstancePtr);
/**
* Write to ts_tm gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ts_tm instance to operate on.
* @param	Data is value to be written to gateway ts_tm.
*
* @return	None.
*
* @note    .
*
*/
void emulator_ts_tm_write(emulator *InstancePtr, int Data);
/**
* Read from ts_tm gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ts_tm instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ts_tm_read(emulator *InstancePtr);
/**
* Write to ts_tf gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ts_tf instance to operate on.
* @param	Data is value to be written to gateway ts_tf.
*
* @return	None.
*
* @note    .
*
*/
void emulator_ts_tf_write(emulator *InstancePtr, int Data);
/**
* Read from ts_tf gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ts_tf instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ts_tf_read(emulator *InstancePtr);
/**
* Write to tl gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the tl instance to operate on.
* @param	Data is value to be written to gateway tl.
*
* @return	None.
*
* @note    .
*
*/
void emulator_tl_write(emulator *InstancePtr, int Data);
/**
* Read from tl gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the tl instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_tl_read(emulator *InstancePtr);
/**
* Read from enable_sig gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the enable_sig instance to operate on.
*
* @return	u8
*
* @note    .
*
*/
u8 emulator_enable_sig_read(emulator *InstancePtr);
/**
* Read from gate_pulses gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the gate_pulses instance to operate on.
*
* @return	u8
*
* @note    .
*
*/
u8 emulator_gate_pulses_read(emulator *InstancePtr);
/**
* Read from ia gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ia instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ia_read(emulator *InstancePtr);
/**
* Read from if_x0 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the if_x0 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_if_x0_read(emulator *InstancePtr);
/**
* Read from lega gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the lega instance to operate on.
*
* @return	u32
*
* @note    .
*
*/
u32 emulator_lega_read(emulator *InstancePtr);
/**
* Read from monitor_dc1_a gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the monitor_dc1_a instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_monitor_dc1_a_read(emulator *InstancePtr);
/**
* Read from motor_id gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the motor_id instance to operate on.
*
* @return	u32
*
* @note    .
*
*/
u32 emulator_motor_id_read(emulator *InstancePtr);
/**
* Read from te gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the te instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_te_read(emulator *InstancePtr);
/**
* Read from ua0 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ua0 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ua0_read(emulator *InstancePtr);
/**
* Read from ua1 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ua1 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ua1_read(emulator *InstancePtr);
/**
* Read from uab0 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the uab0 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_uab0_read(emulator *InstancePtr);
/**
* Read from uab1 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the uab1 instance to operate on.
*
* @return	u32
*
* @note    .
*
*/
u32 emulator_uab1_read(emulator *InstancePtr);
/**
* Read from ub0 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ub0 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ub0_read(emulator *InstancePtr);
/**
* Read from ub1 gateway of emulator. Assignments are LSB-justified.
*
* @param	InstancePtr is the ub1 instance to operate on.
*
* @return	int
*
* @note    .
*
*/
int emulator_ub1_read(emulator *InstancePtr);
#ifdef __cplusplus
}
#endif
#endif
