library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_GENERATOR_TB is
end PARITY_GENERATOR_TB;

architecture Behavioral of PARITY_GENERATOR_TB is
    component PARITY_GENERATOR is port (
        D:          in  std_logic_vector (0 to 7);
        ODD:        in std_logic;
        PG_OUT:     out std_logic
    );
    end component;
    signal D: std_logic_vector (0 to 7); 
    signal ODD, PG_OUT: std_logic;
begin
    UUT: PARITY_GENERATOR port map(
        D, ODD, PG_OUT
    );
    process begin
        D <= "00110011";
        ODD <= '0';
        wait for 1ns;
        D <= "00110011";
        ODD <= '1';
        wait for 1ns;
        D <= "10101110";
        ODD <= '0';
        wait for 1ns;
        D <= "10101110";
        ODD <= '1';
        wait;
    end process;
end Behavioral;
