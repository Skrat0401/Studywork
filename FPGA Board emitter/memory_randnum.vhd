
--- Speicher für Zufallszahlen
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory_randnum is
    port(Clk                : in  std_logic;
         Rst                : in  std_logic;
         Target_ADDR_rannum : in  unsigned(7 downto 0);
         randnum_in         : in  unsigned(7 downto 0);
         Output_ADDR_rannum : in  unsigned(7 downto 0);
         rannum_out         : out unsigned(7 downto 0);
         fullcounter        : out std_logic);
end memory_randnum;

architecture RTL of memory_randnum is

    type RAM_array is array (0 to 63) of unsigned(7 downto 0);

    signal memory_target_randnum : RAM_array := (others => "00000000");

begin
    process(Clk)
    begin
        if (Rst = '0') then
            fullcounter <= '0';
        elsif (rising_edge(Clk)) then
            memory_target_randnum(to_integer(Target_ADDR_rannum)) <= randnum_in;
            rannum_out <= memory_target_randnum(to_integer(Output_ADDR_rannum));
        end if;
        if (Target_ADDR_rannum > "00111110") then -- max hex 3f
            fullcounter <= '1';
        end if;
    end process;
end RTL;
