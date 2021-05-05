library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity Testbench_Vergleicher is
end Testbench_Vergleicher;

architecture Behavioral of Testbench_Vergleicher is
 signal T_Clk    		    : std_logic;
 signal T_fullcounter_DECR  : std_logic;
 signal T_ADDR_DECR         : unsigned(7 downto 0);
 signal T_DATA_DECR         : unsigned(7 downto 0);
 signal T_Rst               : std_logic;
 signal T_ADDR_current_mem  : unsigned(7 downto 0);
 signal T_DATA_current_mem  : unsigned(7 downto 0);
 signal T_success_flag      : std_logic;
 type RAM_array is array(0 to 63) of unsigned(7 downto 0);
 
 signal target_mem : RAM_array := (
    0 => (to_unsigned(character'pos('A'), 8)),1 => (to_unsigned(character'pos('B'), 8)),
    2 => (to_unsigned(character'pos('C'), 8)), 3 => (to_unsigned(character'pos('D'), 8)),
    4 => (to_unsigned(character'pos('E'), 8)), 5 => (to_unsigned(character'pos('F'), 8)),
    6 => (to_unsigned(character'pos('G'), 8)),7 => (to_unsigned(character'pos('H'), 8)),
    8 => (to_unsigned(character'pos('I'), 8)), 9 => (to_unsigned(character'pos('J'), 8)),
    10 => (to_unsigned(character'pos('K'), 8)), 11 => (to_unsigned(character'pos('L'), 8)),
    12 => (to_unsigned(character'pos('M'), 8)), others => (to_unsigned(character'pos(' '), 8)));
    
component ROMKey
    port ( 
        Current_ADDR : in unsigned(7 downto 0);
        Current_DATA : out unsigned( 7 downto 0);
        Clk          : in std_logic);
    end component ROMKey;
    
component Vergleicher
        port(
               ADDR_DECR          : out unsigned(7 downto 0);
               DATA_DECR          : in unsigned(7 downto 0);
               Clk                : in STD_LOGIC;
               Rst                : in STD_LOGIC;
               fullcounter_DECR   : in STD_LOGIC;
               ADDR_current_mem   : out unsigned(7 downto 0);
               DATA_current_mem   : in unsigned(7 downto 0);
               success_flag       : out STD_LOGIC
             );
end component Vergleicher;

begin
    
  DUT: Vergleicher port map (
        Clk 		=> T_Clk,
        Rst 		=> T_Rst,
        fullcounter_DECR  => T_fullcounter_DECR,
        ADDR_DECR	      => T_ADDR_DECR,
        DATA_DECR         => T_DATA_DECR,
        DATA_current_mem  => T_DATA_current_mem,
        ADDR_current_mem  => T_ADDR_current_mem,
        success_flag      => T_success_flag
                            );
   DUT2: ROMKey port map (
        Current_ADDR => T_ADDR_current_mem,
        Current_DATA => T_DATA_current_mem,
        Clk          => T_Clk
        );
        
T_fullcounter_DECR <= '1';

process (T_Clk) 
begin
    if(rising_edge(T_Clk)) then
    T_DATA_DECR <= target_mem(to_integer(T_ADDR_DECR));
    end if;
end process;



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

end Behavioral;
