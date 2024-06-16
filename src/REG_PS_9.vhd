library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PS_9 is
    Port (
        CLK:        in  std_logic;
        START:      in std_logic;
        CE:         in std_logic;
        RST:        in  std_logic;
        X:          in  std_logic_vector (0 to 8);
        Z:          out std_logic
    );
end REG_PS_9;

architecture rtl of REG_PS_9 is
    signal T: std_logic_vector(0 to 8); -- register content
begin
    Z <= T(8);  
    reg: process(CLK, RST)
    begin
        if(RST = '1') then
                    T <= "000000000";
                    --Z <= T(8);
        end if;
        if(CLK'event and CLK = '1') then
            if(START = '1') then
                T <= X;
            elsif(CE = '1') then
                T(0) <= '1';
                for i in 0 to 7 loop
                    T(i+1) <= T(i);
                end loop;
                
            end if;
        end if;
    end process;
end rtl;
