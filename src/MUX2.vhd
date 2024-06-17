library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
    Port ( 
        X0 :     in STD_LOGIC;
        X1 :     in STD_LOGIC;
        S :     in STD_LOGIC;
        Z :     out STD_LOGIC
    );
end MUX2;

architecture Behavioral of MUX2 is

begin
    Z <= (X0 and (not S)) or (X1 and S);
end Behavioral;
