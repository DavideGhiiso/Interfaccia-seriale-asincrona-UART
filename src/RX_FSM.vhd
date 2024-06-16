library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RX_FSM is
    Port ( 
        CLK    : in  STD_LOGIC;
        RST    : in  STD_LOGIC;
        RX     : in  STD_LOGIC;
        EOB    : in  STD_LOGIC;
        EOT    : out STD_LOGIC;
        SOT    : out STD_LOGIC;
        ALERT  : out STD_LOGIC
    );
end RX_FSM;

architecture arch of RX_FSM is
    type STATUS is (W, R, A);
    
    signal PS, NS : STATUS;
    signal T : STD_LOGIC;
    
begin
    SOT <= not EOT;

    state: process(CLK, RST, RX, EOB)
    begin
        if (CLK'event and CLK = '1') then
            NS <= R when PS = W and RX = '0' else
                  A when PS = R and EOB = '1' else 
                  W when PS = A else NS;
        end if;
    end process;
    
    reg: process(RST, CLK, NS)
    begin
        if (RST = '1') then PS <= W;
        else
            PS <= NS;
        end if;
    end process;
    
    output: process(NS)
    begin
        EOT <= '0' when NS = R else '1';
        ALERT <= '1' when NS = A else '0';
    end process;
end arch;
