----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2024 17:18:01
-- Design Name: 
-- Module Name: MUX2 - Behavioral
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


entity MUX4 is
    Port ( 
        X0 :     in std_logic;
        X1 :     in std_logic;
        X2 :     in std_logic;
        X3 :     in std_logic;
        S  :     in std_logic_vector (1 downto 0);
        Z  :     out std_logic
    );
end MUX4;

architecture Behavioral of MUX4 is
    begin
        with S select
            Z <=    X0 when "00",
                    X1 when "01",
                    X2 when "10",
                    X3 when "11";
end Behavioral;
