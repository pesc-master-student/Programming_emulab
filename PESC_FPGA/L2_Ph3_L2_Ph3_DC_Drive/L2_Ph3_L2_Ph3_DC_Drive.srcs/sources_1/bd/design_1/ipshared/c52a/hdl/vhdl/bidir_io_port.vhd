library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bidir_io_port is
	generic (
		SIZE	: integer	:= 1
	   );
	port (
	--	p_tri_io	: inout std_logic_vector(SIZE-1 downto 0);  -- IOPORT 
		
		p_tri_i	: in std_logic_vector(SIZE-1 downto 0);     -- bidirectional io port components
		p_tri_o	: out std_logic_vector(SIZE-1 downto 0);
		p_tri_t	: out std_logic_vector(SIZE-1 downto 0);		-- '1' Input. '0': Output. 

		p_tri_buf_i	: out std_logic_vector(SIZE-1 downto 0);    -- Buffer control . 
		p_tri_buf_o	: in std_logic_vector(SIZE-1 downto 0);
		p_tri_buf_t	: in std_logic_vector(SIZE-1 downto 0)		-- '1' Input. '0': Output. 
			
	);
end bidir_io_port;

architecture arch_imp of bidir_io_port is

begin

    buf_gen :for n in 0 to  SIZE-1 generate
    
    --    p_tri_buf_i(n)	<= p_tri_io(n);
    --    p_tri_io(n) <= p_tri_buf_o(n) when p_tri_buf_t(n) = '0' else 'Z';
      
         p_tri_buf_i(n)	<= p_tri_i(n);
         p_tri_o(n)	<= p_tri_buf_o(n);
         p_tri_t(n)	<= p_tri_buf_t(n);   
    end generate;	

end arch_imp;
