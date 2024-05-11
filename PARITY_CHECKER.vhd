----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2024 11:18:22
-- Design Name: 
-- Module Name: FSM_PARITY_CHECKER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PARITY_CHECKER is
    Port ( X   : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Z   : out STD_LOGIC_VECTOR (0 to 1)
    );
end PARITY_CHECKER;

architecture Behavioral of PARITY_CHECKER is
type STATUS is (EVEN, ODD);
signal PS, NS : STATUS;
signal Y : STD_LOGIC_VECTOR;

begin
-- next state and output
delta_lambda: process(X, PS) 
begin
    NS <= ODD when PS = EVEN and X = '1' else
          ODD when PS = ODD and X = '0' else
          EVEN;
    if PS = EVEN then Y <= "01";
    else Y <= "10";
    end if;
end process;

-- state and output register
state_output: process(CLK)
begin
    if (CLK'event and CLK = '1') then
        if (RST = '1') then 
            PS <= EVEN;
            Z <= "01";
        else 
            PS <= NS;
            Z <= Y;
        end if;
    end if;
end process;

end Behavioral;
