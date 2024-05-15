library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity REG_SP_8 is
    Port (
        CLK:        in  std_logic;
        CE:         in  std_logic;
        RST:        in  std_logic;
        X:          in  std_logic;
        Z:          out std_logic_vector (0 to 7)
    );
end REG_SP_8;

architecture Behavioral of REG_SP_8 is
    signal Z_buf: std_logic_vector (0 to 7); -- output buffer
begin
    reg: process(CLK, RST)
    begin
        if(CLK'event and CLK = '1') then
            if(RST = '1') then
                Z_buf <= "00000000";
            elsif(CE = '1') then
                Z_buf(0) <= X;
                for i in 0 to 6 loop
                    Z_buf(i+1) <= Z_buf(i);
                end loop; 
            end if;
        end if;
        Z <= Z_buf;
    end process;

end Behavioral;
