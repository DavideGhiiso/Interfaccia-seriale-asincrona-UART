library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TB is
end UART_TB;

architecture arch of UART_TB is
    component UART is
    Port ( CLK    : in STD_LOGIC;
           RST    : in STD_LOGIC;
           START  : in STD_LOGIC;
           LEN    : in STD_LOGIC;
           PARITY : in STD_LOGIC;
           CTS    : in STD_LOGIC;
           BC     : in STD_LOGIC;
           RX     : in STD_LOGIC;
           DIN    : in STD_LOGIC_VECTOR (0 to 7);
           TX     : out STD_LOGIC;
           RTS    : out STD_LOGIC;
           READY  : out STD_LOGIC;
           DOUT   : out STD_LOGIC_VECTOR (0 to 7));
    end component;
    
    constant CLK_PERIOD_1 : time := 135 ns;
    constant CLK_PERIOD_2 : time := CLK_PERIOD_1 * 1.02;
    
    signal DIN, DOUT : std_logic_vector (0 to 7);
    
    signal TX, START, CTS, LEN, PARITY, READY, BC,
           CLK_TX, CLK_RX, RST, CLK_RX_ENABLE : std_logic;
        
begin
    UUT_TX: UART port map (
        CLK => CLK_TX,
        RST => RST,
        -- tx
        DIN => DIN,
        TX => TX,
        CTS => CTS,
        START => START,
        LEN => LEN,
        PARITY => PARITY,
        -- rx
        BC => '1',
        RX => '1'
    );
    
    UUT_RX: UART port map (
        CLK => CLK_RX,
        RST => RST,
        -- tx
        DIN => "00000000",
        CTS => '0',
        START => '0',
        LEN => '0',
        PARITY => '0',
        -- rx
        DOUT => DOUT, 
        BC => BC,
        RX => TX,
        RTS => CTS, 
        READY => READY
    );
    
    CLK_process_TX: process
        begin
            CLK_TX <= '0';
            wait for CLK_PERIOD_1 / 2;
            CLK_TX <= '1';
            wait for CLK_PERIOD_1 / 2;
        end process;
        
    CLK_process_RX: process
    begin
        if(CLK_RX_ENABLE='U') then
            CLK_RX_ENABLE <= '1';
            wait for CLK_PERIOD_1 / 2; -- OFFSET
        else
            CLK_RX <= '0';
            wait for CLK_PERIOD_2 / 2;
            CLK_RX <= '1';
            wait for CLK_PERIOD_2 / 2;
        end if;
    end process;
    
    process begin
        RST <= '1';
        wait for CLK_PERIOD_1 * 10;
        FB     <= '1';
        START  <= '0';
        LEN    <= '0';
        PARITY <= '0';
        DIN    <= "00000000";
        
        wait for CLK_PERIOD_1 * 10;
        RST <= '0';
        wait for CLK_PERIOD_1 * 10;
        
        -- TEST 1: 8N1
        START  <= '1';
        PARITY <= '0';
        LEN    <= '0';
        DIN    <= "10110101";
        
        wait for CLK_PERIOD_1 * 8;
        START  <= '0';
        PARITY <= '0';
        LEN    <= '0';
        DIN    <= "01100111";
        wait for CLK_PERIOD_1 * 8 * 9;
        
        -- TEST 2: 7E1
        START  <= '1';
        PARITY <= '0';
        LEN    <= '1';
        DIN    <= "00011100";
        
        wait for CLK_PERIOD_1 * 8;
        START  <= '0';
        PARITY <= '0';
        LEN    <= '0';
        DIN    <= "01100111";
        wait for CLK_PERIOD_1 * 8 * 9;
        
        -- TEST 3: 7O1
        START  <= '1';
        PARITY <= '1';
        LEN    <= '1';
        DIN    <= "01001110";
        
        wait for CLK_PERIOD_1 * 8;
        START  <= '0';
        PARITY <= '0';
        LEN    <= '0';
        DIN    <= "01100111";
        wait for CLK_PERIOD_1 * 8 * 9;
        
        -- TEST 4: trasmission interruption
        START  <= '1';
        PARITY <= '0';
        LEN    <= '0';
        DIN    <= "10101010";
        
        wait for CLK_PERIOD_1 * 8;
        START  <= '0';
        PARITY <= '0';
        LEN    <= '0';
        
        wait for CLK_PERIOD_1 * 8 * 4;
        FB     <= '0';
        wait for CLK_PERIOD_1 * 8 * 4;
        START  <= '1';
        wait for CLK_PERIOD_1 * 8;
        START  <= '0';
        wait for CLK_PERIOD_1 * 8;
        FB     <= '1';
        
        
        RST <= '1';
        wait;
    end process;

end arch;