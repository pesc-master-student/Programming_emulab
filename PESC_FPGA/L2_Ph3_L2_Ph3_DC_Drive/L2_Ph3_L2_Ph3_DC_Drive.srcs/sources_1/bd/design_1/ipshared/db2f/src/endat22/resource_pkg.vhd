-- contained therein is considered confidential and proprietary of MAZeT.    --
-------------------------------------------------------------------------------
--                                                                           --
-- File:          $RCSfile
--                                                                           --
-- Projekt:       ENDAT                                                      --
--                                                                           --
-- Modul / Unit:  Resource Package                                           --
--                                                                           --
-- Function:      declaration of common data types, addresses                --
--                of ENDAT address space (single transfer resources):        --
--                                                                           --
-- Author:        R. Woyzichovski                                            --
--                MAZeT GmbH                                                 --
--                Goeschwitzer Strasse 32                                    --
--                D-07745 Jena                                               --
--                                                                           --
--                                                                           --
-- Synthesis:        (Tested with Synoplfy H2013.03) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V8.2.1
-------------------------------------------------------------------------------
-- Revision history 
-- History:       F.Seiler 04-12.2008 Initial Version 
--                F.Seiler 11.03.2009 New registers for down sampling
--                F.Seiler 24.09.2009 New enbl for TM
--                F.Seiler 01.03.2010 Korr.SPI 1,2,3
--                FSE      21.01.2016 RTM
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package resource_pkg is
  -----------------------------------------------------------------------------
  -- declaration of application specific attributes
  -----------------------------------------------------------------------------
  attribute PORT_TYP: string;

  -----------------------------------------------------------------------------
  -- declaration of common constants
  -----------------------------------------------------------------------------
  constant BYTE           : integer :=  8; -- the width of byte
  constant WORD           : integer := 16; -- the width of word
  constant DWORD          : integer := 32; -- the width of double word
  constant DATA_WIDTH     : integer := 32; -- the width of internal data
  constant PIF_WIDTH      : integer := 16; -- the data width of the parallel IF data
  constant ADR_WIDTH      : integer :=  6; -- width for address bus of PIO
  constant LOW_ADR_WIDTH  : integer :=  2; -- width for address bus of PIO
                                           -- to decode data bytes

  -----------------------------------------------------------------------------
  -- declaration of common types
  -----------------------------------------------------------------------------
  type INT_ARRAY is array (integer range <>) of integer; 

  -- array types to support register implementation
  type r_array is array(integer range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);

  --===========================================================================
  -- definition of 16 bit CRC generator polynom 0x14EAB
  --===========================================================================
  -- x16 + x15 + x14 + x13 + x12 + x11 + x10 + x9 + x8 + x7 + x6 + x5 + x3 + x2 + 1
  --constant CRC_GEN_POLYNOM: std_logic_vector(((17-1)/4+1)*4-1 downto 0):= X"14EAB";
  constant CRC_GEN_POLYNOM: std_logic_vector(((17-1)/4+1)*4-1 downto 0):= "00010100111010101011";

  -----------------------------------------------------------------------------
  -- declaration of interface-address-constants and control bits
  -----------------------------------------------------------------------------

  --===========================================================================
  -- definition of 32 bit ressource addresses @ segment of the END_SAFE
  --===========================================================================
  -- resourcename_ADR       address(x:2) (hex) remark
  -----------------------------------------------------------------------------
  constant SENDE_ADR      : integer:= 16#00#;                                   --> (6:0) = 16#00#
  -----------------------------------------------------------------------------
  constant EMPF1_ADR      : integer:= 16#01#;			                --> (6:0) = 16#04#
  -----------------------------------------------------------------------------
  constant EMPF1H_ADR     : integer:= 16#02#;   -- high word of 48 bit          --> (6:0) = 16#08#
  -----------------------------------------------------------------------------
  constant EMPF2_ADR      : integer:= 16#03#;				        --> (6:0) = 16#0c#
  -----------------------------------------------------------------------------
  constant EMPF3_ADR      : integer:= 16#04#;			                --> (6:0) = 16#10#
  -----------------------------------------------------------------------------
  constant KONF1_ADR      : integer:= 16#05#;			                --> (6:0) = 16#14#
  -----------------------------------------------------------------------------
  constant KONF2_ADR      : integer:= 16#06#;			                --> (6:0) = 16#18#
  -----------------------------------------------------------------------------
  constant KONF3_ADR      : integer:= 16#07#;			                --> (6:0) = 16#1c#
  -----------------------------------------------------------------------------
  constant STATUS_ADR     : integer:= 16#08#;			                --> (6:0) = 16#20#
  -----------------------------------------------------------------------------
  constant S_INT_EN_ADR   : integer:= 16#09#;			                --> (6:0) = 16#24#
  -----------------------------------------------------------------------------
  constant TEST1_ADR      : integer:= 16#0a#;			                --> (6:0) = 16#28#
  -----------------------------------------------------------------------------
  constant TEST2_ADR      : integer:= 16#0b#;			                --> (6:0) = 16#2c#
  -----------------------------------------------------------------------------
  constant EMPF4_ADR      : integer:= 16#0c#;			                --> (6:0) = 16#30#
  -----------------------------------------------------------------------------
  constant EMPF4H_ADR     : integer:= 16#0d#;   -- high word of 48 bit          --> (6:0) = 16#34#
  -----------------------------------------------------------------------------
  constant STROBE_ADR     : integer:= 16#0e#;					--> (6:0) = 16#38#
  -----------------------------------------------------------------------------
  constant ID_ADR         : integer:= 16#0f#;					--> (6:0) = 16#3c#
  -----------------------------------------------------------------------------
  constant DS1_ADR        : integer:= 16#10#;					--> (6:0) = 16#40#
  -----------------------------------------------------------------------------
  constant DS2_ADR        : integer:= 16#11#;					--> (6:0) = 16#44#
  -----------------------------------------------------------------------------
  constant DS3_ADR        : integer:= 16#12#;					--> (6:0) = 16#48#
  -----------------------------------------------------------------------------
  constant KONF4_ADR      : integer:= 16#13#;					--> (6:0) = 16#4c#
  -----------------------------------------------------------------------------
  constant KONF5_ADR       : integer:= 16#14#;					--> (6:0) = 16#50#
  -----------------------------------------------------------------------------
  constant NPV_ADR        : integer:= 16#15#;					--> (6:0) = 16#54#
  -----------------------------------------------------------------------------
  constant NPV_H_ADR      : integer:= 16#16#;   -- high word of 48 bit          --> (6:0) = 16#58#
  -----------------------------------------------------------------------------
  constant TEST3_ADR      : integer:= 16#17#;					--> (6:0) = 16#5c#
  -----------------------------------------------------------------------------
  constant OFFSET2_ADR    : integer:= 16#18#;					--> (6:0) = 16#60#
  -----------------------------------------------------------------------------
  constant OFFSET2_H_ADR  : integer:= 16#19#;   -- high word of 48 bit          --> (6:0) = 16#64#
  -----------------------------------------------------------------------------
  constant FEHLER_ADR     : integer:= 16#1a#;					--> (6:0) = 16#68#
  -----------------------------------------------------------------------------
  constant F_INT_EN_ADR   : integer:= 16#1b#;					--> (6:0) = 16#6c#
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  constant SRM_ADR        : integer:= 16#1c#;					--> (6:0) = 16#70#
  -----------------------------------------------------------------------------
  constant SRM_H_ADR      : integer:= 16#1d#;					--> (6:0) = 16#74#
  -----------------------------------------------------------------------------
  constant NSRPOS1_ADR    : integer:= 16#1e#;					--> (6:0) = 16#78#
  -----------------------------------------------------------------------------
  constant NSRPOS2_ADR    : integer:= 16#1f#;					--> (6:0) = 16#7c#
  -----------------------------------------------------------------------------
  constant TEST4_ADR      : integer:= 16#20#;                                   --> (7:0) = 16#80#
  -----------------------------------------------------------------------------
  constant TEST4_H_ADR    : integer:= 16#21#;   -- high word of 64 bit          --> (7:0) = 16#84#
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  constant EMPF1S_ADR     : integer:= 16#22#;                                   --> (7:0) = 16#88#
  -----------------------------------------------------------------------------
  constant EMPF1S_H_ADR   : integer:= 16#23#;                                   --> (7:0) = 16#8C#
  -----------------------------------------------------------------------------
  constant EMPF3S_ADR     : integer:= 16#24#;                                   --> (7:0) = 16#90#
  -----------------------------------------------------------------------------
  constant DS4_ADR        : integer:= 16#25#;			                --> (7:0) = 16#94#
  -----------------------------------------------------------------------------
  constant DUM26_ADR      : integer:= 16#26#;                                   --> (7:0) = 16#98#
  -----------------------------------------------------------------------------
  constant DUM27_ADR      : integer:= 16#27#;                                   --> (7:0) = 16#9C#
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  constant OEM1_CNTRL_ADR  : integer:= 16#28#;                                   --> (7:0) = 16#A0#
  -----------------------------------------------------------------------------
  constant OEM1_INTSTAT_ADR: integer:= 16#29#;                                   --> (7:0) = 16#A4#
  -----------------------------------------------------------------------------
  constant OEM1_I_INT_EN_ADR: integer:= 16#2A#;                                  --> (7:0) = 16#A8#
  -----------------------------------------------------------------------------
  constant OEM1_KONF1_ADR  : integer:= 16#2B#;                                   --> (7:0) = 16#AC#
  -----------------------------------------------------------------------------
  constant OEM1_KONF2_ADR  : integer:= 16#2C#;                                   --> (7:0) = 16#B0#
  -----------------------------------------------------------------------------
  constant OEM1_KONF3_ADR   : integer:= 16#2D#;                                  --> (7:0) = 16#B4#
  -----------------------------------------------------------------------------
  constant OEM1_KONF4_ADR   : integer:= 16#2E#;                                  --> (7:0) = 16#B8#
  -----------------------------------------------------------------------------
  constant OEM1_KONF5_ADR   : integer:= 16#2F#;                                  --> (7:0) = 16#BC#
  -----------------------------------------------------------------------------
  constant OEM1_KONF5_H_ADR : integer:= 16#30#;                                  --> (7:0) = 16#C0#
  -----------------------------------------------------------------------------
  constant OEM1_KONF6_ADR   : integer:= 16#31#;                                  --> (7:0) = 16#C4#
  -----------------------------------------------------------------------------
  constant OEM1_STORE_ADR  : integer:= 16#32#;                                   --> (7:0) = 16#B4#
  -----------------------------------------------------------------------------
  constant OEM1_STURN_ADR  : integer:= 16#33#;                                   --> (7:0) = 16#B8#
  -----------------------------------------------------------------------------
  constant OEM1_STURN_H_ADR: integer:= 16#34#;                                   --> (7:0) = 16#BC#
  -----------------------------------------------------------------------------
  constant OEM1_MTURN_ADR  : integer:= 16#35#;                                   --> (7:0) = 16#C0#
  -----------------------------------------------------------------------------
  constant OEM1_POSI2_ADR  : integer:= 16#36#;                                   --> (7:0) = 16#C4#
  -----------------------------------------------------------------------------
  constant OEM1_SOLCT_ADR  : integer:= 16#37#;                                   --> (7:0) = 16#C8#
  -----------------------------------------------------------------------------
  constant OEM1_STATUS_ADR : integer:= 16#38#;                                   --> (7:0) = 16#CC#
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  constant DUM52_ADR      : integer:= 16#34#;                                   --> (7:0) = 16#D0#
  -----------------------------------------------------------------------------
  constant DUM53_ADR      : integer:= 16#35#;                                   --> (7:0) = 16#D4#
  -----------------------------------------------------------------------------
  constant DUM54_ADR      : integer:= 16#36#;                                   --> (7:0) = 16#D8#
  -----------------------------------------------------------------------------
  constant DUM55_ADR      : integer:= 16#37#;                                   --> (7:0) = 16#DC#
  -----------------------------------------------------------------------------
  constant DUM56_ADR      : integer:= 16#38#;                                   --> (7:0) = 16#E0#
  -----------------------------------------------------------------------------
  constant DUM57_ADR      : integer:= 16#39#;                                   --> (7:0) = 16#E4#
  -----------------------------------------------------------------------------
  constant DUM58_ADR      : integer:= 16#3A#;                                   --> (7:0) = 16#E8#
  -----------------------------------------------------------------------------
  constant DUM59_ADR      : integer:= 16#3B#;                                   --> (7:0) = 16#EC#
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  constant MULTIPL_ADR    : integer:= 16#3C#;                                   --> (7:0) = 16#F0#
  -----------------------------------------------------------------------------
  constant SPEED_ADR      : integer:= 16#3D#;			                --> (7:0) = 16#F4#
  -----------------------------------------------------------------------------
  constant SPEED_H_ADR    : integer:= 16#3E#;   -- high word of 64 bit          --> (7:0) = 16#F8#
  -----------------------------------------------------------------------------
  constant DUM3F_ADR      : integer:= 16#3F#;                                   --> (7:0) = 16#FC#
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Ressource Index List
  -----------------------------------------------------------------------------
  constant FIRST_RES      : integer:=  0;
  constant SEND           : integer:=  0;
  constant EMPF1          : integer:=  1;
  constant EMPF1_H        : integer:=  2;
  constant EMPF2          : integer:=  3;
  constant EMPF3          : integer:=  4;
  constant KONF1          : integer:=  5;
  constant KONF2          : integer:=  6;
  constant KONF3          : integer:=  7;
  constant STATUS         : integer:=  8;
  constant S_INT_EN       : integer:=  9;
  constant T1             : integer:= 10;
  constant T2             : integer:= 11;
  constant EMPF4          : integer:= 12;
  constant EMPF4_H        : integer:= 13;
  constant STROBE         : integer:= 14;
  constant ID             : integer:= 15;

  constant DS1            : integer:= 16;
  constant DS2            : integer:= 17;
  constant DS3            : integer:= 18;
  constant KONF4          : integer:= 19;
  constant KONF5           : integer:= 20;
  constant NPV            : integer:= 21;
  constant NPV_H          : integer:= 22;
  constant T3             : integer:= 23;
  constant OFFSET2        : integer:= 24;
  constant OFFSET2_H      : integer:= 25;
  constant FEHLER         : integer:= 26;
  constant F_INT_EN       : integer:= 27;

  constant SR_M           : integer:= 28;
  constant SR_M_H         : integer:= 29;
  constant NSR_POS1       : integer:= 30;
  constant NSR_POS2       : integer:= 31;
  constant T4             : integer:= 32;
  constant T4_H           : integer:= 33;

  constant EMPF1S         : integer:= 34;
  constant EMPF1S_H       : integer:= 35;
  constant EMPF3S         : integer:= 36;
  constant DS4            : integer:= 37;

  constant OEM1_CNTRL     : integer:= 40;
  constant OEM1_INTSTAT   : integer:= 41;
  constant OEM1_I_INT_EN  : integer:= 42;
  constant OEM1_KONF1     : integer:= 43;
  constant OEM1_KONF2     : integer:= 44;
  constant OEM1_KONF3     : integer:= 45;
  constant OEM1_KONF4     : integer:= 46;
  constant OEM1_KONF5     : integer:= 47;
  constant OEM1_KONF5_H   : integer:= 48;
  constant OEM1_KONF6     : integer:= 49;
  constant OEM1_STOR      : integer:= 50;
  constant OEM1_STURN     : integer:= 51;
  constant OEM1_STURN_H   : integer:= 52;
  constant OEM1_MTURN     : integer:= 53;
  constant OEM1_POSI2     : integer:= 54;
  constant OEM1_SOLCT     : integer:= 55;
  constant OEM1_STATUS    : integer:= 56;

  constant DUM57          : integer:= 57;
  constant DUM58          : integer:= 58;
  constant DUM59          : integer:= 59;

  constant MULTIPL        : integer:= 60;
  constant SPEED          : integer:= 61;
  constant SPEED_H        : integer:= 62;
  constant DUM3F          : integer:= 63;

  constant LAST_RES       : integer:= DUM3F;

  -----------------------------------------------------------------------------
  -- index list of addresses of true register resources
  -----------------------------------------------------------------------------
  -- Note: keep order of RESOURCE numbering in mind

  constant resource_addr: int_array(SEND to LAST_RES):= (
                                               SENDE_ADR,
                                               EMPF1_ADR,
                                               EMPF1H_ADR,
                                               EMPF2_ADR,
                                               EMPF3_ADR,
                                               KONF1_ADR,
                                               KONF2_ADR,
                                               KONF3_ADR,
                                               STATUS_ADR,
                                               S_INT_EN_ADR,
                                               TEST1_ADR,
                                               TEST2_ADR,
                                               EMPF4_ADR,
                                               EMPF4H_ADR,
                                               STROBE_ADR,
                                               ID_ADR,

                                               DS1_ADR,
                                               DS2_ADR,
                                               DS3_ADR,
                                               KONF4_ADR,
                                               KONF5_ADR,
                                               NPV_ADR,
                                               NPV_H_ADR,
                                               TEST3_ADR,
                                               OFFSET2_ADR,
                                               OFFSET2_H_ADR,
                                               FEHLER_ADR,
                                               F_INT_EN_ADR,

                                               SRM_ADR,
                                               SRM_H_ADR,
                                               NSRPOS1_ADR,
                                               NSRPOS2_ADR,
                                               TEST4_ADR,
                                               TEST4_H_ADR,

                                               EMPF1S_ADR,
                                               EMPF1S_H_ADR,
                                               EMPF3S_ADR,
                                               DS4_ADR,
                                               DUM26_ADR,
                                               DUM27_ADR,

                                               OEM1_CNTRL_ADR,
                                               OEM1_INTSTAT_ADR,
                                               OEM1_I_INT_EN_ADR,
                                               OEM1_KONF1_ADR,
                                               OEM1_KONF2_ADR,
                                               OEM1_KONF3_ADR,
                                               OEM1_KONF4_ADR,
                                               OEM1_KONF5_ADR,
                                               OEM1_KONF5_H_ADR,
                                               OEM1_KONF6_ADR,
                                               OEM1_STORE_ADR,
                                               OEM1_STURN_ADR,
                                               OEM1_STURN_H_ADR,
                                               OEM1_MTURN_ADR,
                                               OEM1_POSI2_ADR,
                                               OEM1_SOLCT_ADR,
                                               OEM1_STATUS_ADR,

                                               DUM57_ADR,
                                               DUM58_ADR,
                                               DUM59_ADR,

                                               MULTIPL_ADR,
                                               SPEED_ADR,
                                               SPEED_H_ADR,
                                               DUM3F_ADR
                                              );

  -- write bit mask of register resources (defines writable bit at each register)
  constant wr_mask: r_array(resource_addr'range):=(
           SEND        => "00111111111111111111111111111111",
           KONF1       => "11111101111111111111111111110111",
           KONF2       => "11111111011111111111111111111111",
           KONF3       => "00000000000000000000000111111111",
           KONF4       => "11111111111111111111100000011111",
           KONF5       => "11111111000111110011111100111111",
           NPV         => "11111111111111111111111111111111",
           NPV_H       => "00000000000000001111111111111111",
           OFFSET2     => "11111111111111111111111111111111",
           OFFSET2_H   => "00000000000000001111111111111111",
           STATUS      => "10011000000001111111111111111111",
           S_INT_EN    => "10011000000001111111111111111111",
           T2          => "11111111111111111111111110111110",
           FEHLER      => "11111111111110001111110011111011",
           F_INT_EN    => "11111111111110001111110011111011",
           T3          => "11111111111111111111111111111111",

           SR_M        => "11111111111111111111111111111111",
           SR_M_H      => "00000000000000001111111111111111",
           NSR_POS1    => "11111111111111111111111111111111",
           NSR_POS2    => "11111111111111111111111111111111",

           MULTIPL     => "00000000000000001111111111111111",

           OEM1_CNTRL   => X"0000_000f",
         OEM1_I_INT_EN  => X"0000_7f01",
           OEM1_KONF1   => X"0000_003f",
           OEM1_KONF2   => X"0000_007f",
           OEM1_KONF3   => X"0000_0f03",
           OEM1_KONF4   => X"0000_ffff",
           OEM1_KONF5   => X"ffff_ffff",
           OEM1_KONF5_H => X"0000_ffff",
           OEM1_KONF6   => X"0001_ffff",
           
           others      => "00000000000000000000000000000000"
          );


  -- read strobe mask (defines addresses to capture whole data of a resource)
--  constant rd_mask: std_logic_vector(resource_addr'range):=(
--           EMPF1_H => '0',
--           EMPF4_H => '0',
--           others  => '1'
--          );
           

  --===========================================================================
  -- definition of ressource bits of the register resources of the END_SAFE
  -- for a more detailed description of functionality of the bits
  -- -> look at EnDat specification
  -- if other not stated the default value of the ressources is 0

  --===========================================================================
  -- resourcename           bit (dez)      remark (register resource)
  -----------------------------------------------------------------------------
  constant SEND_PAR_LSB  : integer:=  0;   -- SEND
  constant SEND_PAR_MSB  : integer:= 15;   -- SEND
  constant MRS_PORT_LSB  : integer:= 16;   -- SEND
  constant MRS_PORT_MSB  : integer:= 23;   -- SEND
  constant MODE_LSB      : integer:= 24;   -- SEND
  constant MODE_MSB      : integer:= 29;   -- SEND

  constant SENDE_WIDTH     : integer:=30;
  --constant SENDE_DEF_VALUE : std_logic_vector(((SENDE_WIDTH-1)/4+1)*4-1 downto 0):=X"07000000";
  constant SENDE_DEF_VALUE : std_logic_vector(((SENDE_WIDTH-1)/4+1)*4-1 downto 0):=
                                                              "00000111000000000000000000000000";

  -----------------------------------------------------------------------------
  constant POS_LSB       : integer:=  0;   -- EMPF1, EMPF2
  constant POS_MSB       : integer:= 47;   -- EMPF1, EMPF2
  constant DATA_LSB      : integer:=  0;   -- EMPF1, EMPF2, EMPF3
  constant DATA_MSB      : integer:= 15;   -- EMPF1, EMFF2, EMPF3
  constant MRS_LSB       : integer:= 16;   -- EMPF1, EMPF2, EMPF3
  constant MRS_MSB       : integer:= 23;   -- EMPF1, EMPF2, EMPF3
  constant ADR_LSB       : integer:= 16;   -- EMPF1
  constant ADR_MSB       : integer:= 23;   -- EMPF1
  constant PORT_LSB      : integer:= 16;   -- EMPF1
  constant PORT_MSB      : integer:= 23;   -- EMPF1
  constant DV_LSB        : integer:=  0;   -- EMPF1
  constant DV_MSB        : integer:= 39;   -- EMPF1
  constant CRC1_LSB      : integer:= 48;   -- EMPF1
  constant CRC1_MSB      : integer:= 52;   -- EMPF1
  constant FEHL1_EBIT    : integer:= 53;   -- EMPF1
  constant FEHL2_EBIT    : integer:= 54;   -- EMPF1
  constant POS1_BIT      : integer:= 55;   -- EMPF1

  constant EMPF1_WIDTH   : integer:= 56;

  -----------------------------------------------------------------------------
  constant CRC2_LSB      : integer:= 24;   -- EMPF2, EMPF3
  constant CRC2_MSB      : integer:= 28;   -- EMPF2, EMPF3

  constant EMPF2_WIDTH   : integer:= 32;
  constant EMPF3_WIDTH   : integer:= 32;
  constant EMPF1S_WIDTH  : integer:= 48;
  constant EMPF3S_WIDTH  : integer:= 32;

  -----------------------------------------------------------------------------
  constant POS2_LSB      : integer:=  0;   -- EMPF4
  constant POS2_MSB      : integer:= 47;   -- EMPF4
  constant ZI1_Z2_LSB    : integer:=  0;   -- EMPF4
  constant ZI1_Z2_MSB    : integer:= 15;   -- EMPF4
  constant ZI1_Z3_LSB    : integer:= 16;   -- EMPF4
  constant ZI1_Z3_MSB    : integer:= 31;   -- EMPF4
  constant ZI1_Z4_LSB    : integer:= 32;   -- EMPF4
  constant ZI1_Z4_MSB    : integer:= 47;   -- EMPF4

  constant EMPF4_WIDTH   : integer:= 48;

  -----------------------------------------------------------------------------
  constant HW_STRB_EN    : integer:=  0;   -- KONF1
  constant DUE_BIT       : integer:=  1;   -- KONF1
  constant DT_BIT        : integer:=  2;   -- KONF1
  constant TCLK_LSB      : integer:=  4;   -- KONF1
  constant TCLK_MSB      : integer:=  7;   -- KONF1
  constant D_LAENG_LSB   : integer:=  8;   -- KONF1
  constant D_LAENG_MSB   : integer:= 13;   -- KONF1
  constant LAUFZEIT_LSB  : integer:= 16;   -- KONF1
  constant LAUFZEIT_MSB  : integer:= 23;   -- KONF1
  constant LZK_C_BIT     : integer:= 24;   -- KONF1
  constant FSYS_LSB      : integer:= 27;   -- KONF1
  constant FSYS_MSB      : integer:= 28;   -- KONF1
  constant RESET_BIT     : integer:= 29;   -- KONF1
  constant ENDAT_SSI_LSB : integer:= 30;   -- KONF1
  constant ENDAT_SSI_MSB : integer:= 31;   -- KONF1

  constant KONF1_WIDTH   : integer:= 32;
  --constant KONF1_DEF_VALUE : std_logic_vector(KONF1_WIDTH-1 downto 0):=X"00000df0";
  constant KONF1_DEF_VALUE : std_logic_vector(KONF1_WIDTH-1 downto 0):=
                                                  "00000000000000000000110111110000";

  -----------------------------------------------------------------------------
  constant STR_TIME_LSB  : integer:=  0;   -- KONF2
  constant STR_TIME_MSB  : integer:=  7;   -- KONF2
  constant WDG_TIME_LSB  : integer:=  8;   -- KONF2
  constant WDG_TIME_MSB  : integer:= 15;   -- KONF2
  constant T_ST_LSB      : integer:= 16;   -- KONF2
  constant T_ST_MSB      : integer:= 18;   -- KONF2
  constant FILTER_LSB    : integer:= 19;   -- KONF2
  constant FILTER_MSB    : integer:= 21;   -- KONF2
  constant STR_DELAY_LSB : integer:= 24;   -- KONF2
  constant STR_DELAY_MSB : integer:= 31;   -- KONF2

  constant KONF2_WIDTH   : integer:= 32;
  --constant KONF2_DEF_VALUE : std_logic_vector(KONF2_WIDTH-1 downto 0):=X"00040000";
  constant KONF2_DEF_VALUE : std_logic_vector(KONF2_WIDTH-1 downto 0):=
                                                  "00000000000001000000000000000000";

  -----------------------------------------------------------------------------
  constant PARIT_BIT     : integer:=  0;   -- KONF3
  constant FORMAT_BIT    : integer:=  1;   -- KONF3
  constant GR2BIN_BIT    : integer:=  2;   -- KONF3
  constant R_SINGLE_LSB  : integer:=  3;   -- KONF3
  constant R_SINGLE_MSB  : integer:=  7;   -- KONF3
  constant DW_BIT        : integer:=  8;   -- KONF3

  constant KONF3_WIDTH   : integer:= 9;
  --constant KONF3_DEF_VALUE : std_logic_vector(((KONF3_WIDTH-1)/4+1)*4-1 downto 0):=X"06c";
  --constant KONF3_DEF_VALUE : std_logic_vector(  KONF3_WIDTH-1 downto 0)          :=X"06c";
  constant KONF3_DEF_VALUE : std_logic_vector(((KONF3_WIDTH-1)/4+1)*4-1 downto 0):=
                                                                             "000001101100";

  -----------------------------------------------------------------------------

  constant MODE_BIT      : integer:=  0;   -- KONF4
  constant T_CRC_BIT     : integer:=  1;   -- KONF4
  constant T_IDX_BIT     : integer:=  2;   -- KONF4
  constant T_CMP_BIT     : integer:=  3;   -- KONF4
  constant T_WD_BIT      : integer:=  4;   -- KONF4
  constant BITPOS_LSB    : integer:=  8;   -- KONF4
  constant BITPOS_MSB    : integer:= 12;   -- KONF4
  constant TM_BIT        : integer:= 13;   -- KONF4
  constant CRC_INI_LSB   : integer:= 16;   -- KONF4
  constant CRC_INI_MSB   : integer:= 31;   -- KONF4

  constant KONF4_WIDTH   : integer:= 32;

  -----------------------------------------------------------------------------

  constant KONF5_WIDTH    : integer:= 32;

  -----------------------------------------------------------------------------

  constant NPV_WIDTH     : integer:= 48;

  -----------------------------------------------------------------------------

  constant OFFSET2_WIDTH : integer:= 48;

  -----------------------------------------------------------------------------
  constant EMPF1_BIT     : integer:=  0;   -- STATUS, S_INT_EN
  constant FEHL1_SBIT    : integer:=  1;   -- STATUS, S_INT_EN
  constant CRC1_PARI_BIT : integer:=  2;   -- STATUS, S_INT_EN
  constant FTYP1_SBIT    : integer:=  3;   -- STATUS, S_INT_EN
  constant FTYP2_SBIT    : integer:=  4;   -- STATUS, S_INT_EN
  constant MRS_ADR_BIT   : integer:=  5;   -- STATUS, S_INT_EN
  constant IR6X_BIT      : integer:=  6;   -- STATUS, S_INT_EN
  constant IR7X_BIT      : integer:=  7;   -- STATUS, S_INT_EN
  constant EMPF2_BIT     : integer:=  8;   -- STATUS, S_INT_EN
  constant EMPF3_BIT     : integer:=  9;   -- STATUS, S_INT_EN
  constant FEHL2X_SBIT   : integer:= 10;   -- STATUS, S_INT_EN
  constant CRC_ZI1_BIT   : integer:= 11;   -- STATUS, S_INT_EN
  constant CRC_ZI2_BIT   : integer:= 12;   -- STATUS, S_INT_EN
  constant BUSY_BIT      : integer:= 13;   -- STATUS, S_INT_EN
  constant RM_BIT        : integer:= 14;   -- STATUS, S_INT_EN
  constant WRN_BIT       : integer:= 15;   -- STATUS, S_INT_EN
  constant SPIKE_BIT     : integer:= 16;   -- STATUS, S_INT_EN
  constant WDG_BIT       : integer:= 17;   -- STATUS, S_INT_EN
  constant LZK_S_BIT     : integer:= 22;   -- STATUS, S_INT_EN
  constant LZM_BIT       : integer:= 23;   -- STATUS, S_INT_EN
  constant EMPF4_BIT     : integer:= 24;   -- STATUS, S_INT_EN

  constant STATUS_WIDTH  : integer:= 32;
  --constant STATUS_DEF_VALUE : std_logic_vector(STATUS_WIDTH-1 downto 0):=X"00000400";
  constant STATUS_DEF_VALUE : std_logic_vector(STATUS_WIDTH-1 downto 0):=
                                                    "00000000000000000000010000000000";

  constant S_INT_EN_WIDTH  : integer:= 32;

  -----------------------------------------------------------------------------
  constant DL_H_BIT      : integer:=  0;   -- TEST1
  constant STAT_ZI_LSB   : integer:=  1;   -- TEST1
  constant STAT_ZI_MSB   : integer:=  2;   -- TEST1
  constant FSM_LSB       : integer:=  4;   -- TEST1
  constant FSM_MSB       : integer:=  9;   -- TEST1
  constant IC_TEST1_LSB  : integer:= 10;   -- TEST1
  constant IC_TEST1_MSB  : integer:= 31;   -- TEST1

  constant TEST1_WIDTH   : integer:= 32;

  -----------------------------------------------------------------------------
  constant FREE_PROG_BIT : integer:=  1;   -- TEST2
  constant TST_OUT_BIT   : integer:=  2;   -- TEST2
  constant TST_EMPF_BIT  : integer:=  3;   -- TEST2
  constant TESTMX_LSB    : integer:=  4;   -- TEST2
  constant TESTMX_MSB    : integer:=  5;   -- TEST2
  constant IC_TEST_BIT   : integer:=  7;   -- TEST2
  constant WAHL_ZI_LSB   : integer:=  8;   -- TEST2
  constant WAHL_ZI_MSB   : integer:= 10;   -- TEST2
  constant RESERVE_LSB   : integer:= 11;   -- TEST2
  constant RESERVE_MSB   : integer:= 15;   -- TEST2
  constant IC_TEST2_LSB  : integer:= 16;   -- TEST2
  constant IC_TEST2_MSB  : integer:= 31;   -- TEST2

  constant TEST2_WIDTH   : integer:= 32;

  -----------------------------------------------------------------------------
  constant MONOFLOP_LSB  : integer:=  0;   -- TEST3
  constant MONOFLOP_MSB  : integer:=  7;   -- TEST3

  constant TEST3_WIDTH   : integer:= 32;

  -----------------------------------------------------------------------------
  constant ID_WIDTH  : integer:= 32;
  --                                                                 e22 | e6 | Custumer | Custumer Vers.No. | Basic Vers. No.
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260510";          JH 06.01.2009 (APB Standard)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260511";          JH 30.01.2009 (FTyp1-Korr.)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260512";          JH 20.02.2009 (FTyp1-Korr.)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260513";          JH 11.03.2009 (new register for down sampling)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260515";          JH 24.09.2009 (new enbl for TM)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260516";          JH 01.03.2010 (Korr.SPI3)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260517";          JH 25.01.2011 (OEM1)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260518";          SGO 27.01.2011 (Aenderungen an control_saf)
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e2260519";          SGO 16.07.2012 
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e226051A";          FSE 21.01.2016 RTM 
  --constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):=X"e226051B";          RWO 20.11.2018 eclkgen (support up to tcal=50ms)
  constant ID_DEF_VALUE : std_logic_vector(ID_WIDTH-1 downto 0):= "11100010001001100000010100011011";

  -----------------------------------------------------------------------------
  constant FEHL1_FBIT  : integer:=  0;   -- FEHLER, F_INT_EN
  constant FEHL2X_FBIT : integer:=  1;   -- FEHLER, F_INT_EN
  constant FEHL3_FBIT  : integer:=  3;   -- FEHLER, F_INT_EN
  constant FEHL4_FBIT  : integer:=  4;   -- FEHLER, F_INT_EN
  constant WD_FBIT     : integer:=  5;   -- FEHLER, F_INT_EN
  constant CRC1_FBIT   : integer:=  6;   -- FEHLER, F_INT_EN
  constant CRC2_FBIT   : integer:=  7;   -- FEHLER, F_INT_EN
  constant FEHL3X_FBIT : integer:= 11;   -- FEHLER, F_INT_EN
  constant FEHL4X_FBIT : integer:= 12;   -- FEHLER, F_INT_EN
  constant WDX_FBIT    : integer:= 13;   -- FEHLER, F_INT_EN
  constant CRC1X_FBIT  : integer:= 14;   -- FEHLER, F_INT_EN
  constant CRC2X_FBIT  : integer:= 15;   -- FEHLER, F_INT_EN
  constant MF3_FBIT    : integer:= 19;   -- FEHLER, F_INT_EN
  constant MF4_FBIT    : integer:= 20;   -- FEHLER, F_INT_EN
  constant MWD_FBIT    : integer:= 21;   -- FEHLER, F_INT_EN
  constant MRC1_FBIT   : integer:= 22;   -- FEHLER, F_INT_EN
  constant MRC2_FBIT   : integer:= 23;   -- FEHLER, F_INT_EN
  constant FTYP1_FBIT  : integer:= 24;   -- FEHLER, F_INT_EN
  constant FTYP2_FBIT  : integer:= 25;   -- FEHLER, F_INT_EN
  constant FTYP3_FBIT  : integer:= 26;   -- FEHLER, F_INT_EN
  constant F3_2_FBIT   : integer:= 27;   -- FEHLER, F_INT_EN
  constant F3_3_FBIT   : integer:= 28;   -- FEHLER, F_INT_EN
  constant F3_4_FBIT   : integer:= 29;   -- FEHLER, F_INT_EN

  constant FEHLER_WIDTH  : integer:= 32;

  constant F_INT_EN_WIDTH  : integer:= 32;

  -----------------------------------------------------------------------------
  constant CRC_DS_LSB : integer:=  0;   -- DS1, DS2, DS3
  constant CRC_DS_MSB : integer:= 15;   -- DS1, DS2, DS3
  constant AA0_LSB    : integer:= 16;   -- DS1, DS2, DS3
  constant AA3_MSB    : integer:= 19;   -- DS1, DS2, DS3
  constant IDX_LSB    : integer:= 20;   -- DS1, DS2, DS3
  constant IDX_MSB    : integer:= 22;   -- DS1, DS2, DS3
  constant ADDR_LSB   : integer:= 24;   -- DS1, DS2, DS3
  constant ADDR_MSB   : integer:= 30;   -- DS1, DS2, DS3

  constant DS_WIDTH  : integer:= 32;
  --constant DS1_DEF_VALUE : std_logic_vector(((DS_WIDTH-1)/4+1)*4-1 downto 0):=X"00000000";
  constant DS1_DEF_VALUE : std_logic_vector(((DS_WIDTH-1)/4+1)*4-1 downto 0):=
                                                         "00000000000000000000000000000000";

  constant SRM_WIDTH       : integer:= 48;
  constant nSRPOS_WIDTH    : integer:= 32;
  constant TEST4_WIDTH     : integer:= 64;

  constant MULTIPL_WIDTH   : integer:= 16;
  constant SPEED_WIDTH     : integer:= 64;

  constant TM_WIDTH        : integer:=  8;           --  TM time
  constant DIVIDER_WIDTH   : integer:= 48;

  constant OEM1_CNTRL_WIDTH    : integer:=  8;       -- OEM1 Control Register
  constant OEM1_INTSTAT_WIDTH  : integer:= 16;       -- OEM1 Interrupt Status Register
  constant OEM1_I_INT_EN_WIDTH : integer:= 16;       -- OEM1 Interrupt Mask
  constant OEM1_KONF1_WIDTH    : integer:= 24;       -- OEM1 Configuration Register1
  constant OEM1_KONF2_WIDTH    : integer:= 24;       -- OEM1 Configuration Register2
  constant OEM1_KONF3_WIDTH    : integer:= 16;       -- OEM1 Configuration Register3
  constant OEM1_KONF4_WIDTH    : integer:= 16;       -- OEM1 Configuration Register4
  constant OEM1_KONF5_WIDTH    : integer:= 48;       -- OEM1 Configuration Register5
  constant OEM1_KONF6_WIDTH    : integer:= 24;       -- OEM1 Configuration Register6

  constant OEM1_STOR_WIDTH     : integer:= 32;       -- OEM1 Store
  constant OEM1_STURN_WIDTH    : integer:= 48;       -- OEM1 Singleturn
  constant OEM1_MTURN_WIDTH    : integer:= 32;       -- OEM1 Multiturn
  constant OEM1_POSI2_WIDTH    : integer:= 32;       -- OEM1 Position2
  constant OEM1_SOLCT_WIDTH    : integer:= 24;       -- OEM1 Sign of Life (Lebenszeichen) 
  constant OEM1_STATUS_WIDTH   : integer:= 32;       -- OEM1 Status

  -----------------------------------------------------------------------------
  -- declaration of global signals for trace of debug_points
  -- for regression test
  -----------------------------------------------------------------------------

-- synopsys translate_off
--  -- TESTPOINT0 <= ; zugewiesen in ENDAT
  signal ENDAT_TP0        : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- TESTPOINT1 <= ; zugewiesen in Toplevel
  signal ENDAT_TP1        : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- TESTPOINT2 <= ; zugewiesen in Toplevel
  signal ENDAT_TP2        : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- TESTPOINT3 <= ; zugewiesen in Toplevel
  signal ENDAT_TP3        : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- ENDAT_RESX_COPY Kopie des asynchronen Resets aus ENDAT fuer Auswertung
  -- in rtl_vs_gate
  -- ENDAT_RESX_COPY <= RESXN;   zugewiesen in ENDAT Toplevel
  signal ENDAT_RESX_COPY       : std_logic;

  -- copy of output enable for local bus data
  -- need to ctrl behavior of inout signals of local bus ... in RTL_VS_GATE 
  signal ENDAT_DATA_OE_GLOB : std_logic; -- local bus interface of ENDAT
  signal ENDAT_TCLK_GLOB    : std_logic; -- tclock of serial interface of ENDAT
  signal ENDAT_TDAT_GLOB    : std_logic; -- data of serial interface of ENDAT

-- synopsys translate_on


  --**************************************************************************
  -- declaration of functions
  --**************************************************************************

  ------------------------------------------------------------------------
  -- function vec_or builds logical or  bit by bit of std_logic_vector
  ----------------------------------------------------------------------------
  function vec_or (vector: std_logic_vector) return std_logic;

  ------------------------------------------------------------------------
  -- function vec_and builds logical and bit by bit of std_logic_vector
  ----------------------------------------------------------------------------
  function vec_and (vector: std_logic_vector) return std_logic;

end resource_pkg;
