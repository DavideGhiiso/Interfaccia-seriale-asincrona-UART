library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SAMPLE_ENABLE_FSM is Port ( 
    CLK    : in STD_LOGIC;
    RST    : in STD_LOGIC;
    RX     : in STD_LOGIC;
    SLEEP  : in STD_LOGIC;
    ENABLE : out STD_LOGIC);
end SAMPLE_ENABLE_FSM;

architecture arch of SAMPLE_ENABLE_FSM is
    type STATUS is (W, E);
    
    signal PS, NS : STATUS;
    signal T : STD_LOGIC;

begin

state: process(RX, SLEEP, PS)
    begin
        NS <= E when PS = W and RX = '0' and SLEEP = '1' else
              E when PS = E and SLEEP = '0' else 
              W when PS = E and SLEEP = '1' and RX = '1' else
              W when PS = W and RX = '1' else PS;
    end process;
    
    reg: process(RST, CLK, NS)
    begin
        if (RST = '1') then PS <= W;
        elsif (CLK'event and CLK = '1') then
            PS <= NS;
        end if;
    end process;
    
    output: process(PS)
    begin
        ENABLE <= '1' when PS = E else '0';
    end process;

end arch;
