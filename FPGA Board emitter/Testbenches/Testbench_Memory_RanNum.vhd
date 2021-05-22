library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_Memory_RanNum is
end entity Testbench_Memory_RanNum;

architecture RTL of Testbench_Memory_RanNum is

    type ROM_array is array (0 to 63) of unsigned(7 downto 0);
    signal T_Clk                : std_logic;
    signal T_Rst                : std_logic;
    signal T_Target_ADDR_rannum : unsigned(7 downto 0);
    signal T_randnum_in         : unsigned(7 downto 0);
    signal T_Output_ADDR_rannum : unsigned(7 downto 0);
    signal T_rannum_out         : unsigned(7 downto 0);
    signal T_fullcounter        : std_logic;
    signal intern_ADDR          : unsigned(7 downto 0) := "00000000";

    signal memory_source_ENCR : ROM_array := (
        0      => (to_unsigned(character'pos('A'), 8)), 1 => (to_unsigned(character'pos('B'), 8)),
        2      => (to_unsigned(character'pos('C'), 8)), 3 => (to_unsigned(character'pos('D'), 8)),
        4      => (to_unsigned(character'pos('E'), 8)), 5 => (to_unsigned(character'pos('F'), 8)),
        6      => (to_unsigned(character'pos('G'), 8)), 7 => (to_unsigned(character'pos('H'), 8)),
        8      => (to_unsigned(character'pos('I'), 8)), 9 => (to_unsigned(character'pos('J'), 8)),
        10     => (to_unsigned(character'pos('K'), 8)), 11 => (to_unsigned(character'pos('L'), 8)),
        12     => (to_unsigned(character'pos('M'), 8)), others => (to_unsigned(character'pos(' '), 8)));

    component memory_randnum
        port(
            Clk                : in  std_logic;
            Rst                : in  std_logic;
            Target_ADDR_rannum : in  unsigned(7 downto 0);
            randnum_in         : in  unsigned(7 downto 0);
            Output_ADDR_rannum : in  unsigned(7 downto 0);
            rannum_out         : out unsigned(7 downto 0);
            fullcounter        : out std_logic
        );
    end component memory_randnum;

begin
    DUT : component memory_randnum
        port map(
            Clk                => T_Clk,
            Rst                => T_Rst,
            Target_ADDR_rannum => T_Target_ADDR_rannum,
            randnum_in         => T_randnum_in,
            Output_ADDR_rannum => T_Output_ADDR_rannum,
            rannum_out         => T_rannum_out,
            fullcounter        => T_fullcounter
        );

    input : process(T_Clk)
    begin
        if (rising_edge(T_Clk)) then
            T_randnum_in         <= memory_source_ENCR(to_integer(intern_ADDR));
            T_Target_ADDR_rannum <= T_Target_ADDR_rannum + 1;
            intern_ADDR          <= intern_ADDR + 1;
        end if;
    end process input;

    output : process(T_Clk)
    begin
        if (T_fullcounter = '1') then
            if (rising_edge(T_Clk)) then
                T_Output_ADDR_rannum <= T_Output_ADDR_rannum + 1;
            end if;
        end if;
    end process output;

    reset2 : process
    begin
        if (T_Rst = '0') then
            T_Target_ADDR_rannum <= "00000000";
            T_randnum_in         <= "00000000";
            T_Output_ADDR_rannum <= "00000000";
            T_rannum_out         <= "00000000";
            T_fullcounter        <= '0';
            intern_ADDR          <= "00000000";
        end if;
    end process reset2;

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
