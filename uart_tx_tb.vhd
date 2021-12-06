--------------------------------------------------------------------------------

-- Create Date:   11:13:58 12/04/2021
-- Project Name:  uart_tx
-- Target Device:  
-- Tool versions:  
-- Description:   

--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY uart_tx_tb IS
END uart_tx_tb;
 
ARCHITECTURE behavior OF uart_tx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_tx
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         start : IN  std_logic;
         data_in : IN  std_logic_vector(7 downto 0);
         busy : OUT  std_logic;
         data_tx : OUT  std_logic;
         data_sent : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
	signal clk: std_logic := '0';
   signal rst : std_logic := '0';
   signal start : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal busy : std_logic;
   signal data_tx : std_logic;
   signal data_sent : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_tx PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          data_in => data_in,
          busy => busy,
          data_tx => data_tx,
          data_sent => data_sent
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
      wait for 100 ns;	
		rst <= '0';
		data_in <= "10101010";
      wait for clk_period*10;
		start <='1';
		wait for clk_period * 10;
		start <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
