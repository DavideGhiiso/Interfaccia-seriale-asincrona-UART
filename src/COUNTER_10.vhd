library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_10 is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Z   : out STD_LOGIC);
end COUNTER_10;

architecture arch of COUNTER_10 is
    signal T: STD_LOGIC_VECTOR (0 to 4);
    
begin
    reg: process(CLK, RST)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then 
                T <= "10000";
                Z <= '0';
            else
                T <= (not T(4)) & T(0 to 3);
                Z <= '1' when T = "00000" else
                     '0';
            end if;
        end if;
    end process;

end arch;
