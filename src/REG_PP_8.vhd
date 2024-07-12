library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PP_8 is 
    Port (
        CLK:    in std_logic;
        RST:    in std_logic;
        CE:     in std_logic;
        X:      in std_logic_vector(0 to 7);
        Z:      out std_logic_vector(0 to 7)
    );
end REG_PP_8;

architecture rtl of REG_PP_8 is 
begin
    reg: process(CLK, RST)
    begin
    if(RST = '1') then
        Z <= "00000000";
    elsif(CLK'event and CLK = '1' and CE = '1') then
        Z <= X;
    end if;
    end process;
end rtl;