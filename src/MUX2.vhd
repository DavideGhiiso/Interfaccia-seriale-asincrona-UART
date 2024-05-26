library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
    Port ( 
        X :     in STD_LOGIC;
        Y :     in STD_LOGIC;
        S :     in STD_LOGIC;
        Z :     out STD_LOGIC
    );
end MUX2;

architecture Behavioral of MUX2 is

begin
    z <= (x and (not S)) or (y and S);
end Behavioral;
