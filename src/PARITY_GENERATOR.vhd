library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_GENERATOR is
    Port (
        D:          in  std_logic_vector (0 to 7);
        ODD:        in std_logic;
        PG_OUT:     out std_logic
    );
end PARITY_GENERATOR;

architecture rtl of PARITY_GENERATOR is
    component MUX2 is port ( 
            X0 :    in STD_LOGIC;
            X1 :    in STD_LOGIC;
            S :     in STD_LOGIC;
            Z :     out STD_LOGIC
        );
        end component;
    signal PG_EVEN: std_logic;
    signal PG_ODD: std_logic;
begin
    MUX_OUT: MUX2 port map (
        X0 => PG_EVEN,
        X1 => PG_ODD,
        S => ODD,
        Z => PG_OUT
    );
    PG_ODD <= not PG_EVEN;
    PG_EVEN <= (D(0) xor D(1)) xor (D(2) xor D(3))
            xor
            (D(4) xor D(5)) xor (D(6) xor D(7));
end rtl;
