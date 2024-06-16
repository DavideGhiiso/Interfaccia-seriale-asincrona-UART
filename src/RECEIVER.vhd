library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER is
    Port ( 
        CLK   : in STD_LOGIC;
        RST   : in STD_LOGIC;
        RX    : in STD_LOGIC;
        READY : out STD_LOGIC;
        RTS   : out STD_LOGIC;
        DOUT  : out STD_LOGIC_VECTOR (0 to 7)
    );
end RECEIVER;

architecture arch of RECEIVER is
    component CLK_DIVIDER_8 is Port (
        CLK   : in  std_logic;
        RST   : in std_logic;
        CLK_8 : out std_logic );
    end component;
    
    component D_FF is Port (
        CE    : in  std_logic;
        CLK   : in  std_logic;
        D     : in  std_logic;
        RST   : in  std_logic;
        Q     : out std_logic;
        NOT_Q : out std_logic );
    end component;
    
    component COUNTER_8 is Port ( 
        CE  : in STD_LOGIC;
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        RIF : in STD_LOGIC_VECTOR (0 to 3);
        Z   : out STD_LOGIC );
    end component;
    
    component RX_FSM is Port (
       CLK    : in  STD_LOGIC;
       RST    : in  STD_LOGIC;
       RX     : in  STD_LOGIC;
       EOB    : in  STD_LOGIC;
       EOT    : out STD_LOGIC;
       SOT    : out STD_LOGIC;
       ALERT  : out STD_LOGIC );
    end component;
        
    component REG_SP_8 is Port (
        CLK : in  std_logic;
        CE  : in  std_logic;
        RST : in  std_logic;
        X   : in  std_logic;
        Z   : out std_logic_vector (0 to 7) );
    end component;
    
    signal CLK_8    : STD_LOGIC;
    signal RX_D     : STD_LOGIC;  -- rx data after "fast" sampling
    signal SAMPLE   : STD_LOGIC;  -- slower clock
    signal CNT_EN   : STD_LOGIC;  -- enable counters
    signal EOB      : STD_LOGIC;  -- End Of Byte
    signal SOT      : STD_LOGIC;  -- Start Of Transmission
    signal EOT      : STD_LOGIC;  -- End Of Transmission

begin

    RX_FF : D_FF port map (
        CLK => CLK, 
        CE => '1',
        RST => RST,
        D => RX,
        Q => RX_D
    );
    
    CLK_DIVIDER: CLK_DIVIDER_8 port map (
        CLK => CLK,
        RST => RST,
        CLK_8 => CLK_8
    );

    CNT_FAST : COUNTER_8 port map ( -- fast counter (used for sampling)
        CE => '1',
        CLK => CLK, 
        RST => EOT,
        RIF => "0001", 
        Z => SAMPLE
    );
    
    CNT_SLOW: COUNTER_8 port map ( -- slow counter (used to count the bits of the Byte)
        CE => '1',
        CLK => SAMPLE, 
        RST => EOT, 
        RIF => "0000",
        Z => EOB
    );
    
    FSM : RX_FSM port map (
        CLK => CLK_8,
        RST => RST,
        RX => RX_D,
        EOB => EOB,
        EOT => EOT,
        SOT => SOT,
        ALERT => READY
    );

    REG_SP : REG_SP_8 port map (
        CLK => SAMPLE, 
        RST => RST,
        CE => SOT,
        X => RX_D,
        Z => DOUT
    );
    
    CNT_EN <= not EOT;
    RTS <= not READY;

end arch;
