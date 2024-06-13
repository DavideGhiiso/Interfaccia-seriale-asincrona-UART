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
    
    signal ONE      : STD_LOGIC;
    signal TX_D     : STD_LOGIC;  -- tx data after "fast" sampling
    signal RST_CNT  : STD_LOGIC;
    signal SOT      : STD_LOGIC;
    signal SAMPLE   : STD_LOGIC;
    signal CNT_EN   : STD_LOGIC;  -- enable sampling of TX
    signal BYTE_RECV: STD_LOGIC;  -- End Of Transmission
    signal EOT      : STD_LOGIC;  -- End Of Transmission

begin

    TX_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => TX,
        Q => TX_D
    );

    CNT_OS : COUNTER_OS port map ( -- fast counter (used for sampling)
        CE => CNT_EN,
        CLK => CLK, 
        RST => RST_CNT, 
        Z => SAMPLE
    );
    
    CNT_8 : COUNTER_8 port map ( -- fast counter (used for sampling)
        CE => ONE,
        CLK => SAMPLE, 
        RST => RST_CNT, 
        Z => BYTE_RECV
    );

    REG_SP : REG_SP_8 port map (
        CLK => SAMPLE, 
        RST => RST,
        CE => SOT,
        X => TX_D,
        Z => DOUT
    );
    
    ONE <= '1';
    
    p_eot: process(SAMPLE, BYTE_RECV, SOT)
    begin 
        if (RST = '1') then EOT <= '1';
        elsif (SAMPLE'event and SAMPLE = '1') then EOT <= BYTE_RECV;
        elsif (SOT = '1') then EOT <= '0';
        end if;
    end process;
    
    reg: process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then 
                SOT <= '0';
                CNT_EN <= '1';
            else
                SOT <= '0' when BYTE_RECV = '1' else
                       '1' when TX_D = '0' and EOT = '1';
                CNT_EN <= BYTE_RECV or SOT;
            end if;
            RST_CNT <= (SAMPLE and EOT) or RST;
        end if;
    end process;
    
        
    p_ready: process(SAMPLE, BYTE_RECV, SOT)
    begin 
        if (RST = '1') then READY <= '0';
        else READY <= SAMPLE and BYTE_RECV and SOT;
        end if;
    end process;

end arch;
