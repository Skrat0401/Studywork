library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_RanNum is
end entity Testbench_RanNum;

architecture RTL of Testbench_RanNum is

    component Random_Number_8
        port(
            Clk             : in  std_logic;
            Rst             : in  std_logic;
            KeyIn           : in  unsigned(7 downto 0);
            reset_Number    : in  std_logic;
            RanNum          : out unsigned(8 downto 1);
            RanNum_ADDR_out : out unsigned(7 downto 0)
        );
    end component Random_Number_8;

    signal T_Clk             : std_logic;
    signal T_Rst             : std_logic;
    signal T_KeyIn           : unsigned(7 downto 0);
    signal T_reset_Number    : std_logic;
    signal T_RanNum          : unsigned(8 downto 1);
    signal T_RanNum_ADDR_out : unsigned(7 downto 0);

begin

    DUT : component Random_Number_8
        port map(
            Clk             => T_Clk,
            Rst             => T_Rst,
            KeyIn           => T_KeyIn,
            reset_Number    => T_reset_Number,
            RanNum          => T_RanNum,
            RanNum_ADDR_out => T_RanNum_ADDR_out
        );
    
    T_KeyIn <= "00101101";
    T_reset_Number <= '0';
    
    reset : process
    begin
        wait for 5 ns;
        T_Rst <= '0';
        wait for 4 ns;
        T_Rst <= '1';
        wait for 5 ns;
        T_Rst <= '0';
        wait for 4 ns;
        T_Rst <= '1';
        wait;
    end process reset;

    count : process
    begin
        T_Clk <= '0';
        wait for 5 ns;
        T_Clk <= '1';
        wait for 5 ns;
    end process count;

end architecture RTL;
