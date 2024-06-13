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


entity MUX2 is
    Port ( 
        X :     in STD_LOGIC;
        Y :     in STD_LOGIC;
        S :     in STD_LOGIC;
        Z :     out STD_LOGIC
    );
end MUX2;

architecture Behavioral of MUX2 is

begin
    Z <= (X and (not S)) or (Y and S);
end Behavioral;
