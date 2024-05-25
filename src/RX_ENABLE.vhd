library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RX_ENABLE is
    Port ( TX  : in  STD_LOGIC;  -- (fast) sampled bit
           SEN : in  STD_LOGIC;  -- Sample ENable
           EOT : in  STD_LOGIC;  -- End Of Transmission
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           Q   : out STD_LOGIC
    );
end RX_ENABLE;

architecture Behavioral of RX_ENABLE is
type STATUS is (W, S, R, E);
signal PS, NS: STATUS;

begin
-- next state and output
delta: process(PS, TX, SEN, EOT)
begin
    NS <= W when RST = '1' else
          S when PS = W and TX = '0' and EOT = '0' else
          R when PS = S and SEN = '1' and EOT = '0' else
          E when PS = R and EOT = '1' else
          W when PS = E and SEN = '1' else
          PS;
end process;

-- state and output register
state_output: process(CLK)
begin
    if (CLK'event and CLK = '1') then
        if (RST = '1') then 
            PS <= W;
            Q <= '0';
        else 
            PS <= NS;
            Q <= '0' when NS = W else '1';
        end if;
    end if;
end process;

end Behavioral;
