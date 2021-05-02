library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench_Encrypt is

end entity Testbench_Encrypt;

architecture RTL of Testbench_Encrypt is
    signal T_Clk        : std_logic;
    signal T_Rst        : std_logic;
    signal T_ADDRKey    : std_logic_vector(7 downto 0);
    
    component electricity_cipher
        port(
            Clk     : in std_logic;
            Rst     : in std_logic;
            ADDRKey : in std_logic_vector(7 downto 0)
        );
    end component electricity_cipher;
begin
    
  DUT: electricity_cipher port map (
        Clk => T_Clk, 
        Rst => T_Rst, 
        ADDRKey => T_ADDRKey);

   T_ADDRKey <= "00000101";   
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
         
      
end architecture RTL;
