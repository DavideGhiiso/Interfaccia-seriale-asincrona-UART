library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_TB is
end COUNTER_TB;

architecture arch of COUNTER_TB is    
    component COUNTER is
        port (
            CLK : in  std_logic;
            RST : in std_logic;
            Z   : out std_logic
        );
    end component;
        
    signal CLK: std_logic;
	signal RST: std_logic;
	signal Z  : std_logic;
	
begin
    -- unit under test
    UUT: COUNTER port map (
        CLK => CLK, 
        RST => RST, 
        Z => Z
    );
    
    CLK_process :process
		begin
			CLK <= '0';
			wait for 10 ns;
			CLK <= '1';
			wait for 10 ns;
		end process;
		
    process begin
        RST <= '1';
        wait for 25 ns; -- start to count at 30ns
        RST <= '0';
        wait for 145 ns; -- wait for a cycle = 30 (start of counter's cycle) + 20 * 8 - 25 (from the prev wait)
        RST <= '1';
        wait for 30 ns;
        RST <= '0';
        wait;
    end process;

end arch;
