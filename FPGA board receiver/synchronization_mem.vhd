
--- Speicher für Synchronisationsdaten
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity synchronization_mem is
    port(Clk         : in  std_logic;
         Rst         : in  std_logic;
         target_addr : in  unsigned(7 downto 0);
         data_in     : in  unsigned(7 downto 0);
         output_addr : in  unsigned(7 downto 0);
         fullcounter : out std_logic;
         data_out    : out unsigned(7 downto 0));
end synchronization_mem;

architecture RTL of synchronization_mem is

    type RAM_array is array (0 to 63) of unsigned(7 downto 0);

    signal memory_target_ENCR : RAM_array := (others => "00000000");

begin
    process(Clk)
    begin
        if (Rst = '0') then
            fullcounter <= '0';
        elsif (rising_edge(Clk)) then
            memory_target_ENCR(to_integer(target_addr)) <= data_in;
            data_out                                    <= memory_target_ENCR(to_integer(output_addr));
        end if;
        if (target_addr > "00111110") then -- max hex 3f
            fullcounter <= '1';
        end if;
    end process;
end RTL;
