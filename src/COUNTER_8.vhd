library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_8 is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Z   : out STD_LOGIC);
end COUNTER_8;

architecture arch of COUNTER_8 is
    signal T: STD_LOGIC_VECTOR (0 to 3);
    
begin
    reg: process(CLK, RST)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then 
                T <= "1000";
                Z <= '0';
            else
                T <= (not T(3)) & T(0 to 2);
                Z <= '1' when T = "0001" else
                     '0';
            end if;
        end if;
    end process;

end arch;
