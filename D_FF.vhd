library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF is
    Port (
        CLK:    in  std_logic;
        D:      in  std_logic;
        RST:    in  std_logic;
        Q:      out std_logic;
        NOT_Q:  out std_logic
    );
end D_FF;

architecture rtl of D_FF is -- Q = D only on the rising edge
begin
    ff: process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then
                Q <= '0';
                NOT_Q <= '1';
            else
                Q <= D;
                NOT_Q <= not D;
            end if;
        end if;
    end process;
end rtl;
