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
    
    component EDGE_SEEKER is
    Port ( 
        RST : in  STD_LOGIC;
        X   : in  STD_LOGIC;
        Z   : out STD_LOGIC
    );
end component;

    component RX_FSM is
        Port ( 
            CLK   : in  STD_LOGIC;
            RST   : in  STD_LOGIC;
            CE    : in  STD_LOGIC;
            TX    : in  STD_LOGIC;
            RE    : out STD_LOGIC;
            EOT   : out STD_LOGIC
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
    signal EDGE_EN  : STD_LOGIC;
    signal NOT_READ : STD_LOGIC;
    signal READ     : STD_LOGIC;
    signal SAMPLE   : STD_LOGIC;
    signal RE       : STD_LOGIC;  -- enable sampling of TX
    signal EOT      : STD_LOGIC;  -- End Of Transmission

begin

    TX_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => TX,
        Q => TX_D
    );
    
    ED_SEK : EDGE_SEEKER port map ( 
        RST => EDGE_EN,
        X => TX_D,
        Z => READ
    );

    FSM : RX_FSM port map (
        CLK => SAMPLE, 
        RST => RST,
        CE => READ,
        TX => TX_D,
        RE => RE,
        EOT => EOT
    );

    CNT : COUNTER_8 port map ( -- fast counter (used for sampling)
        CLK => CLK, 
        RST => NOT_READ, 
        Z => SAMPLE
    );

    REG_SP : REG_SP_8 port map (
        CLK => SAMPLE, 
        RST => RST,
        CE => RE,
        X => TX_D,
        Z => DOUT
    );
    
    reg: process(CLK)
    begin
        NOT_READ <= not READ;
        if (CLK'event and CLK = '1') then
            EDGE_EN <= RST or EOT;
            READY <= SAMPLE and EOT;
            --READY <= EOT;
        end if;
    end process;

end arch;
