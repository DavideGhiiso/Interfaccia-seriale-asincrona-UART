----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2024 12:03:14
-- Design Name: 
-- Module Name: RX_ENABLE - Behavioral
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

entity RX_ENABLE is
    Port ( TX  : in STD_LOGIC;
           EOT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Z   : out STD_LOGIC);
end RX_ENABLE;

architecture Behavioral of RX_ENABLE is
type STATUS is (W, RX);
signal PS, NS: STATUS;
signal Y: STD_LOGIC;

begin
-- next state and output
delta_lambda: process(PS, TX, EOT)
begin
    NS <= W  when PS = W and TX = '1' else
          RX when PS = W and TX = '0' else
          W  when PS = RX and EOT = '1' else
          RX when PS = RX and EOT = '0' else
          W;
    if (PS = W) then Y <= '0';
    else Y <= '1';
    end if;
end process;

-- state and output register
state_output: process(CLK)
begin
    if (CLK'event and CLK = '1') then
        if (RST = '1') then 
            PS <= W;
            Z <= '0';
        else 
            PS <= NS;
            Z <= Y;
        end if;
    end if;
end process;

end Behavioral;
