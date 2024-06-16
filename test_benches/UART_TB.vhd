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
           RX     : in STD_LOGIC;
           DIN    : in STD_LOGIC_VECTOR (0 to 7);
           TX     : out STD_LOGIC;
           RTS    : out STD_LOGIC;
           READY  : out STD_LOGIC;
           DOUT   : out STD_LOGIC_VECTOR (0 to 7));
    end component;
    
    signal DIN, DOUT : std_logic_vector (0 to 7);
    
    signal TX, START, CTS, LEN, PARITY, READY,
           CLK, RST : std_logic;
		
begin
    UUT: UART port map (
        CLK => CLK,
        RST => RST,
        -- tx
        DIN => DIN,
        TX => TX,
        CTS => CTS,
        START => START,
        LEN => LEN,
        PARITY => PARITY,
        -- rx
        DOUT => DOUT, 
        RX => TX,
        RTS => CTS, 
        READY => READY
    );
    
    CLK_process :process
		begin
			CLK <= '0';
			wait for 5 ns;
			CLK <= '1';
			wait for 5 ns;
		end process;
	
	process begin
	RST <= '0';
	wait for 5 ns;
	RST <= '1';
	
	-- first message
	START <= '0';
	LEN <= '0';
	PARITY <= '0';
	DIN <= "01001101";
	wait for 15 ns;
	RST <= '0';
	
	wait for 20 ns;
	START <= '1';
	LEN <= '1';
	
	wait for 80 ns;
	START <= '0';
	LEN <= '0';
	
	for I in 0 to 8 loop
            wait for 80 ns;
        end loop;
	
	wait for 240 ns;
	
	-- second message
	LEN <= '1';
	PARITY <= '1';
	START <= '1';
	DIN <= "00011100";
	
	wait for 80 ns;
	START <= '0';
	LEN <= '0';
	PARITY <= '0';
	
	for I in 0 to 8 loop
            wait for 80 ns;
        end loop;
        
	wait for 160 ns;
	RST <= '1';
	wait;
	end process;

end arch;
