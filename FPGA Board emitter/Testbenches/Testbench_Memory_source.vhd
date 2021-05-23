library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_Memory_source is
end entity Testbench_Memory_source;

architecture RTL of Testbench_Memory_source is

    component memory_source
        port(
            Clk         : in  std_logic;
            Source_ADDR : in  unsigned(7 downto 0);
            CDOUT       : out unsigned(7 downto 0)
        );
    end component memory_source;
    signal T_Clk         : std_logic;
    signal T_Source_ADDR : unsigned(7 downto 0) := "00000000";
    signal T_CDOUT       : unsigned(7 downto 0) := "00000000";
    signal T_Rst         : std_logic;
    signal intern_ADDR   : integer := 0;

begin

    DUT : component memory_source
        port map(
            Clk         => T_Clk,
            Source_ADDR => T_Source_ADDR,
            CDOUT       => T_CDOUT
        );

    input : process(T_Clk)
    begin
        if (rising_edge(T_Clk)) then
            if (intern_ADDR < 64) then
                T_Source_ADDR <= T_Source_ADDR + 1;
                intern_ADDR   <= intern_ADDR + 1;
            end if;
        end if;
    end process input;

    reset : process
    begin
        wait for 5 ns;
        T_Rst <= '0';
        wait for 4 ns;
        T_Rst <= '1';
        wait;
    end process reset;

    count : process
    begin
        T_Clk <= '0';
        wait for 10 ns;
        T_Clk <= '1';
        wait for 10 ns;
    end process count;

end architecture RTL;
