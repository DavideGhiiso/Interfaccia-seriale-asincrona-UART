library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_OS is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Z   : out STD_LOGIC);
end COUNTER_OS;

architecture arch of COUNTER_OS is
    signal T: STD_LOGIC_VECTOR (0 to 3);
    signal OS: STD_LOGIC;
    
begin
    reg: process(CLK, RST)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then 
                T <= "1000";
                OS <= '0';
                Z <= '0';
            else
                OS <= '1' when OS = '0' and T = "1111" else
                      '0' when OS = '1' and T = "0000" else
                      '1' when OS = '1' else
                      '0';
                T <= "1000" when OS = '0' and T = "1111" else
                     (not T(3)) & T(0 to 2);
                Z <= '1' when T = "0000" else
                     '0';
            end if;
        end if;
    end process;
end arch;
