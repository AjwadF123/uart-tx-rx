----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:06:31 12/04/2021 
-- Design Name: 
-- Module Name:    uart_tx - Behavioral 
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

entity uart_tx is
	generic (
	BAUD_RATE: INTEGER := 9600;
	FREQUENCY: INTEGER := 1000000
	);
	
	port (
	clk: in STD_LOGIC;
	rst: in STD_LOGIC;
	start: in STD_LOGIC;
	data_in: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	busy: out STD_LOGIC;
	data_tx: out STD_LOGIC;
	data_sent: out STD_LOGIC
	
	);


end uart_tx;

architecture Behavioral of uart_tx is
	
	-- BAUD RATE 9600, CLK 1 MHZ
	CONSTANT CLKS_PER_BIT: NATURAL := FREQUENCY / BAUD_RATE;
	
	signal clk_count_present, clk_count_next: POSITIVE;
	signal sample_pulse: STD_LOGIC;
	signal s_data_in: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	-- STATES
	
	type mystates is (idle, startbit, databits, stopbit);
	signal present_state, next_state : mystates;
	signal bit_count_present,bit_count_next: unsigned (4 downto 0);
	signal s_data_tx: STD_LOGIC;
	signal s_busy: STD_LOGIC := '0';
	signal s_data_sent: STD_LOGIC := '0';

begin

	-- PRESENT STATE <= NEXT STATE
	process (clk, rst) begin
	
		if (rst = '1') then 
			present_state<= idle;
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
		
			when idle =>
				bit_count_next <= (others => '0');
				--clk_count_next <= (others => '0');
				clk_count_next <= 1;
				s_busy <= '0';
				s_data_tx <='1';
				s_data_sent <= '0';
				if (start ='1') then
					next_state <= startbit;
					s_data_in <= data_in;
				else 
					next_state <= idle;
				end if;
			

			when startbit =>
				s_busy <= '1';
				if (clk_count_present = CLKS_PER_BIT+1) then
					next_state <= databits;
					clk_count_next <= 1;
				else 
					clk_count_next <= clk_count_present + 1;
					s_data_tx <= '0';
				end if;
			
			when databits =>
				
				if (bit_count_present < "1000") then
					next_state <= databits;
					if (clk_count_present < CLKS_PER_BIT+1) then
						s_data_tx <= s_data_in(to_integer(bit_count_present));
						clk_count_next <= clk_count_present + 1;
					elsif (clk_count_present = CLKS_PER_BIT+1) then
						clk_count_next <= 1;
						bit_count_next <= bit_count_present +1;
						
					end if;
				
				else 
					next_state <= stopbit;
				
				end if;
			
			when stopbit =>
				if (clk_count_present = CLKS_PER_BIT+1) then
					next_state <= idle;
					clk_count_next <= 1;
					s_data_sent <= '1';
				else 
					clk_count_next <= clk_count_present + 1;
					s_data_tx <= '1';
				end if;
			
			
			when others => 
				
		end case;
	
	end process;

	data_tx <= s_data_tx;
	busy <= s_busy;
	data_sent <= s_data_sent;
	
end Behavioral;

