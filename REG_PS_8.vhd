library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PS_8 is
    Port (
        CLK:        in  std_logic;
        START:      in std_logic;
        TX_ENABLE:  in std_logic;
        RST:        in  std_logic;
        X:          in  std_logic_vector (0 to 7);
        Z:          out std_logic
    );
end REG_PS_8;

architecture rtl of REG_PS_8 is
    signal T: std_logic_vector(0 to 7); -- register content
begin
    reg: process(CLK, RST)
    begin
        if(RST = '1') then
            T <= "11111111"; -- reset alto
        elsif(CLK'event and CLK = '1') then
            if(START = '1') then
                T <= X;
            else
                T(0) <= '0';
                for i in 0 to 6 loop
                    T(i+1) <= T(i);
                end loop;
            end if;
        end if;
    end process;
    Z <= T(7);
end rtl;
