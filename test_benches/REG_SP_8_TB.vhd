library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_SP_8_TB is
end REG_SP_8_TB;

architecture Behavioral of REG_SP_8_TB is
    component REG_SP_8 is port (
        CLK:        in  std_logic;
        CE:         in  std_logic;
        RST:        in  std_logic;
        X:          in  std_logic;
        Z:          out std_logic_vector (0 to 7)
    );
    end component;
    signal CLK, CE, RST, X: std_logic;
    signal Z: std_logic_vector (0 to 7);
begin
    UUT: REG_SP_8 port map(
        CLK, CE, RST, X, Z  
    );
    CLK_process :process
		begin
			CLK <= '0';
			wait for 15 ns;
			CLK <= '1';
			wait for 15 ns;
		end process;
    process begin
         X <= '0';
        RST <= '1';
        wait for 28ns;
        RST <= '0';
        CE <= '1';
        X <= '0'; -- sequence: 11101010
        wait for 30ns;
        X <= '1';
        wait for 30ns;
        X <= '0';
        wait for 30ns;
        X <= '1';
        wait for 30ns;
        X <= '0';
        wait for 30ns;
        X <= '1';
        wait for 30ns;
        X <= '1';
        wait for 30ns;
        X <= '1';
        wait for 30ns;
        CE <= '0';
        wait;
    end process;
end Behavioral;
