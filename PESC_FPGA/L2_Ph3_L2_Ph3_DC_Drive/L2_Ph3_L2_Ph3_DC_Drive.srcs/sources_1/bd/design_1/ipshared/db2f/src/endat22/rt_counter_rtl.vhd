--*************************************************************************
--* MAZeT. All rights reserved. This document and all informations        *
--* contained therein is considered confidential and proprietary of MAZeT.*
--*-----------------------------------------------------------------------*
--
--! @file: $RCSfile: rt_counter_rtl.vhd,v $                    
--!
--! project: ${project_name}
--!
--! unit name: rt_counter_rtl
--!
--! @brief: measurement of recovery time of an EnDat transfer
--!         reg. to Specification D1129749-00-A-01
--          "Messung der Recovery Time I (Monozeit)" 
--!
--! @author: woy
--!
--! company name: MAZeT GmbH, Goeschwitzer Strasse 32, D-07745 Jena
--!
--! @date: ${date}
--!
--! @version: ${version}
--!
--
---------------------------------------------------------------------------

library ieee;
library endat22;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use endat22.resource_pkg.BYTE;

--
-- Created: 09.02.2015
-- Author: woy
--
-- ReqID RRTC1
entity RT_COUNTER is
 generic(
         IMPLEMENT_G:     integer:=0;   -- 1 implement, 0 none; ReqID RRTC7
         DATA_WIDTH_G:    integer:=16;  -- data width of internal ressources ReqID RRTC2, multiple of BYTE
         PORT_WIDTH_G:    integer:=32   -- width of local bus interface
        );
    port(
         CLK:       in    std_logic;    -- system clock
         RES_IX:    in    std_logic;    -- asynchr. reset, low active
         RX_I:      in    std_logic;    -- receive data line
         RT_ON_I:   in    std_logic;    -- on/off of tm meauesurement
         INIT_I:    in    std_logic;    -- write enable; ReqID RRTC3
         BE_I:      in    std_logic_vector(DATA_WIDTH_G/BYTE-1 downto 0); -- byte enable;
         RT_INIT_I: in    std_logic_vector(PORT_WIDTH_G-1 downto 0); -- Init Value; ReqID RRTC3
         DEL_CT_I:  in    std_logic_vector(7 downto 0); -- counter of cable delay; ReqID RRTC4
         EC_STATE_I:in    std_logic_vector(5 downto 0); -- state vector of endat fsm; ReqID RRTC4
         MODE_I:    in    std_logic_vector(5 downto 0); -- Mode Command; ReqID RRTC4
         MRS_I:     in    std_logic_vector(7 downto 0); -- MRS  Code; ReqID RRTC4
         RT_DATA_O: out   std_logic_vector(PORT_WIDTH_G-1 downto 0); -- RT Value; ReqID RRTC6
         RT_START_O:out   std_logic;    -- start pulse; ReqID RRTC4
         RT_STOPP_O:out   std_logic     -- stopp pulse; ReqID RRTC5
        );
end entity RT_COUNTER;

architecture RTL of RT_COUNTER is
-- type declaration
-- fsm state type
type fsm_states is (DUMMY, IDLE, ARMED, PAUSE, MEASURE, STOPP);

type reg_t is record
    fsm:    fsm_states;
    count:  std_logic_vector(PORT_WIDTH_G-1 downto 0);
    pause:  std_logic_vector(1 downto 0);
    start:  std_logic;
    stopp:  std_logic;
end record reg_t;

-- signal declaration
--! record to keep process and control data
signal reg_s, next_reg_s: reg_t; -- application ressources

-- constant declaration
constant MC_POS_11_c:  std_logic_vector(MODE_I'range):="001001";
constant MRS_POS2W2_c: std_logic_vector(MRS_I'range) :=X"43";
constant Z25_c:        std_logic_vector(EC_STATE_I'range) :="011001";
constant Z55_c:        std_logic_vector(EC_STATE_I'range) :="110111";
constant EOP_c:        std_logic_vector(reg_s.pause'range):="10"; -- end of pause 
                                                                  -- pause = EOP_c+1 cc

begin 

IMPL_RT: if not (IMPLEMENT_G=0) generate
    -- ********************************************************************
    -- combinatorical process to define the behaviour
    -- ********************************************************************
    app_cmb: process(BE_I, INIT_I, RT_INIT_I, DEL_CT_I, EC_STATE_I, MODE_I, MRS_I, RX_I,
                     RT_ON_I, reg_s)
    variable reg_v: reg_t;
    begin
        -- control processing
        reg_v:=reg_s;
        reg_v.start:='0';
        reg_v.stopp:='0';
        case reg_v.fsm is
            when IDLE =>
                -- ReqID RRTC4
                -- prepare the measurement if the condition is met
                -- mode command = pos1 with memory select
                -- mrs code = send second word of pos2
                -- at start of addendum (eg. parameter request)
                if MODE_I=MC_POS_11_c and MRS_I=MRS_POS2W2_c and
                   EC_STATE_I=Z55_c and RT_ON_I='1' then
                    reg_v.fsm  :=ARMED;
                end if;
            when ARMED =>
                -- ReqID RRTC4
                -- start the measurement if the condition is met
                -- ec_state at tm measurement state
                -- delay considered (delay counter <= 1)
                if DEL_CT_I(DEL_CT_I'high downto 1)=0 and EC_STATE_I=Z25_c then
                    reg_v.fsm  :=PAUSE;
                end if;
                reg_v.pause:=(others=>'0');
            when PAUSE =>
                -- pause for EOP_c cc, to get correct tm value
                -- the cause of the pause 
                if reg_v.pause=EOP_c then
                    reg_v.fsm  :=MEASURE;
                    reg_v.start:='1';
                end if;
                reg_v.pause:=reg_s.pause+1;
            when MEASURE =>
                if RX_I='0' then
                    reg_v.fsm:=STOPP;
                end if;
            when STOPP =>
                reg_v.fsm  := IDLE;
                reg_v.stopp:='1';
            when others =>
                reg_v.fsm := IDLE;
        end case;

        -- data processing
        if INIT_I='1' then
            -- ReqID RRTC2, RRTC3 - set counter with DATA_WIDTH_G-wide value
            for i in BE_I'range loop 
                if BE_I(i) = '1'  then
                    reg_v.count((i+1)*BYTE-1 downto i*BYTE):=
                                         RT_INIT_I((i+1)*BYTE-1 downto i*BYTE);
                end if;
            end loop;
        else
            case reg_v.fsm is
                when MEASURE|STOPP =>
                    -- ReqID RRTC2 - increment DATA_WIDTH_G-wide counter value
                    -- (Note: STOPP is included as the start (change from ARMED to PAUSE)
                    -- delays the counting by 1cc and the duration of STOPP is always 1cc
                    -- and compensates therefore this behaviour)
                    reg_v.count:=reg_s.count + 1;
                    if PORT_WIDTH_G > DATA_WIDTH_G then
                        reg_v.count(PORT_WIDTH_G-1 downto DATA_WIDTH_G):=(others=>'0');
                    end if;
                when others => null;
            end case;
        end if;
        -- 
        next_reg_s<=reg_v;
    end process;
        
    -- ********************************************************************
    -- registered process to keep the controls and data
    -- ********************************************************************
    app_reg: process(CLK,RES_IX)
    begin
    if rising_edge(CLK) then
        reg_s<=next_reg_s;
    end if;
    if RES_IX='0' then
        -- ReqID RRTC2 - reset value
        reg_s.fsm    <=IDLE;
        reg_s.count  <=(others=>'0');
        reg_s.pause  <=(others=>'0');
        reg_s.start  <='0';
        reg_s.stopp  <='0';
    end if;
    end process app_reg;
end generate IMPL_RT;

NOIMPL_RT: if IMPLEMENT_G=0 generate
    reg_s.start<='0';           -- ReqID RRTC7
    reg_s.stopp<='0';           -- ReqID RRTC7
    reg_s.count<=(others=>'0'); -- ReqID RRTC7
end generate NOIMPL_RT;

-- ********************************************************************
-- output assignments
-- ********************************************************************
RT_START_O <= reg_s.start;      -- ReqID RRTC4
RT_STOPP_O <= reg_s.stopp;      -- ReqID RRTC5
RT_DATA_O(reg_s.count'range) <= reg_s.count; -- ReqID RRTC6

end architecture RTL;



--***************************************************************************
-- Revision history
--
-- $Log: rt_counter_rtl.vhd,v $
-- Revision 1.2  2015/10/05 13:38:23  woy
-- correct measurement on/off=f(conf2(22)), introduce add. 3cc wait states to improve accuracy of measurement
--
-- Revision 1.1  2015/05/19 07:31:27  woy
-- initial: module for recovery time measurement acc. to JH specification 1129749_00_A_01_1
--
--
--
--***************************************************************************
