-- contained therein is considered confidential and proprietary of MAZeT.--
---------------------------------------------------------------------------
--                                                                       --
-- File:          $RCSfile
--                                                                       --
-- Projekt:       END_SAFE                                               --
--                                                                       --
-- Modul / Unit:  PIO Package                                            --
--                                                                       --
-- Function:      definition of common functions                         --
--                                                                       --
-- Author:        R. Woyzichovski                                        --
--                MAZeT GmbH                                             --
--                Goeschwitzer Strasse 32                                --
--                D-07745 Jena                                           --
--                                                                       --
--                                                                       --
-- Synthesis:        (Tested with Synoplfy 8.6.2) 
--                              
-- Script:           ENDAT22.prj
--                               
-- Simulation:       Cadence NCVHDL V3.41, V5.1
---------------------------------------------------------------------------
-- Revision history
--
-- $Log
--
---------------------------------------------------------------------------

-- synopsys translate_off
library std;
use std.textio.all;
-- synopsys translate_on
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package body resource_pkg is

  --**************************************************************************
  -- function and procedure definitions
  --**************************************************************************

  function vec_or (vector: std_logic_vector) return std_logic is
  variable result: std_logic;
  begin
  for I in vector'low to vector'high loop
        if I=vector'low then
                result:=vector(I);
        else
                result:=vector(I) or result;
        end if;
  end loop;
  return result;
  end vec_or;

  function vec_and (vector: std_logic_vector) return std_logic is
  variable result: std_logic;
  begin
  for I in vector'low to vector'high loop
        if I=vector'low then
                result:=vector(I);
        else
                result:=vector(I) and result;
        end if;
  end loop;
  return result;
  end vec_and;

end resource_pkg;

