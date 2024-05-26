library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGE_SEEKER is
    Port ( 
        RST : in  STD_LOGIC;
        X   : in  STD_LOGIC;
        Z   : out STD_LOGIC);
end EDGE_SEEKER;

architecture arch of EDGE_SEEKER is

begin
    proc: process (RST, X)
    begin
        if (RST = '1') then 
            Z <= '0';
        elsif (X'event and X = '0') then
            Z <= '1';
        end if;
    end process;
end arch;
