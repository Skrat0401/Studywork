library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_target_DECR_Testbench is
end mem_target_DECR_Testbench;

architecture Behavioural of mem_target_DECR_Testbench is
    type ROM_array is array (0 to 63) of unsigned (7 downto 0);
    signal T_Clk            : std_logic;
    signal T_Rst            : std_logic; 
    signal T_DATOUT_DECR	: unsigned (7 downto 0);
    signal T_DATOUT_ADDR	: unsigned (7 downto 0) := "00000000";
    signal T_Target_Data_Decr	: unsigned (7 downto 0);
    signal T_Target_Addr_Decr : unsigned (7 downto 0); 
    signal memory_source_ENCR : ROM_array := (
    0 => (to_unsigned(character'pos('A'), 8)),1 => (to_unsigned(character'pos('B'), 8)),
    2 => (to_unsigned(character'pos('C'), 8)), 3 => (to_unsigned(character'pos('D'), 8)),
    4 => (to_unsigned(character'pos('E'), 8)), 5 => (to_unsigned(character'pos('F'), 8)),
    6 => (to_unsigned(character'pos('G'), 8)),7 => (to_unsigned(character'pos('H'), 8)),
    8 => (to_unsigned(character'pos('I'), 8)), 9 => (to_unsigned(character'pos('J'), 8)),
    10 => (to_unsigned(character'pos('K'), 8)), 11 => (to_unsigned(character'pos('L'), 8)),
    12 => (to_unsigned(character'pos('M'), 8)), others => (to_unsigned(character'pos(' '), 8)));
    signal intern_ADDR : unsigned (7 downto 0) := "00000000";
    
component mem_target_DECR
        port(
            Clk     	     : in std_logic;
            Rst     	     : in std_logic; --aktive low
            DATOUT_DECR      : in unsigned(7 downto 0); 	-- Datenausgang entschlüsselte Daten
            DATOUT_ADDR      : in unsigned(7 downto 0); 	-- Adresse für entschlüsselte Daten
            Target_Data_Decr : out unsigned (7 downto 0);
            Target_Addr_Decr : in  unsigned (7 downto 0));
    end component mem_target_DECR;
  
  begin
     DUT: mem_target_DECR port map(
          Clk               => T_Clk,
          Rst               => T_Rst,
          DATOUT_DECR       => T_DATOUT_DECR,
          DATOUT_ADDR       => T_DATOUT_ADDR,
          Target_Data_Decr  => T_Target_Data_Decr,
          Target_Addr_Decr  => T_Target_Addr_Decr
      );

process (T_Clk) begin
    T_DATOUT_DECR <= memory_source_ENCR(to_integer(intern_ADDR));
    T_DATOUT_ADDR <= T_DATOUT_ADDR + 1;
    intern_ADDR   <= intern_ADDR + 1;
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
     wait for 10 ns;
     T_Clk <= '1';
     wait for 10 ns;
  end process count;

end Behavioural;