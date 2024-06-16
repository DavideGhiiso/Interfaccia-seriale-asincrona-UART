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
        CLK:    in  std_logic;
        CE:     in  std_logic;
        D:      in  std_logic;
        RST:    in  std_logic;
        Q:      out std_logic;
        NOT_Q:  out std_logic
    );
    end component;
    component MUX2 is port ( 
        X :     in STD_LOGIC;
        Y :     in STD_LOGIC;
        S :     in STD_LOGIC;
        Z :     out STD_LOGIC
    );
    end component;
    component CLK_DIVIDER_8 is port (
            CLK:    in  std_logic;
            RST:    in std_logic;
            CLK_8:  out std_logic
    );
    end component;
    component REG_PS_9 is port (
            CLK:        in  std_logic;
            START:      in std_logic;
            CE:         in std_logic;
            RST:        in  std_logic;
            X:          in  std_logic_vector (0 to 8);
            Z:          out std_logic
    );
    end component;
    component TX_ENABLE_FSM is port (
            START:      in std_logic;
            CTS:        in std_logic;
            CLK:        in std_logic;
            RST:        in std_logic; 
            TX_ENABLE:  out std_logic
    );
    end component;
    component PARITY_GENERATOR is port (
        D:          in  std_logic_vector (0 to 7);
        PG_EVEN:    out std_logic;
        PG_ODD:     out std_logic
    );
    end component;
    signal  START_BUF,
            CTS_BUF,
            LEN_BUF,
            PARITY_BUF,
            CLK_8,
            TX_ENABLE,
            PG_EVEN,
            PG_ODD,
            PAR_OUT,
            REG_OUT,
            LEN_OUT: std_logic;
            
    signal D: std_logic_vector (0 to 8);
begin
    D <= DIN(0 to 6) & LEN_OUT & '0';
    CLK_DIVIDER: CLK_DIVIDER_8 port map (
        CLK => CLK,
        RST => RST,
        CLK_8 => CLK_8
    );
    FF_START_BUF: D_FF port map (
        CLK => CLK_8,
        CE => '1',
        RST => RST,
        D => START,
        Q => START_BUF
    );
    FF_CTS_BUF: D_FF port map (
        CLK => CLK_8,
        CE => '1',
        RST => RST,
        D => CTS,
        Q => CTS_BUF
    );
    FF_LEN_BUF: D_FF port map (
        CLK => CLK_8,
        CE => '1',
        RST => RST,
        D => LEN,
        Q => LEN_BUF
    );
    FF_PARITY_BUF: D_FF port map (
        CLK => CLK_8,
        CE => '1',
        RST => RST,
        D => PARITY,
        Q => PARITY_BUF
    );
    PG: PARITY_GENERATOR port map (
        D => DIN,
        PG_EVEN => PG_EVEN,
        PG_ODD => PG_ODD
    );
    PAR_MUX: MUX2 port map (
        X => PG_EVEN,
        Y => PG_ODD,
        S => PARITY_BUF,
        Z => PAR_OUT
    );
    LEN_MUX: MUX2 port map (
        X => DIN(7),
        Y => PAR_OUT,
        S => LEN_BUF,
        Z => LEN_OUT
    );
    TX_MUX: MUX2 port map (
        X => '1',
        Y => REG_OUT,
        S => TX_ENABLE,
        Z => TX
    );
    TX_EN_FSM: TX_ENABLE_FSM port map (
        START => START_BUF, 
        CTS => CTS_BUF,
        CLK => CLK_8,
        RST => RST,
        TX_ENABLE => TX_ENABLE
    );
    REG_PS: REG_PS_9 port map (
        CLK => CLK_8,
        START => START_BUF,
        CE => TX_ENABLE,
        RST => RST,
        X => D,
        Z => REG_OUT
    );
end Behavioral;
