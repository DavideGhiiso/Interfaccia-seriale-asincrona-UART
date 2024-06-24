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
    signal PG_EVEN: std_logic; -- even parity
begin
    PG_OUT <= ODD xor PG_EVEN;
    PG_EVEN <= (D(0) xor D(1)) xor (D(2) xor D(3))
            xor
            (D(4) xor D(5)) xor (D(6) xor D(7));
end rtl;
