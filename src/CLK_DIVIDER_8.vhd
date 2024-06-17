library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK_DIVIDER_8 is
    Port (
        CLK:    in  std_logic;
        RST:    in std_logic;
        CLK_8:  out std_logic
    );
end CLK_DIVIDER_8;

architecture arch of CLK_DIVIDER_8 is
    signal T: STD_LOGIC_VECTOR (0 to 3);
    
begin
    reg: process(CLK, RST)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then 
                T <= "1000";
            else
                T <= (not T(3)) & T(0 to 2);
            end if;
        end if;
    end process;
    
    clock: process(T) 
    begin
        CLK_8 <= '0' when T(0) = '1' else '1';
    end process;
    
end arch;
