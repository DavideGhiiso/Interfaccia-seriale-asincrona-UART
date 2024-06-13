library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_8 is
    Port ( 
        CE  : in STD_LOGIC;
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Z   : out STD_LOGIC
    );
end COUNTER_8;

architecture arch of COUNTER_8 is
    signal T: STD_LOGIC_VECTOR (0 to 3);
    signal Y : STD_LOGIC;
    
begin
    reg: process(CLK, CE, RST)
    begin
        if (RST = '1') then 
            T <= "1000";
            Y <= '0';
        elsif (CLK'event and CLK = '1' and CE = '1') then
            if (Y = '0') then 
                T <= (not T(3)) & T(0 to 2);
            end if;
            Y <= '1' when T = "0000";
        end if;
    end process;
    
    out_proc: process(Y)
    begin
        Z <= Y;
    end process;
end arch;
