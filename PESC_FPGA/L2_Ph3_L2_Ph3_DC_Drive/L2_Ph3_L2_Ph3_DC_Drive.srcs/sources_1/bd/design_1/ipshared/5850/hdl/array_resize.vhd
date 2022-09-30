----------------------------------------------
-- Array resize. 
--
--  Written by: Kjell Ljøkelsøy, Sintef Energy research. 2013. 
-- 
-- Resized individual elements in a bundle of ste_logic vectors.
-- Shifts bits to either top or bottom. 
-- Rescales either as signed or unsigned signals.
--
-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity array_resize is
	generic (
		NUMBER_OF_ELEMENTS	: integer	:= 4;
		WIDTH_IN			: integer	:= 32;
		WIDTH_OUT			: integer	:= 32;
		SHIFT_TO_TOP		: integer	:= 0;	-- 1: shift to top, 0: shift to bottom
		SIGNED_ELEMENT		: integer 	:= 1 	-- 1: signed, 0: unsigned 
		);
	port (
		array_in	: in  std_logic_vector(NUMBER_OF_ELEMENTS * WIDTH_IN -1 downto 0)  := (others => '0');
		array_out	: out std_logic_vector(NUMBER_OF_ELEMENTS * WIDTH_OUT -1 downto 0) := (others => '0')
		);	
end array_resize;

architecture arch_imp of array_resize is

type array_in_type  is array (NUMBER_OF_ELEMENTS-1 downto 0) of std_logic_vector (WIDTH_IN-1 downto 0); 
type array_out_type is array (NUMBER_OF_ELEMENTS-1 downto 0) of std_logic_vector (WIDTH_OUT-1 downto 0); 

signal	in_arr  : 	array_in_type  := (others => (others => '0'));
signal	out_arr : 	array_out_type := (others => (others => '0'));

begin 

element_split_generate :for n in 0 to NUMBER_OF_ELEMENTS-1 generate 
	begin	
		
		array_out(n * WIDTH_OUT+ WIDTH_OUT-1 downto n * WIDTH_OUT)	<= out_arr(n);
		in_arr(n)	<= array_in (n * WIDTH_IN + WIDTH_IN-1 downto n * WIDTH_IN);


		to_top_generate : if SHIFT_TO_TOP = 1 generate
		  
			shrink_top_generate : if  (WIDTH_IN > WIDTH_OUT)  generate
				out_arr(n) <= in_arr(n)(WIDTH_IN-1 downto WIDTH_IN-WIDTH_OUT); 
			end generate;			
			extend_top_generate : if  not (WIDTH_IN > WIDTH_OUT)   generate
				out_arr(n)(WIDTH_OUT-1 downto WIDTH_OUT-WIDTH_IN) <= in_arr(n); 
			end generate;
		end generate;
		
		to_bottom_generate : if not (SHIFT_TO_TOP = 1) generate  
		
		out_arr(n) <= SXT(in_arr(n),WIDTH_OUT) when SIGNED_ELEMENT = 1  
					else  EXT(in_arr(n),WIDTH_OUT);	 				-- NB Cannot use Resize function in numeric_std, as it does strange things with sign extension.
		end generate;
		
	end generate; 

end arch_imp;
