library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TX_ENABLE_FSM_TB is
end TX_ENABLE_FSM_TB;

architecture Behavioral of TX_ENABLE_FSM_TB is
    component TX_ENABLE_FSM is
    Port (
        START:      in std_logic;
        CTS:        in std_logic;
        CLK:        in std_logic;
        RST:        in std_logic; 
        TX_ENABLE:  out std_logic
    );
    end component;
    signal START, CTS, CLK, RST, TX_EN: std_logic;
begin
    UUT: TX_ENABLE_FSM port map(
        START, CTS, CLK, RST, TX_EN
    );
    CLK_process :process
		begin
			CLK <= '0';
			wait for 15 ns;
			CLK <= '1';
			wait for 15 ns;
		end process;
    process begin
        CTS <= '0';
        RST <= '1';
        wait for 30ns;
        RST <= '0';
        START <= '1';
        wait for 30ns;
        START <= '0';
        wait for 10ns;
        CTS <= '1';
        wait for 40ns;
        CTS <= '0';
        wait for 30ns;
        START <= '1';
        CTS <= '1';
        wait;
    end process;
end Behavioral;
