library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_Romkey is
end entity Testbench_Romkey;

architecture RTL of Testbench_Romkey is

    component Key
        generic(
            L_BITS : natural;
            M_BITS : natural
        );
        port(
            ADDR : in  std_logic_vector(L_BITS - 1 downto 0);
            DATA : out unsigned(M_BITS - 1 downto 0)
        );
    end component Key;

    constant L_BITS : natural := 8;
    constant M_BITS : natural := 8;
    signal T_SW     : std_logic_vector(L_BITS - 1 downto 0);
    signal T_DATA   : unsigned(M_BITS - 1 downto 0);

begin

    DUT : component Key
        generic map(
            L_BITS => L_BITS,
            M_BITS => M_BITS
        )
        port map(
            ADDR => T_SW,
            DATA => T_DATA
        );

    SW : process
    begin
        wait for 5 ns;
        T_SW <= "00000000";
        wait for 4 ns;
        T_SW <= "00000001";
        wait;
    end process SW;
end architecture RTL;
