library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PS_10 is
    Port (
        CLK:        in  std_logic;
        START:      in std_logic;
        TX_ENABLE:  in std_logic;
        RST:        in  std_logic;
        X:          in  std_logic_vector (0 to 7);
        Z:          out std_logic
    );
end REG_PS_10;

architecture rtl of REG_PS_10 is
    signal T: std_logic_vector(0 to 9); -- register content
begin
    reg: process(CLK, RST)
    begin
        if(CLK'event and CLK = '1') then
            if(RST = '1') then
                T <= "0000000000";
                Z <= '1';
                
            elsif(START = '1') then
                T <= '1' & X  & '0';
            elsif(TX_ENABLE = '1') then
                T(0) <= '0';
                for i in 0 to 8 loop
                    T(i+1) <= T(i);
                end loop;
                Z <= T(9);
            end if;
        end if;
    end process;
end rtl;
