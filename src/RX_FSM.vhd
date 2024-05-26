library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RX_FSM is
    Port ( 
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        CE  : in  STD_LOGIC;
        TX  : in  STD_LOGIC;
        RE  : out STD_LOGIC;
        EOT : out STD_LOGIC
    );
end RX_FSM;

architecture arch of RX_FSM is
    type STATUS is (W, R, A); -- Wait, Read, Alert
    
    component COUNTER_8 is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;
    
    signal PS, NS : STATUS;
    signal DONE, RST_CNT : STD_LOGIC;

begin

    CNT : COUNTER_8 port map (
        CLK => CLK, 
        RST => RST_CNT, 
        Z => DONE
    );
    
    delta: process(PS, RST, TX, RE, EOT)
    begin
        NS <= W when RST = '1' else
              R when PS = W else
              W when PS = R and DONE = '1' else
              --W when PS = A else
              PS;
    end process;
    
    RST_CNT <= '1' when PS = W else RST;
    
    state_output: process(CLK, CE, PS)
    begin
        if (RST = '1') then 
            PS <= W;
            RE <= '0';
            EOT <= '0';
        elsif (CLK'event and CLK = '1' and CE = '1') then
            PS <= NS;
            RE <= '1' when NS = R else '0';
            EOT <= '0' when NS = R else DONE;
            --EOT <= DONE;
        end if;
    end process;
    
end arch;
