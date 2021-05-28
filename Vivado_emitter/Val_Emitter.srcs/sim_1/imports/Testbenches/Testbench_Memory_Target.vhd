library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_Memory_Target is
end entity Testbench_Memory_Target;

architecture RTL of Testbench_Memory_Target is

    type ROM_array is array (0 to 63) of unsigned(7 downto 0);
    signal T_Clk            : std_logic;
    signal intern_ADDR      : unsigned(7 downto 0) := "00000000";
    signal T_Target_EN_ADDR : unsigned(7 downto 0) := "00000000";
    signal T_data_in        : unsigned(7 downto 0) := "00000000";
    signal T_output_addr    : unsigned(7 downto 0) := "00000000";
    signal T_data_out       : unsigned(7 downto 0) := "00000000";

    signal memory_source_ENCR : ROM_array := (
        0      => (to_unsigned(character'pos('A'), 8)), 1 => (to_unsigned(character'pos('B'), 8)),
        2      => (to_unsigned(character'pos('C'), 8)), 3 => (to_unsigned(character'pos('D'), 8)),
        4      => (to_unsigned(character'pos('E'), 8)), 5 => (to_unsigned(character'pos('F'), 8)),
        6      => (to_unsigned(character'pos('G'), 8)), 7 => (to_unsigned(character'pos('H'), 8)),
        8      => (to_unsigned(character'pos('I'), 8)), 9 => (to_unsigned(character'pos('J'), 8)),
        10     => (to_unsigned(character'pos('K'), 8)), 11 => (to_unsigned(character'pos('L'), 8)),
        12     => (to_unsigned(character'pos('M'), 8)), others => (to_unsigned(character'pos(' '), 8)));

    component memory_target
        port(
            Clk            : in  std_logic;
            Target_EN_ADDR : in  unsigned(7 downto 0);
            data_in        : in  unsigned(7 downto 0);
            output_addr    : in  unsigned(7 downto 0);
            data_out       : out unsigned(7 downto 0)
        );
    end component memory_target;

begin
    DUT : component memory_target
        port map(
            Clk            => T_Clk,
            Target_EN_ADDR => T_Target_EN_ADDR,
            data_in        => T_data_in,
            output_addr    => T_output_addr,
            data_out       => T_data_out
        );

    input : process(T_Clk)
    begin
        if (rising_edge(T_Clk)) then
            if (intern_ADDR < 64) then
                T_data_in        <= memory_source_ENCR(to_integer(intern_ADDR));
                T_Target_EN_ADDR <= T_Target_EN_ADDR + 1;
                intern_ADDR      <= intern_ADDR + 1;
            end if;
        end if;
    end process input;

    output : process(T_Clk)
    begin
        if (intern_ADDR > 63) then
            if (rising_edge(T_Clk)) then
                T_output_addr <= T_output_addr + 1;
            end if;
        end if;
    end process output;

    count : process
    begin
        T_Clk <= '0';
        wait for 10 ns;
        T_Clk <= '1';
        wait for 10 ns;
    end process count;

end architecture RTL;
