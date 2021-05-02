library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_Random_Number_8 is
end Testbench_Random_Number_8;

architecture Behavioural of Testbench_Random_Number_8 is
    signal T_Clk : std_logic;
    signal T_KeyIn : unsigned(7 downto 0);
    signal T_RanNum : unsigned(8 downto 1);
    signal T_Rst : std_logic; 
    signal T_reset_Number : std_logic;

  begin
  inst: entity work.Random_Number_8
      port map(
          Clk    => T_Clk,
          Rst    => T_Rst,
          KeyIn  => T_KeyIn,
          reset_Number =>T_reset_Number,
          RanNum => T_RanNum
      );
  T_KeyIn <= "00100101";
  reset : process 
  begin
     wait for 5 ns; T_Rst <= '0';
     wait for 4 ns; T_Rst <= '1';
     wait;
  end process reset;

  count: process 
    begin
     T_Clk <= '0';
     wait for 10 ns;
     T_Clk <= '1';
     wait for 10 ns;
  end process count;

end Behavioural;