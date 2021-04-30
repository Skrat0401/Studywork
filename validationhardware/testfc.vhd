----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2021 12:59:55
-- Design Name: 
-- Module Name: testfc - Behavioral
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
library std;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testfc is
Port ( output : out STD_LOGIC;
Clk : in STD_LOGIC);
end testfc;

architecture Behavioral of testfc is
signal sclock : std_logic:='0';
signal clockcounter : unsigned (18 downto 0) := (others=>'0');
signal preout : std_logic := '0';
begin
process (sclock) begin
if(rising_edge(sclock)) then
preout<= not preout;
end if;
output<= preout;
end process;
slowclock:process (Clk) begin
if(rising_edge(Clk)) then
if clockcounter < 100000 then clockcounter <= clockcounter + 1;
else
clockcounter <= "0000000000000000000";
sclock <= not sclock;
end if;
end if;
end process slowclock;

end Behavioral;