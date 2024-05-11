library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK_DIVIDER_8 is
    Port (
        CLK:    in  std_logic;
        RST:    in std_logic;
        CLK_8:  out std_logic
    );
end CLK_DIVIDER_8;

architecture structural of CLK_DIVIDER_8 is
    component D_FF is
        port (
            CLK:    in  std_logic;
            D:      in  std_logic;
            RST:    in  std_logic;
            Q:      out std_logic;
            NOT_Q:  out std_logic
        );
    end component;
    signal L0, L1, L2, CLK_2, CLK_4: std_logic;
    begin
        FF0: D_FF port map (
            CLK => CLK,
            NOT_Q => L0,
            D => L0,
            RST => RST,
            Q => CLK_2
        );
        FF1: D_FF port map (
            CLK => CLK_2,
            NOT_Q => L1,
            D => L1,
            RST => RST,
            Q => CLK_4
        );
        FF2: D_FF port map (
            CLK => CLK_4,
            NOT_Q => L2,
            D => L2,
            RST => RST,
            Q => CLK_8
        );
end structural;
