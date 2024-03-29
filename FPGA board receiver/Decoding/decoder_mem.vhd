
--- Speicher f�r entschl�sselte Daten
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_mem is
    port(Clk              : in  std_logic;
         Rst              : in  std_logic;
         DATOUT_DECR      : in  unsigned(7 downto 0);
         DATOUT_ADDR      : in  unsigned(7 downto 0);
         Target_Data_Decr : out unsigned(7 downto 0);
         Target_Addr_Decr : in  unsigned(7 downto 0);
         fullcounter_DECR : out std_logic
        );
end decoder_mem;

architecture RTL of decoder_mem is

    -- Array 32 Durchg�nge, 8 Bit Breite
    type RAM_array is array (0 to 63) of unsigned(7 downto 0);

    signal memory_DECR : RAM_array := (others => "00000000");

begin

    process(Clk, Rst)
    begin
        if (Rst = '0') then
            memory_DECR      <= (others => "00000000");
            Target_Data_Decr <= "00000000";
            fullcounter_DECR <= '0';
        elsif (rising_edge(Clk)) then
            if (DATOUT_ADDR > "00111111") then
                fullcounter_DECR <= '1';
            end if;
            Target_Data_Decr <= memory_DECR(to_integer(Target_Addr_Decr));
            if (DATOUT_ADDR > 1) then
                memory_DECR(to_integer(DATOUT_ADDR - 2)) <= DATOUT_DECR;
                -- elsif (DATOUT_ADDR = 0) then
                --    memory_DECR(to_integer(DATOUT_ADDR)) <= DATOUT_DECR;
            end if;
        end if;
    end process;

end RTL;
