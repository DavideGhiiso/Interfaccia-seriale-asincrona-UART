library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_GENERATOR_TB is
end PARITY_GENERATOR_TB;

architecture Behavioral of PARITY_GENERATOR_TB is
    component PARITY_GENERATOR is port (
        D:          in  std_logic_vector (0 to 7);
        PG_EVEN:    out std_logic;
        PG_ODD:     out std_logic
    );
    end component;
    signal D: std_logic_vector (0 to 7); 
    signal PG_EVEN, PG_ODD: std_logic;
begin
    UUT: PARITY_GENERATOR port map(
        D, PG_EVEN, PG_ODD
    );
    process begin
        D <= "00110011";
        wait for 1ns;
        D <= "00110001";
        wait for 1ns;
        D <= "00100001";
        wait for 1ns;
        D <= "10101110";
        wait;
    end process;
end Behavioral;
