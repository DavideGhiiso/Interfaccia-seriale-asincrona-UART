library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER is
    Port ( 
        CLK   : in STD_LOGIC;
        RST   : in STD_LOGIC;
        RTS   : in STD_LOGIC;
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
    
    signal EOT     : STD_LOGIC;  -- End Of Transmission: activated when red a Byte from tx
    signal TX_EN   : STD_LOGIC;  -- When read the signal from TX
    signal SPR_CE  : STD_LOGIC;  -- Clock enable of the serial/parallel register
    signal TX_D    : STD_LOGIC;  -- tx data after "fast" sampling
    signal NOT_TX_D: STD_LOGIC;

begin

    TX_D_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => TX,
        Q => TX_D,
        NOT_Q => NOT_TX_D
    );

    RX_EN : RX_ENABLE port map (
        CLK => CLK, 
        RST => RST,
        EOT => EOT,
        TX => TX_D,
        Z => SPR_CE
    );

    CNT_8 : COUNTER_8 port map (
        CLK => CLK, 
        RST => RST, 
        Z => EOT
    );

    CNT_OS : COUNTER_OS port map (
        CLK => CLK, 
        RST => RST, 
        Z => TX_EN
    );

    REG_SP : REG_SP_8 port map (
        CLK => CLK, 
        RST => RST,
        CE => SPR_CE,
        X => TX_D,
        Z => DOUT
    );


    reg: process(CLK, RST)
    begin
    end process;

end arch;
