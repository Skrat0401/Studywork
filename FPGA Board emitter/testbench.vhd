library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is

end entity testbench;

architecture RTL of testbench is
    signal T_Clk    :  std_logic;
    signal T_Rst    :  std_logic;
    signal T_enable   :   std_logic;
    signal T_sw       :   std_logic_vector(8 downto 1);
    signal T_output   : std_logic;
    
   component electricity_cipher
        port(
            Clk    : in  std_logic;
            Rst    : in  std_logic;
            enable : in  std_logic;
            sw     : in  std_logic_vector(8 downto 1);
            output : out std_logic
        );
    end component electricity_cipher;

begin
    
  DUT: electricity_cipher port map (
        Clk => T_Clk,
        Rst => T_Rst,
        enable => T_enable,
        sw => T_sw,
        output => T_output        
);


T_sw <= "00000000";
 en : process 
  begin
     wait for 5 ns; T_enable <= '0';
     wait for 4 ns; T_enable <= '1';
     wait;
  end process en;
reset : process 
  begin
     wait for 5 ns; T_Rst <= '0';
     wait for 4 ns; T_Rst <= '1';
     wait;
  end process reset;

count: process 
    begin
     T_Clk <= '0';
     wait for 5 ns;
     T_Clk <= '1';
     wait for 5 ns;
 end process count;
         
      
end architecture RTL;