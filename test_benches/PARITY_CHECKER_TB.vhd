library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PARITY_CHECKER_TB is
end PARITY_CHECKER_TB;

architecture Behavioral of PARITY_CHECKER_TB is
    component PARITY_CHECKER is
        Port ( X   : in STD_LOGIC;
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               Z   : out STD_LOGIC_VECTOR (0 to 1)
    );
    end component;
        
    signal X  : std_logic;
    signal CLK: std_logic;
	signal RST: std_logic;
	signal Z  : std_logic_vector;
	
	signal MSG: std_logic_vector (0 to 8);
	
begin
    -- unit under test
    UUT: PARITY_CHECKER port map (
        X => X,
        CLK => CLK, 
        RST => RST, 
        Z => Z
    );
    
    CLK_process :process
		begin
			CLK <= '0';
			wait for 10 ns;
			CLK <= '1';
			wait for 10 ns;
		end process;
		
    process begin
        MSG <= "01100111";
        RST <= '1';
        wait for 30 ns; -- start FSM at 30ns
        RST <= '0';
        wait for 15 ns;
        for I in 0 to 8 loop
            X <= MSG(I);
            wait for 20 ns;
        end loop;    
        RST <= '1';
        wait;
    end process;

end Behavioral;
