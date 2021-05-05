library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity comparator_mem is
    port(
        Current_ADDR : in  unsigned(7 downto 0);
        Current_DATA : out unsigned(7 downto 0);
        Clk          : in  std_logic);
end comparator_mem;

architecture RTL of comparator_mem is

    type ROM_array is array (0 to 63) of unsigned(7 downto 0);

    signal current_mem : ROM_array := (
        0      => (to_unsigned(character'pos('A'), 8)), 1 => (to_unsigned(character'pos('B'), 8)),
        2      => (to_unsigned(character'pos('C'), 8)), 3 => (to_unsigned(character'pos('D'), 8)),
        4      => (to_unsigned(character'pos('E'), 8)), 5 => (to_unsigned(character'pos('F'), 8)),
        6      => (to_unsigned(character'pos('G'), 8)), 7 => (to_unsigned(character'pos('H'), 8)),
        8      => (to_unsigned(character'pos('I'), 8)), 9 => (to_unsigned(character'pos('J'), 8)),
        10     => (to_unsigned(character'pos('K'), 8)), 11 => (to_unsigned(character'pos('L'), 8)),
        12     => (to_unsigned(character'pos('M'), 8)), others => (to_unsigned(character'pos(' '), 8)));

begin
    process(Clk)
    begin
        if (rising_edge(Clk)) then
            Current_DATA <= current_mem(to_integer(unsigned(Current_ADDR)));
        end if;
    end process;
end RTL;
