------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair

------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;


entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --	 USER generics added here
	 
	    REGISTER_WIDTH                   : integer              := 32;
	    NUMBER_OF_REGISTERS              : integer              := 4;	
		REG_SIGNED						 : integer              := 0;	  -- 0: unsigned 1 signed				 

		 -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32

    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
	 load									: in	std_logic_vector( NUMBER_OF_REGISTERS-1 downto 0) := (others => '0');	-- Load flags. One load bit per register. '1': Loads selected register with values from register_array_load.
	
	 register_array_write_vec		: out  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Register values. 
	 register_array_read_vec 		: in  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0');  -- Values that the processor reads.
	 register_array_init_vec 		: in  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0'); -- Initial values loaded at reset
	 register_array_load_vec 		: in  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0'); -- Values loaded when load flags are set.
	 register_write_a	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register A. 
	 register_write_b	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register B. 
	 register_write_c	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register C.  
	 register_write_d	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register D. 
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
		Bus2IP_Clk               : in  std_logic;
		Bus2IP_Resetn            : in  std_logic;
		Bus2IP_RdCe               : in std_logic;
		Bus2IP_WrCe               : in std_logic;		
	 	Bus2IP_RdAddr					: in  std_logic_vector(C_SLV_AWIDTH - 1 downto 0);--:= (others => '0');
		Bus2IP_WrAddr				 : in  std_logic_vector(C_SLV_AWIDTH - 1 downto 0) := (others => '0');
		Bus2IP_Data              : in  std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		Bus2IP_BE                : in  std_logic_vector(C_SLV_DWIDTH / 8 - 1 downto 0);
		IP2Bus_Data              : out std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		IP2Bus_RdAck             : out std_logic;
		IP2Bus_WrAck             : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

--	constant BYTE_WITH								: integer  := 8;   
	constant  NUM_REG              : integer              := NUMBER_OF_REGISTERS;	
	  
 ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------

		function i_log2 (x : positive) return integer is   -- Needed to extract size of array index  
			variable i : integer;
				begin
					i := 0;  
					while (2 ** i < x) and i < 512 loop
						i := i + 1;
					end loop;
				return i;
		end function;

		-------------------
		
		constant REG_ADDR_WIDTH 		: integer := i_log2(NUM_REG);
		constant REG_ADDR_SHIFT			: integer := i_log2(C_SLV_DWIDTH/8);
		
		constant P_NUM_REG				: integer  := 2 ** REG_ADDR_WIDTH; 
		
		constant NUMBER_OF_DIRECT_OUTPUTS		: integer  := 4; 
		
		
		signal slv_ip2bus_data   		: std_logic_vector(C_SLV_DWIDTH - 1 downto 0) := (others => '0');
		
		signal reg_read_enable   		: std_logic                               	:= '0';
		signal reg_write_enable  		: std_logic                               	:= '0';
		signal reg_read_enable_dly1  	: std_logic                               	:= '1';
		signal reg_read_ack      		: std_logic                               	:= '0';
		signal reg_write_ack     		: std_logic                               	:= '0';	
		signal reg_wr_addr 					: std_logic_vector(REG_ADDR_WIDTH - 1 downto 0)    := (others => '0');
		signal reg_rd_addr 					: std_logic_vector(REG_ADDR_WIDTH - 1 downto 0)    := (others => '0');
		
		signal reg_wr_index 					: integer range P_NUM_REG-1 downto 0 := 0; 
		signal reg_rd_index 					: integer range P_NUM_REG-1 downto 0 := 0; 
		
		type register_array_type is array (P_NUM_REG - 1 downto 0) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);

		signal register_array_read   	: register_array_type := (others => (others => '0')); -- Values the processor reads from the register. 
		signal register_array_write 	: register_array_type := (others => (others => '0')); -- Values the processor writes from the register. This is the actual register.
		signal register_array_init 	: register_array_type := (others => (others => '0'));	-- Inital values set in register during reset. 
		signal register_array_load 	: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.

	--	signal load 					: std_logic_vector(P_NUM_REG - 1 downto 0)    := (others => '0');
	--
	
		
		type direct_register_write_array_type is array (NUMBER_OF_DIRECT_OUTPUTS - 1 downto 0) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);	
		
		signal direct_register_write_array : direct_register_write_array_type := (others => (others => '0'));
		
		
	--====================================================================	
begin
	
	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;
		
	---===========================================================	
	reg_read_enable <= Bus2IP_RdCE;
	reg_write_enable <= Bus2IP_WrCE;

	 
	reg_wr_addr <= Bus2IP_WrAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);
	
	reg_rd_addr <= Bus2IP_RdAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);

	reg_wr_index <= to_integer(unsigned(reg_wr_addr));
	
	reg_rd_index <= to_integer(unsigned(reg_rd_addr));
	
	----------------------------------------------------------------------------
	-- Register write process. Bytewise write.
	
	Register_array_process : process(Bus2IP_Clk) is
		begin
			if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
				if Bus2IP_Resetn = '0' then
					register_array_write   <= register_array_init;
				else			
					if  reg_write_enable = '1' then
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop					 
							if (Bus2IP_BE(byte_index) = '1')  then						
								register_array_write(reg_wr_index)(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 +7 downto byte_index * 8);
							end if;
						end loop;
					end if;
					 for reg in 0 to NUM_REG-1 loop
						if load(reg) = '1' then	
							register_array_write(reg) <= register_array_load(reg);
						end if;
					end loop;				
				end if;	
			end if;		
		end process;
	
 	-------------
	-- Read.
	
	slv_ip2bus_data <= register_array_read(reg_rd_index) when  reg_read_enable = '1' else (others => '0');
	reg_read_ack     <= reg_read_enable;

	reg_write_ack 	<= reg_write_enable;
	 
	IP2Bus_Data <= slv_ip2bus_data;
	
	IP2Bus_WrAck <= reg_write_ack;
	IP2Bus_RdAck <= reg_read_ack;
 	
--=============================================================================

	
	Reg_generate : for n in 0 to NUM_REG -1 generate 
		Reg_signed_generate : if  REG_SIGNED = 1 generate
		
			register_array_write_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= std_logic_vector(resize(signed(register_array_write(n)),REGISTER_WIDTH));
			
			register_array_read(n) <= std_logic_vector(resize(signed(register_array_read_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_SLV_DWIDTH));
			register_array_init(n) <= std_logic_vector(resize(signed(register_array_init_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_SLV_DWIDTH));
			register_array_load(n) <= std_logic_vector(resize(signed(register_array_load_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_SLV_DWIDTH));
			
		end generate;	
		

	
		Reg_unsigned_generate : if  not (REG_SIGNED = 1) generate
		
			register_array_write_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= std_logic_vector(resize(unsigned(register_array_write(n)),REGISTER_WIDTH));
			
			register_array_read(n) <= std_logic_vector(resize(unsigned(register_array_read_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_SLV_DWIDTH));
			register_array_init(n) <= std_logic_vector(resize(unsigned(register_array_init_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_SLV_DWIDTH));
			register_array_load(n) <= std_logic_vector(resize(unsigned(register_array_load_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_SLV_DWIDTH));
			
		end generate;
		
		-- Intermediate step, assigning values to direct oputput signals.
		
		Direct_output_generate : if n < NUMBER_OF_DIRECT_OUTPUTS generate
			direct_register_write_array(n) <= register_array_write(n);
		end generate;
		
	end generate;
	
	-- Wrting to direct register output signals. 
	
	register_write_a <= direct_register_write_array(0)(REGISTER_WIDTH-1 downto 0);
	register_write_b <= direct_register_write_array(1)(REGISTER_WIDTH-1 downto 0);
	register_write_c <= direct_register_write_array(2)(REGISTER_WIDTH-1 downto 0);
	register_write_d <= direct_register_write_array(3)(REGISTER_WIDTH-1 downto 0);
	
end IMP;
