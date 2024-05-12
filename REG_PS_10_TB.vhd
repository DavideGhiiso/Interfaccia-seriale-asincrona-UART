library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PS_10_TB is
end REG_PS_10_TB;

architecture Behavioral of REG_PS_10_TB is
    component REG_PS_10 is
        port (
            CLK:        in  std_logic;
            START:      in std_logic;
            TX_ENABLE:  in std_logic;
            RST:        in  std_logic;
            X:          in  std_logic_vector (0 to 7);
            Z:          out std_logic
        );
    end component;
    signal CLK, START, TX_ENABLE, RST, Z: std_logic;
    signal X: std_logic_vector (0 to 7);
begin
    UUT: REG_PS_10 port map (
        CLK, START, TX_ENABLE, RST, X, Z
    );
    CLK_process :process
		begin
			CLK <= '0';
			wait for 15 ns;
			CLK <= '1';
			wait for 15 ns;
		end process;
    process begin
        START <= '0';
        TX_ENABLE <= '0';
        X <= "00000000";
        RST <= '1';
        wait for 30ns;
        RST <= '0';
        X <= "00000001";
        wait for 5ns;
        START <= '1';
        wait for 15ns;
        START <= '0';
        wait for 15ns;
        TX_ENABLE <= '1';
        wait for 300ns;
        TX_ENABLE <= '0';
        wait;
    end process;
end Behavioral;
