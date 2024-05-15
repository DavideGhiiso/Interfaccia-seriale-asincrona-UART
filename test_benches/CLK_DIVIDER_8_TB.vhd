library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK_DIVIDER_8_TB is
end CLK_DIVIDER_8_TB;

architecture Behavioral of CLK_DIVIDER_8_TB is
    component CLK_DIVIDER_8 is
        port (
            CLK:    in  std_logic;
            RST:    in std_logic;
            CLK_8:  out std_logic
        );
    end component;
        
    signal CLK:    std_logic;
	signal RST:    std_logic;
	signal CLK_8:  std_logic;
	
begin
    -- unit under test
    UUT: CLK_DIVIDER_8 port map (
        CLK => CLK,
        RST => RST,
        CLK_8 => CLK_8
    );
    
    CLK_process :process
		begin
			CLK <= '0';
			wait for 15 ns;
			CLK <= '1';
			wait for 15 ns;
		end process;
    

    GEN: process begin
        RST <= '1';
        wait for 60ns;
        RST <= '0';        
        wait;
    end process;
    
end Behavioral;
