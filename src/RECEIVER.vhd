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
    
    component MUX2 is
        Port ( 
            X :     in STD_LOGIC;
            Y :     in STD_LOGIC;
            S :     in STD_LOGIC;
            Z :     out STD_LOGIC
        );
    end component;
    
    component JK_FF is
        Port ( 
            J   : in STD_LOGIC;
            K   : in STD_LOGIC;
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            Z   : out STD_LOGIC;
            NZ  : out STD_LOGIC
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
    signal RX_D     : STD_LOGIC;  -- rx data after "fast" sampling
    signal RST_CNT  : STD_LOGIC;
    signal SOT      : STD_LOGIC;  -- Start Of Transmission
    signal NSOT     : STD_LOGIC;
    signal SAMPLE   : STD_LOGIC;
    signal CNT_EN   : STD_LOGIC;  -- enable sampling of rx
    signal EOB      : STD_LOGIC;  -- End Of Byte
    signal EOT      : STD_LOGIC;  -- End Of Transmission
    
    signal J        : STD_LOGIC;
    signal SAMPLE_EDGE : STD_LOGIC;
    signal T_CTS    : STD_LOGIC;
    signal T_READY  : STD_LOGIC;

begin

    RX_FF : D_FF port map (
        CLK => CLK, 
        RST => RST,
        D => RX,
        Q => RX_D
    );
    
--    EOT_MUX : MUX2 port map (
--        S => SAMPLE_EDGE, 
--        X => NSOT,
--        Y => EOB,
--        Z => EOT
--    );
    
    SOT_FF : JK_FF port map (
        CLK => CLK, 
        RST => RST,
        J => J,
        K => EOB,
        Z => SOT,
        NZ => NSOT
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
        Z => EOB
    );

    REG_SP : REG_SP_8 port map (
        CLK => SAMPLE, 
        RST => RST,
        CE => SOT,
        X => RX_D,
        Z => DOUT
    );
    
    ONE <= '1';
    J <= EOT and not RX_D;
    CTS <= T_CTS;
    READY <= T_READY;
    
    p_eot: process(SAMPLE, EOB, SOT)
    begin 
        if (RST = '1') then EOT <= '1';
        elsif (SAMPLE'event and SAMPLE = '1') then EOT <= EOB;
        elsif (SOT = '1') then EOT <= '0';
        end if;
    end process;
    
    reg: process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1') then
                CNT_EN <= '1';
            else
                CNT_EN <= EOB or SOT;
            end if;
            RST_CNT <= (SAMPLE and EOT) or RST;
        end if;
    end process;
    
        
    p_out: process(CLK, SAMPLE, EOB, SOT)
    begin 
        if (RST = '1') then 
            T_READY <= '0';
            T_CTS <= '0';
        elsif (CLK'event and CLK = '1') then 
            T_READY <= '1' when T_CTS = '0' and T_READY = '0' else '0'; --SAMPLE and BYTE_RECV and SOT
            T_CTS <= not (SAMPLE and EOB and SOT);
        end if;
    end process;

end arch;
