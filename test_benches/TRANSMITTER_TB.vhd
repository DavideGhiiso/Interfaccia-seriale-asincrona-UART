library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRANSMITTER_TB is
end TRANSMITTER_TB;

architecture Behavioral of TRANSMITTER_TB is
    component TRANSMITTER is
    Port (
        DIN:    in  std_logic_vector (0 to 7);
        START:  in  std_logic;
        CTS:    in  std_logic;
        LEN:    in  std_logic;
        PARITY: in  std_logic;
        CLK:    in  std_logic;
        RST:    in  std_logic;
        TX:     out std_logic
    );
    end component;
    signal DIN: std_logic_vector (0 to 7);
    signal  START,
            CTS,
            LEN,
            PARITY,
            CLK,
            RST,
            TX: std_logic;
begin
    UUT: TRANSMITTER port map (
        DIN => DIN,
        START => START,
        CTS => CTS,
        LEN => LEN,
        PARITY => PARITY,
        CLK => CLK,
        RST => RST,
        TX => TX
    );
    CLK_process :process
		begin
			CLK <= '0';
			wait for 1.25 ns;
			CLK <= '1';
			wait for 1.25 ns;
		end process;
		process begin
		    RST <= '0';
		    wait for 1ns;
            RST <= '1';
            -- 00101010 PAR:0 LEN:1 -> 00101011
            START <= '0';
            CTS <= '0';
            LEN <= '1';
            PARITY <= '0';
            wait for 21ns;
            RST <= '0';
            DIN <= "00101010";
            CTS <= '1';
            wait for 9ns;
            START <= '1';
            wait for 20ns;
            START <= '0';
            LEN <= '0';
            wait for 180ns;
            CTS <= '0';
            wait for 20ns;
            -- 00101001 PAR:1 LEN:1 -> 00101000
            LEN <= '1';
            PARITY <= '1';
            DIN <= "00101001";
            CTS <= '1';
            wait for 9ns;
            START <= '1';
            wait for 20ns;
            START <= '0';
            PARITY <= '0';
            LEN <= '0';
            wait for 180ns;
            CTS <= '0';
            wait for 20ns;
            -- 00101001 PAR:1 LEN:0 -> 00101001
            LEN <= '0';
            PARITY <= '1';
            DIN <= "00101001";
            CTS <= '1';
            wait for 9ns;
            START <= '1';
            wait for 20ns;
            START <= '0';
            PARITY <= '0';
            LEN <= '0';
            wait for 180ns;
            CTS <= '0';
            wait for 20ns;
            -- 00101001 PAR:0 LEN:0 sudden interruption
            LEN <= '0';
            PARITY <= '0';
            DIN <= "00101001";
            CTS <= '1';
            wait for 9ns;
            START <= '1';
            wait for 20ns;
            START <= '0';
            PARITY <= '0';
            LEN <= '0';
            wait for 75ns; --random time < 180ns
            CTS <= '0';
            wait;
		end process;
end Behavioral;
