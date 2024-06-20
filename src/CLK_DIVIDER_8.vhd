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
    component JK_FF is
        port (
        J   : in STD_LOGIC;
        K   : in STD_LOGIC;
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Z   : out STD_LOGIC
        );
    end component;
    
    signal CLK_2, CLK_4, CLK_8_FULL: std_logic;

begin
    FF0: JK_FF port map (
        CLK => CLK,
        RST => RST,
        J => '1',
        K => '1',
        Z => CLK_2
    );
    FF1: JK_FF port map (
        CLK => CLK_2,
        RST => RST,
        J => '1',
        K => '1',
        Z => CLK_4
    );
    FF2: JK_FF port map (
        CLK => CLK_4,
        RST => RST,
        J => '1',
        K => '1',
        Z => CLK_8_FULL
    );
    
    CLK_8 <= CLK_8_FULL and CLK_4 and CLK_2;
end structural;