library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SAMPLE_ENABLE_FSM_TB is
end SAMPLE_ENABLE_FSM_TB;

architecture arch of SAMPLE_ENABLE_FSM_TB is
    component SAMPLE_ENABLE_FSM is Port ( 
        CLK    : in STD_LOGIC;
        RST    : in STD_LOGIC;
        RX     : in STD_LOGIC;
        SLEEP  : in STD_LOGIC;
        ENABLE : out STD_LOGIC );
    end component ;
    
    constant CLK_T : time := 10 ns;
    
    signal CLK, RST, RX, SLEEP, ENABLE : STD_LOGIC;
    
begin
    UUT : SAMPLE_ENABLE_FSM port map (
        RST    => RST,
        CLK    => CLK,
        RX     => RX,
        SLEEP  => SLEEP,
        ENABLE => ENABLE
    );
    
    clk_process : process
    begin
        CLK <= '0';
        wait for CLK_T / 2;
        CLK <= '1';
        wait for CLK_T / 2;
    end process;
    
    process begin
        -- setup
        RST <= '1';
        wait for CLK_T * 2;
        RX <= '1';
        SLEEP <= '1';
        wait for CLK_T * 2;
        RST <= '0';
        wait for CLK_T * 4;
        
        -- start of trasmission
        RX <= '0';
        wait for CLK_T * 4;
        SLEEP <= '0';
        wait for CLK_T * 4;
        for I in 0 to 7 loop
            RX <= not RX;
            wait for CLK_T * 8;
        end loop;
        -- end of trasmission
        RX <= '1';
        wait for CLK_T * 4;
        SLEEP <= '1';
        
        wait for CLK_T * 8;
        RST <= '1';
        wait;
    end process;

end arch;
