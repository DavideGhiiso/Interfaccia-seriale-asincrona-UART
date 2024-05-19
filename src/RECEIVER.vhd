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
            Q     : out std_logic;
            NOT_Q : out std_logic
        );
    end component;

    component RX_ENABLE is
        Port ( 
            TX  : in STD_LOGIC;
            EOT : in STD_LOGIC;
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;

    component COUNTER_8 is
        Port ( 
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;
    
    component COUNTER_OS is
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
    
    signal EOT      : STD_LOGIC;  -- End Of Transmission: activated when red a Byte from tx
    signal CLK_CNT  : STD_LOGIC;
    signal RST_CNT  : STD_LOGIC;
    signal SAMPLE_EN: STD_LOGIC;  -- enable sampling of TX
    signal RX_EN    : STD_LOGIC;  -- output of RX_ENABLE
    signal REG_EN   : STD_LOGIC;  -- Clock enable of the serial/parallel register
    signal TX_D     : STD_LOGIC;  -- tx data after "fast" sampling
    signal NOT_TX_D : STD_LOGIC;

begin

    TX_D_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => TX,
        Q => TX_D,
        NOT_Q => NOT_TX_D
    );

    FSM_RX_EN : RX_ENABLE port map (
        CLK => CLK, 
        RST => RST,
        EOT => EOT,
        TX => TX_D,
        Z => RX_EN
    );

    CNT_8 : COUNTER_8 port map (
        CLK => CLK_CNT, 
        RST => RST_CNT, 
        Z => EOT
    );

    CNT_OS : COUNTER_OS port map (
        CLK => CLK, 
        RST => RST, 
        Z => SAMPLE_EN
    );

    REG_SP : REG_SP_8 port map (
        CLK => CLK, 
        RST => RST,
        CE => REG_EN,
        X => TX_D,
        Z => DOUT
    );
    
    reg: process(CLK, RST, RX_EN)
    begin
        if (CLK'event and CLK = '1') then
            CLK_CNT <= SAMPLE_EN or ((not REG_EN) and CLK);
            RST_CNT <= RST;
            REG_EN <= SAMPLE_EN and RX_EN;
            READY <= EOT;
        end if;
    end process;

end arch;
