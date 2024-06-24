library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER is
    Port ( 
        CLK   : in STD_LOGIC;
        RST   : in STD_LOGIC;
        RX    : in STD_LOGIC;
        BC    : in STD_LOGIC; -- Clear Buffer
        CTS   : out STD_LOGIC;
        READY : out STD_LOGIC;
        DOUT  : out STD_LOGIC_VECTOR (0 to 7)
    );
end RECEIVER;

architecture arch of RECEIVER is
    component D_FF is Port (
        RST   : in  std_logic;
        SET:    in  std_logic;
        CLK   : in  std_logic;
        CE:     in  std_logic;
        D     : in  std_logic;
        Q     : out std_logic;
        NOT_Q : out std_logic );
    end component;
    
    component SAMPLE_ENABLE_FSM is Port ( 
        CLK    : in STD_LOGIC;
        RST    : in STD_LOGIC;
        RX     : in STD_LOGIC;
        SLEEP  : in STD_LOGIC;
        ENABLE : out STD_LOGIC );
    end component;
    
    component COUNTER_8 is Port (
        RST : in STD_LOGIC;
        CLK : in STD_LOGIC;
        CE  : in STD_LOGIC;
        RIF : in STD_LOGIC_VECTOR (0 to 3);
        Z   : out STD_LOGIC );
    end component;
    
    component RX_FSM is Port (
        RST   : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        CE    : in  std_logic;
        RX    : in  STD_LOGIC;
        EOB   : in  STD_LOGIC;
        SLEEP : out STD_LOGIC;
        ALERT : out STD_LOGIC );
    end component;
        
    component REG_SP_8 is Port (
        RST : in  std_logic;
        CLK : in  std_logic;
        CE  : in  std_logic;
        X   : in  std_logic;
        Z   : out std_logic_vector (0 to 7) );
    end component;
    
    --signal J, K     : STD_LOGIC;
    signal RX_BUF   : STD_LOGIC;  -- rx data after "fast" sampling
    signal SAMPLE_EN: STD_LOGIC;
    signal CNT_RST  : STD_LOGIC;
    signal REG_EN   : STD_LOGIC;
    signal SAMPLE   : STD_LOGIC;  -- slower clock enable to sample RX
    signal EOB      : STD_LOGIC;  -- End Of Byte
    signal SLEEP    : STD_LOGIC;  -- End Of Transmission
    signal ALERT    : STD_LOGIC;

begin

    RX_FF : D_FF port map (
        RST => '0',
        SET => RST,
        CLK => CLK,
        CE => '1',
        D   => RX,
        Q   => RX_BUF
    );
    
    READY_FF : D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => '1',
        D   => ALERT,
        Q   => READY
    );
    
    BC_FF : D_FF port map (
        RST => '0',
        SET => RST,
        CLK => CLK,
        CE => '1',
        D   => BC,
        Q   => CTS
    );
    
    FSM_SAMPLE : SAMPLE_ENABLE_FSM port map (
        RST    => RST,
        CLK    => CLK,
        RX     => RX_BUF,
        SLEEP  => SLEEP,
        ENABLE => SAMPLE_EN
    );

    CNT_SAMPLE : COUNTER_8 port map ( -- fast counter (used for sampling) 
        RST => CNT_RST,
        CLK => CLK,
        CE  => SAMPLE_EN,
        RIF => "1100", 
        Z   => SAMPLE
    );
    
    CNT_BYTE: COUNTER_8 port map ( -- slow counter (used to count the bits of the Byte) 
        RST => CNT_RST,
        CLK => CLK, 
        CE  => SAMPLE,
        RIF => "0000",
        Z   => EOB
    );
    
    FSM_RX : RX_FSM port map (
        RST   => RST,
        CLK   => CLK,
        CE    => SAMPLE,
        RX    => RX_BUF,
        EOB   => EOB,
        SLEEP   => SLEEP,
        ALERT => ALERT
    );

    REG_SP : REG_SP_8 port map ( 
        RST => RST,
        CLK => CLK,
        CE => REG_EN,
        X => RX_BUF,
        Z => DOUT
    );
    
    CNT_RST <= not SAMPLE_EN;
    REG_EN <= not ALERT and SAMPLE;
    --READY <= ALERT;

end arch;
