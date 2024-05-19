library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RECEIVER_TB is
end RECEIVER_TB;

architecture arch of RECEIVER_TB is
    component RECEIVER is
        Port ( 
            CLK   : in STD_LOGIC;
            RST   : in STD_LOGIC;
            TX    : in STD_LOGIC;
            READY : out STD_LOGIC;
            DOUT  : out STD_LOGIC_VECTOR (0 to 7)
    );
    end component;
        
    signal TX  : std_logic;
    signal CLK : std_logic;
    signal RST : std_logic;
    signal DOUT: std_logic_vector (0 to 7);
    
    signal MSG: std_logic_vector (0 to 7);
    
begin
    -- unit under test
    UUT: RECEIVER port map (
        TX => TX,
        CLK => CLK, 
        RST => RST, 
        DOUT => DOUT
    );
    
    CLK_process :process
        begin
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end process;
        
    process begin
        MSG <= "01101110";
        RST <= '1';
        wait for 15 ns;
        TX <= '1';
        wait for 15 ns;
        RST <= '0';
        wait for 5 ns;
        TX <= '0';
        wait for 40 ns;
        for I in 0 to 7 loop
            TX <= MSG(I);
            wait for 40 ns;
        end loop;    
        TX <= '1';
        wait for 80 ns;
        RST <= '1';
        wait;
    end process;

end arch;