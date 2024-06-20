library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PS_8 is
    Port (
        CLK:        in  std_logic;
        LOAD:      in std_logic;
        CE:         in std_logic;
        RST:        in  std_logic;
        X:          in  std_logic_vector (0 to 7);
        Z:          out std_logic
    );
end REG_PS_8;

architecture rtl of REG_PS_8 is
    signal T: std_logic_vector(0 to 7); -- register content
begin
    Z <= T(7);  
    reg: process(CLK, RST)
    begin
        if(RST = '1') then
                    T <= "11111111";
        end if;
        if(CLK'event and CLK = '1') then
            if(LOAD = '1') then
                T <= X;
            elsif(CE = '1') then
                T(0) <= '1';
                for i in 0 to 6 loop
                    T(i+1) <= T(i);
                end loop;
        
            end if;
        end if;
    end process;
end rtl;
