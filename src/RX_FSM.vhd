library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RX_FSM is
    Port ( CLK    : in  STD_LOGIC;
           RST    : in  STD_LOGIC;
           CE     : in  STD_LOGIC;
           RX     : in  STD_LOGIC;
           EOB    : in  STD_LOGIC;
           EOT    : out STD_LOGIC;
           ALERT  : out STD_LOGIC
    );
end RX_FSM;

architecture arch of RX_FSM is
    type STATUS is (W, R, A);
    
    signal PS, NS : STATUS;
    signal T : STD_LOGIC;
    
begin

    state: process(RX, EOB, PS)
    begin
        NS <= R when PS = W and RX = '0' else
              A when PS = R and EOB = '1' else 
              W when PS = A else PS;
    end process;
    
    reg: process(RST, CLK, NS)
    begin
        if (RST = '1') then PS <= W;
        elsif (CLK'event and CLK = '1' and CE = '1') then
            PS <= NS;
        end if;
    end process;
    
    output: process(PS)
    begin
        --SOT <= '1' when PS = R or PS = S else '0';
        EOT <= '1' when PS = W else '0';
        ALERT <= '1' when PS = A else '0';
    end process;
end arch;
