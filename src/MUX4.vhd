library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4 is
    Port ( 
        X0:     in  std_logic;
        X1:     in  std_logic;
        X2:     in  std_logic;
        X3:     in  std_logic;
        S:      in  std_logic_vector (1 downto 0);
        Z:      out std_logic
    );
end MUX4;

architecture Behavioral of MUX4 is
    begin
        with S select
            Z <=    X0 when "00",
                    X1 when "01",
                    X2 when "10",
                    X3 when "11",
                    '-' when others;
end Behavioral;
