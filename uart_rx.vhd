----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:37:45 12/05/2021 
-- Design Name: 
-- Module Name:    uart_rx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_rx is
	generic (
	BAUD_RATE: INTEGER := 9600;
	FREQUENCY: INTEGER := 1000000
	);
	port (
	clk: in STD_LOGIC;
	rst: in STD_LOGIC;
	rx: in STD_LOGIC;
	
	error: out STD_LOGIC;
	busy: out STD_LOGIC;
	data_valid: out STD_LOGIC;
	data_received: out STD_LOGIC_VECTOR(7 downto 0)
	
	);


end uart_rx;

architecture Behavioral of uart_rx is
	
	-- BAUD RATE 9600, CLK 1 MHZ
--	CONSTANT FREQUENCY: INTEGER := 1000000;
	CONSTANT CLKS_PER_BIT: INTEGER := FREQUENCY/ BAUD_RATE;
	CONSTANT CLKS_PER_HALF_BIT: INTEGER := (CLKS_PER_BIT/2);
	
	-- SIGNALS
	signal s_busy: STD_LOGIC := '0';
	signal s_data_valid: STD_LOGIC := '0';
	signal samples_collected: STD_LOGIC_VECTOR (1 downto 0);
	signal s_error: STD_LOGIC;
	signal sample_pulse: STD_LOGIC;
	signal s_data_received: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	-- STATES
	type mystates is (idle_rx, startbit_rx, databits_rx, stopbit_rx);
	signal present_state, next_state : mystates;
	
	signal bit_count_present,bit_count_next: unsigned (4 downto 0);
	signal clk_count_present, clk_count_next: POSITIVE;
	
	
	
begin

	-- PRESENT STATE <= NEXT STATE
	process (clk, rst) begin
	
		if (rst = '1' or s_error = '1') then 
			present_state<= idle_rx;
		elsif (rising_edge(clk)) then
			present_state <= next_state;
			clk_count_present <= clk_count_next;
			bit_count_present<= bit_count_next;
		end if;
	
	end process;
	
	
	-- REGISTERS
	process (clk, present_state) begin
		
		clk_count_next <= clk_count_present;
		next_state<= present_state;
		bit_count_next<= bit_count_present;
		
		case (present_state) is
		
			when idle_rx =>
			-- SIGNAL INITIALIZATION
				bit_count_next <= (others => '0');
				clk_count_next <= 1;
				s_busy <= '0';
				s_data_valid <= '0';
				s_data_received <= (others => '0');
				samples_collected <= (others => '0');
				s_error <= '0';
			-- STATE CHANGE
				if (rx ='0') then	
					next_state <= startbit_rx;
				else 
					next_state <= idle_rx;
				end if;
			

			when startbit_rx =>
				
				if (clk_count_present = CLKS_PER_HALF_BIT+1) then
					if (rx = '0') then
						next_state <= databits_rx;
						clk_count_next <= 1;
					else 
						next_state <= idle_rx;
					end if;
				else 
					clk_count_next <= clk_count_present + 1;
					
				end if;
			
			when databits_rx =>
				s_busy <= '1';
				
				if (bit_count_present < "1000") then
					next_state <= databits_rx;
					
					if (clk_count_present < CLKS_PER_BIT +1) then 
					
						clk_count_next <= clk_count_present + 1;
						if (clk_count_present = CLKS_PER_HALF_BIT +2) then
							-- COLLECT A SAMPLE AT START OF NEXT BIT (COUNT AT 53)
							samples_collected(0) <= rx;
						elsif (clk_count_present = CLKS_PER_BIT) then
							-- COLLECT A SAMPLE BEFORE END OF BIT (COUNT AT 103)
							samples_collected(1) <= rx;
						end if;
					else 
					
						samples_collected(1) <= rx;
						-- IF BOTH SAMPLES MATCH, DATA HASN'T CHANGED AND IT IS CORRECT 
						-- WE CAN TAKE MORE SAMPLES AS WELL
						if (samples_collected(0) = samples_collected(1)) then
							clk_count_next <= 1;
							bit_count_next <= bit_count_present +1;
							s_data_received(to_integer(bit_count_present)) <= rx; 
						else 
							s_error <='1';
							
						end if;	
					end if;
				
				else 
					next_state <= stopbit_rx;
				
				end if;
			
			when stopbit_rx =>
				if (clk_count_present =CLKS_PER_BIT+1) then
					next_state <= idle_rx;
					if (rx = '1') then
						s_data_valid <='1';
						clk_count_next <= 1;
						
					else 
						s_data_valid <='0';
						s_error <= '1';
					end if;
						
				else 
					clk_count_next <= clk_count_present + 1;
					next_state <= stopbit_rx;
				end if;
			
			
			when others => 
				
		end case;
	
	end process;
	
	data_valid <= s_data_valid;
	data_received <= s_data_received;
	busy <= s_busy;
	error <= s_error;
	
end Behavioral;


