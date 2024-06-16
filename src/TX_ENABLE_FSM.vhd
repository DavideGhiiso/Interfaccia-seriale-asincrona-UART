library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TX_ENABLE_FSM is
    Port (
        START:      in std_logic;
        CTS:        in std_logic;
        CLK:        in std_logic;
        RST:        in std_logic; 
        TX_ENABLE:  out std_logic
    );
end TX_ENABLE_FSM;

architecture Behavioral of TX_ENABLE_FSM is
    type STATUS is (W, R, S);
    signal PS, NS: STATUS;
begin
    delta: process(START, CTS, PS) 
        begin
            case PS is
                when W =>
                    NS <= R when START = '1' and CTS = '0' else 
                          S when START = '1' and CTS = '1' else
                          W;
                when R =>
                    NS <= S when CTS = '1' else
                          R;
                when S =>
                    NS <= W when CTS = '0' and START = '0' else
                          R when START = '1' and CTS = '0' else
                          S;
            end case;
    end process;
    lambda: process(START, CTS, PS)
        begin
            case PS is
                when W | R =>
                    TX_ENABLE <= '0';
                when S =>
                    TX_ENABLE <= '1';
            end case;
        end process;
    state: process(CLK)
        begin
        if( RST = '1' ) then
            PS <= W;
        elsif( CLK'event and CLK = '1' ) then      
            PS <= NS;
        end if;
    end process;
end Behavioral;
