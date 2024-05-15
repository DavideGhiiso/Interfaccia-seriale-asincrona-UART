library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF_TB is
end D_FF_TB;

architecture Behavioral of D_FF_TB is
    component D_FF is
        port (
            CLK:    in  std_logic;
            D:      in  std_logic;
            RST:    in  std_logic;
            Q:      out std_logic;
            NOT_Q:  out std_logic
        );
    end component;
    signal CLK, D, RST, Q, NOT_Q: std_logic;
    
begin
    -- unit under test
    UUT: D_FF port map (CLK, D, RST, Q, NOT_Q);
    
    CLK_process :process
		begin
			CLK <= '0';
			wait for 15 ns;
			CLK <= '1';
			wait for 15 ns;
		end process;
    process begin
        D <= '0';
        RST <= '1';
        wait for 20ns;
        RST <= '0';
        D <= '1';
        wait for 20ns;
        D <= '0';
        wait for 40ns;
        D <= '1';
        wait for 50ns;
        D <= '0';
        wait;
    end process;
end Behavioral;
