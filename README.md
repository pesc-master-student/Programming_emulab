# Programming Emulator Lab - Electric Motor Drive (DC)
 
Repository for emulator lab in TET4120 Electric Drives Course NTNU. Models a DC machine. Most of the software stack comes as a precompiled static library file. Only the SwLoadEmulator.cpp/.hpp must be changed according to students needs. The group_00 subfolder contains templates for WatchView and Datalogger and a pre-configured Database.

## Purpose
To familiarize students enrolled in course TET4120 with a realistic real-time model of a DC electric motor drive, with a full-fledged firmware and software control system. The system is highly abstracted and simplified from its original design, so that students can focus on selected items of the software. They will learn to edit source code, compile it, build and deploy a release. The system is run on a hardware platform and interract with it using dedicated tools, to control and log system performance. Tuning of regulators is part of the task.

## Cloning
* This repository must be cloned into C:\Programming

## Building
* Launch Xilinx SDK with workspace C:\Programming\PESC_SDK_CTRL
* SDK Project Explorer reveals three project folders:
  * DC_emulator_lab (DC electric drive application)
  * DC_emulator_lab_bsp (board support package)
  * DC_emulator_lab_hw  (FPGA hardware specification)
* Building process is started by 'Save/Save All' or 'Build/Build All'.
* Output artifact is an .elf file which is required when creating a release.

## The DC_emulator_lab contains:
  * Subfolder 'include' with all header files from the original project used to generate the static library. 
  * Subfolder 'lib' includes third-party library from The Switch needed to run the Linux OS on CPU_0 and static library of the electric drives application running on CPU_1
  * Subfolder 'src' is a distilled version of the original application project. Only 'main.cpp', 'SwLoadEmulator.cpp' and 'SwLoadEmulator.hpp' source files in this source folder. These will be compiled and linked together with above mentioned static libraries. The 'main.cpp' must not be edited, while the other two can be edited to model any of the five mechanical loads.
  * Static libraries are used to protect intellectual property.
  
## Hardware Requirements

## Third-party Tools Required
* For the database, WatchView and Datalogger tools, there are some ready to use templates in the 'group_00' folder. These will configure the tools so that students can save time not needing to create their own configurations.
