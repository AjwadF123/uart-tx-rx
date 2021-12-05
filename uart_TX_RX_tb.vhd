--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:58:10 12/05/2021
-- Design Name:   
-- Module Name:   D:/XilinxProjects/UART_TX_RX_tb.vhd
-- Project Name:  uart_tx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_TX_RX
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UART_TX_RX_tb IS
END UART_TX_RX_tb;
 
ARCHITECTURE behavior OF UART_TX_RX_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_TX_RX
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         start : IN  std_logic;
         data_in : IN  std_logic_vector(7 downto 0);
         busy_tx : OUT  std_logic;
         data_sent : OUT  std_logic;
         error : OUT  std_logic;
         busy_rx : OUT  std_logic;
         data_valid : OUT  std_logic;
         data_received : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal start : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal busy_tx : std_logic;
   signal data_sent : std_logic;
   signal error : std_logic;
   signal busy_rx : std_logic;
   signal data_valid : std_logic;
   signal data_received : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 2 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_TX_RX PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          data_in => data_in,
          busy_tx => busy_tx,
          data_sent => data_sent,
          error => error,
          busy_rx => busy_rx,
          data_valid => data_valid,
          data_received => data_received
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 10 us;	
		rst <= '0';
		data_in <= "10101010";
      wait for 10 us;
		start <='1';
		wait for 10 us;
		start <= '0';
		
		wait for 2 ms;
		start <= '1';
		data_in <= "11110000";
		wait for 10 us;
		start <='0';
		
		
		wait;
	end process;

END;
