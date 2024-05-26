library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF_ASYNC_RST is
    Port (
        CLK:    in  std_logic;
        D:      in  std_logic;
        RST:    in  std_logic;
        Q:      out std_logic;
        NOT_Q:  out std_logic
    );
end D_FF_ASYNC_RST;

architecture rtl of D_FF_ASYNC_RST is -- Q = D only on the rising edge
begin
    ff: process(CLK, RST)
    begin
        if (RST'event and RST = '1') then
            Q <= '0';
            NOT_Q <= '1';
        elsif (CLK'event and CLK = '1') then
            Q <= D;
            NOT_Q <= not D;
        end if;
    end process;
end rtl;
