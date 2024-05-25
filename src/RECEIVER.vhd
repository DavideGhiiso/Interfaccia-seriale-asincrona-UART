library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER is
    Port ( 
        CLK   : in STD_LOGIC;
        RST   : in STD_LOGIC;
        TX    : in STD_LOGIC;
        READY : out STD_LOGIC;
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
    
    component T_FF is
        Port ( 
            CLK : in  STD_LOGIC;
            RST : in  STD_LOGIC;
            T   : in  STD_LOGIC;
            Q   : out STD_LOGIC
        );
    end component;

    component RX_ENABLE is
        Port ( 
            CLK   : in  STD_LOGIC;
            RST   : in  STD_LOGIC;
            TX    : in  STD_LOGIC;
            SEN   : in  STD_LOGIC;
            EOT   : in  STD_LOGIC;
            Q     : out STD_LOGIC
        );
    end component;

    component COUNTER_8 is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC
        );
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
    
    signal TX_D     : STD_LOGIC;  -- tx data after "fast" sampling
    signal RX_DONE  : STD_LOGIC;  -- activated when red a Byte from tx
    signal CLK_CNT  : STD_LOGIC;
    signal RST_CNT  : STD_LOGIC;
    signal SEN      : STD_LOGIC;  -- enable sampling of TX
    signal EOT      : STD_LOGIC;  -- End Of Transmission
    signal REG_EN   : STD_LOGIC;  -- Clock enable of the serial/parallel register

begin

    TX_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => TX,
        Q => TX_D
    );
    
    READY_FF : T_FF port map (
        CLK => CLK, 
        RST => RST,
        T => EOT,
        Q => READY
    );

    RX_EN : RX_ENABLE port map (
        CLK => CLK, 
        RST => RST,
        EOT => RX_DONE,
        SEN => SEN,
        TX => TX_D,
        Q => REG_EN
    );

    F_CNT : COUNTER_8 port map ( -- fast counter (used for sampling)
        CLK => CLK, 
        RST => RST_CNT, 
        Z => SEN
    );

    S_CNT : COUNTER_8 port map ( -- slow counter (used to count the byte)
        CLK => CLK_CNT, 
        RST => RST_CNT, 
        Z => RX_DONE
    );

    REG_SP : REG_SP_8 port map (
        CLK => SEN, 
        RST => RST,
        CE => REG_EN,
        X => TX_D,
        Z => DOUT
    );
    
    reg: process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            RST_CNT <= RST or (not REG_EN);
            CLK_CNT <= SEN or (not REG_EN);
            EOT <= RX_DONE and (not READY);
        end if;
    end process;

end arch;
