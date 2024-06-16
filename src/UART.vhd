library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
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
end UART;

architecture arch of UART is
    component TRANSMITTER is
    Port (
        DIN    : in  std_logic_vector (0 to 7);
        START  : in  std_logic;
        CTS    : in  std_logic;
        LEN    : in  std_logic;
        PARITY : in  std_logic;
        CLK    : in  std_logic;
        RST    : in  std_logic;
        TX     : out std_logic
    );
    end component;
    
    component RECEIVER is
        Port ( 
            CLK   : in STD_LOGIC;
            RST   : in STD_LOGIC;
            RX    : in STD_LOGIC;
            READY : out STD_LOGIC;
            RTS   : out STD_LOGIC;
            DOUT  : out STD_LOGIC_VECTOR (0 to 7)
    );
    end component;

begin

    TX_UNIT: TRANSMITTER port map (
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        TX => TX,
        CTS => CTS,
        START => START,
        LEN => LEN,
        PARITY => PARITY
        
    );
    
    RX_UNIT: RECEIVER port map (
        CLK => CLK, 
        RST => RST,
        DOUT => DOUT, 
        RX => RX,
        RTS => RTS, 
        READY => READY
    );

end arch;
