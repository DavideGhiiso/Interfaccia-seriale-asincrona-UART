library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_GENERATOR is
    Port (
        D:          in  std_logic_vector (0 to 7);
        PG_EVEN:    out std_logic;
        PG_ODD:     out std_logic
    );
end PARITY_GENERATOR;

architecture rtl of PARITY_GENERATOR is
    signal RES: std_logic;
begin
    PG_EVEN <= RES;
    PG_ODD <= not RES;
    RES <=    (D(0) xor D(1)) xor (D(2) xor D(3))
            xor
            (D(4) xor D(5)) xor (D(6) xor D(7));
end rtl;
