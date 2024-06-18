library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RX_FSM_TB is
end RX_FSM_TB;

architecture arch of RX_FSM_TB is
    component RX_FSM is Port ( 
            CLK    : in  STD_LOGIC;
            RST    : in  STD_LOGIC;
            CE     : in  STD_LOGIC;
            RX     : in  STD_LOGIC;
            EOB    : in  STD_LOGIC;
            EOT    : out STD_LOGIC;
            ALERT  : out STD_LOGIC
        );
    end component;
    
    signal CLK, RST, CE, RX, EOB, EOT, ALERT : STD_LOGIC;

begin
    UUT : RX_FSM port map (
        RST   => RST,
        CLK   => CLK,
        CE    => CE,
        RX    => RX,
        EOB   => EOB,
        EOT   => EOT,
        ALERT => ALERT
    );
    
    CLK_process : process
    begin
        CLK <= '0';
        wait for 2.5 ns;
        CLK <= '1';
        wait for 2.5 ns;
    end process;
    
    CE_process : process
    begin
        CE <= '0';
        wait for 10 ns;
        if (RST = '0') then CE <= '1';
        end if;
        wait for 10 ns;
    end process;
    
    process begin
    RST <= '1';
    RX <= '1';
    EOB <= '0';
    
    wait for 30 ns;
    RST <= '0';
    
    wait for 25 ns;
    
    -- 1st byte
    for I in 0 to 8 loop
        RX <= not RX;
        wait for 40 ns;
    end loop; 
    
    wait for 80 ns;
    
    -- 2nd byte
    for I in 0 to 8 loop
        RX <= not RX;
        wait for 40 ns;
    end loop; 
    
    wait;
    
    end process;

end arch;
