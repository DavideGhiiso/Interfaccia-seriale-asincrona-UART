library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RX_FSM_TB is
--  Port ( );
end RX_FSM_TB;

architecture arch of RX_FSM_TB is
    component RX_FSM is
        Port ( 
            CLK   : in  STD_LOGIC;
            RST   : in  STD_LOGIC;
            CE    : in  STD_LOGIC;
            TX    : in  STD_LOGIC;
            RE    : out STD_LOGIC;
            EOT   : out STD_LOGIC
        );
    end component;
    
    
    signal CLK   : STD_LOGIC;
    signal RST   : STD_LOGIC;
    signal CE    : STD_LOGIC;
    signal TX    : STD_LOGIC;
    signal RE    : STD_LOGIC;
    signal EOT   : STD_LOGIC;
    
    signal MSG   : std_logic_vector (0 to 7);
    
begin

    FSM : RX_FSM port map (
        CLK => CLK, 
        RST => RST,
        CE => CE,
        TX => TX,
        RE => RE,
        EOT => EOT
    );
    
    CLK_process :process
		begin
			CLK <= '0';
			wait for 5 ns;
			CLK <= '1';
			wait for 5 ns;
		end process;
		
    process begin
        MSG <= "10101010";
        RST <= '1';
        CE <= '0';
        wait for 10 ns;
        TX <= '1';
        wait for 15 ns;
        RST <= '0';
        wait for 10 ns;
        TX <= '0';
        CE <= '1';
        wait for 10 ns;
        for I in 0 to 7 loop
            TX <= MSG(I);
            wait for 10 ns;
        end loop;
        TX <= '1';
        wait for 5 ns;    
        CE <= '0';
        wait for 15 ns;
        RST <= '1';
        wait;
    end process;

end arch;
