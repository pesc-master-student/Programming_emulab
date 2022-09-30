------------------------------------------------------------------------------
--switching_event_counter.vhd
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library proc_common_v3_00_a;
--use proc_common_v3_00_a.proc_common_pkg.all;



entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
	 
 	NUMBER_OF_CHANNELS							: integer := 3;
	WIDTH_OUT								: integer := 16; 	-- Bredde på tellersignalet som tas ut. 
	CHANNEL_NR_OUT								: integer := 0;  -- Velger hvilken teller som tas ut på signalutgangen.
	 
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

	 signal_in							: in std_logic_vector (NUMBER_OF_CHANNELS -1 downto 0) := (others=> '0'); -- c & b & a 
--	 signal_ut							: out std_logic_vector (NUMBER_OF_CHANNELS -1 downto 0) := (others=> '0'); -- c & b & a 
	 counter_out							: out std_logic_vector(WIDTH_OUT-1 downto 0);		
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

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is



  --USER signal declarations added here, as needed for user logic

   constant TELLERE_STARTREGNR 					: integer := 0;
	constant NUM_REG 								: integer := TELLERE_STARTREGNR + NUMBER_OF_CHANNELS;	
									

	signal klokke 									: std_logic := '0';  
	signal reset 									: std_logic := '1';  


	type 	tellerarraytype 					is array (NUMBER_OF_CHANNELS-1 downto 0 ) of  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
	signal tellerarray 					: tellerarraytype 	:= (others => (others => '0'));
  
  signal  inn_signal							: std_logic_vector (NUMBER_OF_CHANNELS -1 downto 0) := (others=> '0'); -- c & b & a 
  signal forrige_signal_in				: std_logic_vector (NUMBER_OF_CHANNELS -1 downto 0) := (others=> '0'); 
  
  signal flanke							:  std_logic_vector (NUMBER_OF_CHANNELS -1 downto 0) := (others=> '0'); 
  
  
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
		
		----------------
		
		constant REG_ADDR_WIDTH 		: integer := i_log2(NUM_REG);
		constant REG_ADDR_SHIFT			: integer := i_log2(C_SLV_DWIDTH/8);
		
		constant P_NUM_REG				: integer  := 2 ** REG_ADDR_WIDTH; 
		
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
	

	--====================================================================
	

begin

	assert (C_SLV_AWIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;

 	assert ( NUMBER_OF_CHANNELS >= CHANNEL_NR_OUT)
		report "#### CHANNEL_NR_OUT er storre enn NUMBER_OF_CHANNELS"
		severity failure;


	
	---===========================================================	
	
	
	reg_read_enable <= Bus2IP_RdCE;
	reg_write_enable <= Bus2IP_WrCE;

	 
	reg_wr_addr <= Bus2IP_WrAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);
	
	reg_rd_addr <= Bus2IP_RdAddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);

	reg_wr_index <= conv_integer(unsigned(reg_wr_addr));
	
	reg_rd_index <= conv_integer(unsigned(reg_rd_addr));
	
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

	
 	klokke <= Bus2IP_Clk;
   reset <= '1' when Bus2IP_Resetn = '0' else '0';

 	---===========================================================	
 	-- Kobler opp registre. 


	Ref_array_sammenkobling_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 generate   	
	
		register_array_read(TELLERE_STARTREGNR + kanal)		<= EXT(tellerarray(kanal),C_SLV_DWIDTH);

		
	end generate;	
	---------------------------------------------------------------------------
	--	Flankedetektor
	
	inn_signal <= signal_in;	

	
	flankedetektorprosess: process(klokke)
		begin 
			if klokke 'event and klokke = '1' then 
				if reset = '1' then
					forrige_signal_in	 <= inn_signal;
					flanke <= (others => '0');					
				else 
					flanke <= (others => '0');
					flankedetektor_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 loop  
						if (inn_signal(kanal) = '1') and  (forrige_signal_in(kanal) = '0') then
							flanke(kanal) <= '1';
						end if;
					end loop;	
					forrige_signal_in	 <= inn_signal;
				end if;
			end if;				
		end process;		


	pulstelleprosess : process (klokke,reset)
		begin
			if klokke 'event and klokke = '1' then 
				if reset = '1' then 
					tellerarray <= (others=> (others => '0'));					
				else 
				
					pulsteller_generate : for kanal in 0 to NUMBER_OF_CHANNELS-1 loop  
						if (flanke(kanal) = '1') then
							tellerarray(kanal) <= tellerarray(kanal) +1;
						end if;
					end loop;	
				end if;
			end if;				
	end process;	
	
	-- Tar ut en valgt teller til et utgangssignal. 
	counter_out <= tellerarray(CHANNEL_NR_OUT)(WIDTH_OUT-1 downto 0);	

	---------------------------------------------------------------------------	
end IMP;