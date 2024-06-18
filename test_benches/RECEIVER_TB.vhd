library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER_TB is
end RECEIVER_TB;

architecture arch of RECEIVER_TB is
    component RECEIVER is
        Port ( 
            CLK   : in STD_LOGIC;
            RST   : in STD_LOGIC;
            CTS   : in STD_LOGIC;
            RX    : in STD_LOGIC;
            READY : out STD_LOGIC;
            DOUT  : out STD_LOGIC_VECTOR (0 to 7)
    );
    end component;
        
    signal RX   : std_logic;
    signal CLK  : std_logic;
    signal RST  : std_logic;
    signal CTS  : std_logic;
    signal READY: std_logic;
    signal DOUT : std_logic_vector (0 to 7);
    
    signal MSG: std_logic_vector (0 to 7);
    
begin
    -- unit under test
    UUT: RECEIVER port map (
        RX => RX,
        CLK => CLK, 
        RST => RST, 
        CTS => CTS, 
        READY => READY, 
        DOUT => DOUT
    );
    
    CLK_process : process
        begin
            CLK <= '0';
            wait for 2.5 ns;
            CLK <= '1';
            wait for 2.5 ns;
        end process;
        
    process begin
        -- setup
        MSG <= "11011100";
        RST <= '1';
        RX <= '1';
        wait for 25 ns;
        RST <= '0';
        wait for 40 ns;
        
        -- start 1st message
        RX <= '0';
        wait for 40 ns;
        for I in 0 to 7 loop
            RX <= MSG(I);
            wait for 40 ns;
        end loop;    
        RX <= '1';
        wait for 160 ns;
        
        -- start 2nd message
        MSG <= "11111110";
        RX <= '0';
        wait for 40 ns;
        for I in 0 to 7 loop
            RX <= MSG(I);
            wait for 40 ns;
        end loop;    
        RX <= '1';
        wait for 120 ns;
        
        -- reset before closing simulation
        RST <= '1';
        wait;
    end process;

end arch;