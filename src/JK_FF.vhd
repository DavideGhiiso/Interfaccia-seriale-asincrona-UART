library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JK_FF is
    Port ( J   : in STD_LOGIC;
           K   : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Z   : out STD_LOGIC;
           NZ  : out STD_LOGIC);
end JK_FF;

architecture arch of JK_FF is
    signal Q : STD_LOGIC;
begin

    Z <= Q;
    NZ <= not Q;

    reg: process(CLK, RST, J, K)
    begin
        if (RST = '1') then Q <= '0';
        elsif (CLK'event and CLK = '1') then
            Q <= not Q when J = '1' and K = '1' else
                 '1' when J = '1' else
                 '0' when K = '1';
        end if;
    end process;
end arch;
