----------------------------------------------------------------------------------
-- Company: Power Electronic Systems and Components (PESC) - NTNU
-- Engineer: Thomas Haugan # thomas.haugan@ntnu.no
-- Create Date: 05/25/2020 10:38:48 AM
-- Design Name: 
-- Module Name: multiplexer - user_logic
-- Project Name: 
-- Target Devices: Zynq 7000
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplexer is
    Port ( ADC_1 : out STD_LOGIC_VECTOR (51 downto 0);
           ADC_2 : out STD_LOGIC_VECTOR (51 downto 0);
           Driver_Enable_1_o : out STD_LOGIC;
           Driver_Enable_1_i : in STD_LOGIC;
           Driver_Enable_2_o : out STD_LOGIC;
           Driver_Enable_2_i : in STD_LOGIC;
           GND : in STD_LOGIC;
           adc_conv : in STD_LOGIC_VECTOR (103 downto 0);
           emulator_out : in STD_LOGIC_VECTOR (103 downto 0);
           mux_select : in STD_LOGIC );
end multiplexer;

architecture user_logic of multiplexer is

begin
    ADC_1 <= adc_conv(51 downto 0) WHEN mux_select = '1' ELSE emulator_out(51 downto 0);
    ADC_2 <= adc_conv(103 downto 52) WHEN mux_select = '1' ELSE emulator_out(103 downto 52);
    Driver_Enable_1_o <= Driver_Enable_1_i WHEN mux_select = '1' ELSE GND;
    Driver_Enable_2_o <= Driver_Enable_2_i WHEN mux_select = '1' ELSE GND;

end user_logic;
