library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER is
    Port ( 
        CLK   : in STD_LOGIC;
        RST   : in STD_LOGIC;
        RX    : in STD_LOGIC;
        READY : out STD_LOGIC;
        CTS   : out STD_LOGIC;
        DOUT  : out STD_LOGIC_VECTOR (0 to 7)
    );
end RECEIVER;

architecture arch of RECEIVER is
    component D_FF is
        Port (
            CLK   : in  std_logic;
            D     : in  std_logic;
            RST   : in  std_logic;
            Q     : out std_logic
        );
    end component;
    
    component JK_FF is
        Port ( 
            J   : in STD_LOGIC;
            K   : in STD_LOGIC;
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;

    component COUNTER_OS is
        Port ( 
            CE  : in STD_LOGIC;
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;
    
    component COUNTER_8 is
        Port ( 
            CE  : in STD_LOGIC;
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC);
    end component;
    
    component REG_SP_8 is
        Port (
            CLK:        in  std_logic;
            CE:         in  std_logic;
            RST:        in  std_logic;
            X:          in  std_logic;
            Z:          out std_logic_vector (0 to 7)
        );
    end component;
    
    signal RX_D     : STD_LOGIC;  -- rx data after "fast" sampling
    signal SAMPLE   : STD_LOGIC;  -- slower clock
    signal CNT_EN   : STD_LOGIC;  -- enable sampling of rx
    signal SOT      : STD_LOGIC;  -- Start Of Transmission
    signal EOB      : STD_LOGIC;  -- End Of Byte
    signal EOT      : STD_LOGIC;  -- End Of Transmission
    
    signal START_RX : STD_LOGIC;

begin

    RX_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => RX,
        Q => RX_D
    );
    
    SOT_FF : JK_FF port map (
        CLK => CLK, 
        RST => RST,
        J => START_RX,
        K => EOB,
        Z => SOT
    );

    CNT_OS : COUNTER_OS port map ( -- fast counter (used for sampling)
        CE => CNT_EN,
        CLK => CLK, 
        RST => EOT, 
        Z => SAMPLE
    );
    
    CNT_8 : COUNTER_8 port map ( -- fast counter (used for sampling)
        CE => CNT_EN,
        CLK => SAMPLE, 
        RST => EOT, 
        Z => EOB
    );

    REG_SP : REG_SP_8 port map (
        CLK => SAMPLE, 
        RST => RST,
        CE => SOT,
        X => RX_D,
        Z => DOUT
    );
    
    CNT_EN <= not EOT;
    START_RX <= EOT and not RX_D;
    READY <= EOB and not SOT when RST = '0' else '1';
    CTS <= not READY;
    
    p_eot: process(SAMPLE, EOB, SOT)
    begin 
        if (RST = '1') then EOT <= '1';
        elsif (SAMPLE'event and SAMPLE = '1') then EOT <= EOB;
        elsif (SOT = '1') then EOT <= '0';
        end if;
    end process;

end arch;
