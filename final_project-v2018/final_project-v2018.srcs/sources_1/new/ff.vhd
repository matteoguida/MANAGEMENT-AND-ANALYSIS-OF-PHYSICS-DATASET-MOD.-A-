----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2018 04:07:51 PM
-- Design Name: 
-- Module Name: ff - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ffd is
    generic(N      : integer := 16);
    Port ( D : in std_logic_vector(N-1 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Q : out std_logic_vector(N-1 downto 0));
end ffd;

architecture Behavioral of ffd is

begin

p_ff : process(D, clk, rst) is
    begin
    if rst = '1' then
        Q <= (others => '0');
    elsif rising_edge(clk) then
        Q <= D;
    end if;
end process;


end Behavioral;
