library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_FF is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           T   : in  STD_LOGIC;
           Q   : out STD_LOGIC
    );
end T_FF;

architecture arch of T_FF is
    signal Qin : STD_LOGIC;

begin
ff: process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then
                Q <= '0';
                Qin <= '0';
            elsif (T = '1') then
                Q <= not Qin;
            end if;
        end if;
    end process;
end arch;
