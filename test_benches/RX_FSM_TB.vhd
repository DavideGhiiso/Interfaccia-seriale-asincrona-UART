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
        SLEEP  : out STD_LOGIC;
        ALERT  : out STD_LOGIC
    );
    end component;
    
    constant CLK_T : time := 10 ns;
    
    signal CLK, RST, CE, RX, EOB, SLEEP, ALERT : STD_LOGIC;

begin
    UUT : RX_FSM port map (
        RST   => RST,
        CLK   => CLK,
        CE    => CE,
        RX    => RX,
        EOB   => EOB,
        SLEEP  => SLEEP,
        ALERT => ALERT
    );
    
    CLK_process : process
    begin
        CLK <= '0';
        wait for CLK_T / 2;
        CLK <= '1';
        wait for CLK_T / 2;
    end process;
    
    CE_process : process
    begin
        CE <= '0' or RST;
            wait for CLK_T * 7;
            CE <= '1';
            wait for CLK_T;
    end process;
    
    process begin
    -- setup
    RST <= '1';
    wait for CLK_T * 4;
    RX <= '1';
    EOB <= '0';
    wait for CLK_T * 8;
    RST <= '0';
    wait for CLK_T * 16;
    
    -- 1st trasmission
    RX <= '0';
    wait for CLK_T * 8;
    for I in 0 to 6 loop
        RX <= not RX;
        wait for CLK_T * 8;
    end loop; 
    RX <= not RX;
    EOB <= '1';
    wait for CLK_T * 8;
    EOB <= '0';
    RX <= '1';
    wait for CLK_T * 16;
    
    -- 2nd trasmission
    RX <= '0';
    wait for CLK_T * 8;
    for I in 0 to 6 loop
        RX <= not RX;
        wait for CLK_T * 8;
    end loop; 
    RX <= not RX;
    EOB <= '1';
    wait for CLK_T * 8;
    EOB <= '0';
    RX <= '1';
    wait for CLK_T * 8 * 2;
     
    wait;
    
    end process;

end arch;
