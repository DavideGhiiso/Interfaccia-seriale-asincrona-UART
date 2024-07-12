library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF is
    Port (
        RST:    in  std_logic;
        SET:    in  std_logic;
        CLK:    in  std_logic;
        CE:     in  std_logic;
        D:      in  std_logic;
        Q:      out std_logic;
        NOT_Q:  out std_logic
    );
end D_FF;

architecture rtl of D_FF is
    signal T : STD_LOGIC;
begin
    Q <= T;
    NOT_Q <= not T;
    
    ff: process(CLK)
    begin
        if (RST = '1') then
            T <= '0';
        elsif (SET = '1') then
            T <= '1'; 
        elsif (CLK'event and CLK = '1' and CE = '1') then
            T <= D;
        end if;
    end process;
end rtl;
