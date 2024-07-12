library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRANSMITTER is
    Port (
        DIN:    in  std_logic_vector (0 to 7);
        START:  in  std_logic;
        CTS:    in  std_logic;
        LEN:    in  std_logic;
        PARITY: in  std_logic;
        CLK:    in  std_logic;
        RST:    in  std_logic;
        TX:     out std_logic
    );
end TRANSMITTER;

architecture Behavioral of TRANSMITTER is
    component D_FF is port (
        RST:    in  std_logic;
        SET:    in  std_logic;
        CLK:    in  std_logic;
        CE:     in  std_logic;
        D:      in  std_logic;
        Q:      out std_logic;
        NOT_Q:  out std_logic
    );
    end component;
    component MUX2 is port ( 
        X0 :    in STD_LOGIC;
        X1 :    in STD_LOGIC;
        S :     in STD_LOGIC;
        Z :     out STD_LOGIC
    );
    end component;
    component FREQ_DIVIDER_8 is port (
            CLK:    in  std_logic;
            RST:    in  std_logic;
            CLK_8:  out std_logic
    );
    end component;
    component REG_PS_8 is port (
            CLK:        in  std_logic;
            LOAD:       in  std_logic;
            CE:         in  std_logic;
            RST:        in  std_logic;
            X:          in  std_logic_vector (0 to 7);
            Z:          out std_logic
    );
    end component;
    component REG_PP_8 is 
    Port (
        CLK:    in  std_logic;
        RST:    in  std_logic;
        CE:     in std_logic;
        X:      in  std_logic_vector(0 to 7);
        Z:      out std_logic_vector(0 to 7)
    );
    end component;
    component PARITY_GENERATOR is port (
        D:          in  std_logic_vector (0 to 7);
        ODD:        in std_logic;
        PG_OUT:     out std_logic
    );
    end component;
    signal  START_BUF,      -- start signal buffer
            CTS_BUF,        -- CTS signal buffer
            LEN_BUF,        -- LEN signal buffer
            PARITY_BUF,     -- PARITY signal buffer
            TX_ENABLE_BUF,  -- TX_ENABLE signal buffer
            CLK_8,          -- clk divider out signal
            TX_ENABLE,      -- signal that starts transmission
            PG_OUT,         -- parity multiplexer out
            REG_OUT,        -- register out
            TX_REG_OUT,     -- register multiplexer out
            LB,             -- len multiplexer out (last bit)
            LB_BUF,         -- last bit buffer
            REG_PP_DIN_BUF_CE: std_logic; -- clock enable for DIN buffer 
            
    signal  DIN_BUF,        -- DIN signal buffer
            D: std_logic_vector (0 to 7); -- P/S8 in signal
begin
    TX_ENABLE <= START_BUF and CTS_BUF;
    D <= DIN_BUF(0 to 6) & LB_BUF;
    REG_PP_DIN_BUF_CE <= CLK_8 and not TX_ENABLE;
    
    FREQ_DIVIDER: FREQ_DIVIDER_8 port map (
        CLK => CLK,
        RST => RST,
        CLK_8 => CLK_8
    );
    FF_START_BUF: D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => CLK_8,
        D => START,
        Q => START_BUF
    );
    FF_CTS_BUF: D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => CLK_8,
        D => CTS,
        Q => CTS_BUF
    );
    FF_LEN_BUF: D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => CLK_8,
        D => LEN,
        Q => LEN_BUF
    );
    FF_PARITY_BUF: D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => CLK_8,
        D => PARITY,
        Q => PARITY_BUF
    );
    FF_TX_BUF: D_FF port map (
        RST => '0',
        SET => RST,
        CLK => CLK,
        CE => CLK_8,
        D => TX_REG_OUT,
        Q => TX
    );
    FF_TX_ENABLE_BUF: D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => CLK_8,
        D => TX_ENABLE,
        Q => TX_ENABLE_BUF
    );
    FF_LB_BUF: D_FF port map (
        RST => RST,
        SET => '0',
        CLK => CLK,
        CE => CLK_8,
        D => LB,
        Q => LB_BUF
    );
    PG: PARITY_GENERATOR port map (
        D => DIN_BUF,
        ODD => PARITY_BUF,
        PG_OUT => PG_OUT
    );
    LEN_MUX: MUX2 port map (
        X0 => DIN_BUF(7),
        X1 => PG_OUT,
        S => LEN_BUF,
        Z => LB
    );
    REG_PS: REG_PS_8 port map (
        CLK => CLK,
        RST => RST,
        LOAD => TX_ENABLE_BUF,
        CE => CLK_8,
        X => D,
        Z => REG_OUT
    );
    REG_PP_DIN_BUF: REG_PP_8 port map (
        CLK => CLK,
        RST => RST,
        CE => REG_PP_DIN_BUF_CE,
        X => DIN,
        Z => DIN_BUF
    );
    
    TX_REG_OUT <= REG_OUT and not TX_ENABLE_BUF;
end Behavioral;
