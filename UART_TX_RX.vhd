----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:30:59 12/05/2021 
-- Design Name: 
-- Module Name:    UART_TX_RX - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_TX_RX is

	port 
	(
	-- TX UART 
	clk: in STD_LOGIC;
	rst: in STD_LOGIC;
	start: in STD_LOGIC;
	data_in: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	busy_tx: out STD_LOGIC;
	data_sent: out STD_LOGIC;
	
	
	-- RX UART
		
	error: out STD_LOGIC;
	busy_rx: out STD_LOGIC;
	data_valid: out STD_LOGIC;
	data_received: out STD_LOGIC_VECTOR(7 downto 0)
	
	);


end UART_TX_RX;

architecture Behavioral of UART_TX_RX is

	
	----------------------------------------- TX COMPONENT
	component uart_tx is
	generic (BAUD_RATE: INTEGER:= 115200;
			FREQUENCY: INTEGER := 2000000);
		port (
	clk: in STD_LOGIC;
	rst: in STD_LOGIC;
	start: in STD_LOGIC;
	data_in: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	busy: out STD_LOGIC;
	data_tx: out STD_LOGIC;
	data_sent: out STD_LOGIC
	
	);
	end component;
	
	
	------------------------------------------ RX COMPONENT
	component uart_rx is
	generic (BAUD_RATE: INTEGER:= 115200;
			FREQUENCY: INTEGER := 2000000);
		port (
	clk: in STD_LOGIC;
	rst: in STD_LOGIC;
	rx: in STD_LOGIC;
	
	error: out STD_LOGIC;
	busy: out STD_LOGIC;
	data_valid: out STD_LOGIC;
	data_received: out STD_LOGIC_VECTOR(7 downto 0)
	
	);
	end component;
	
	signal s_tx_to_rx: STD_LOGIC;
	
	

begin

	TX_UNIT: uart_tx
		
	port map 
	(
	clk=> clk,
	rst=> rst,
	start => start,
	data_in => data_in,
	
	busy=> busy_tx,
	data_tx =>s_tx_to_rx,
	data_sent => data_sent
	
	);
	
	RX_UNIT: uart_rx
	
	port map (
	clk=> clk,
	rst=> rst,
	rx => s_tx_to_rx,
	error => error,
	busy => busy_rx,
	data_valid => data_valid,
	data_received => data_received
	
	);

	
end Behavioral;

