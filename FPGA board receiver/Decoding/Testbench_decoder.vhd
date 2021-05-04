library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_decoder is

end entity testbench_decoder;

architecture RTL of testbench_decoder is
    type ROM_array is array (0 to 63) of unsigned (7 downto 0);
    type RAM_array is array(0 to 63) of unsigned(7 downto 0);
    signal T_Clk    		: std_logic;
    signal T_Rst    		: std_logic;
    signal T_enable   		: std_logic; 
    signal T_fullcounter	: std_logic;
    signal T_ADDR      		: std_logic_vector(7 downto 0);
    signal T_DATOUT_DECR	: unsigned(7 downto 0);
    signal T_DATOUT_ADDR	: unsigned(7 downto 0);
    signal T_DATIN_ENCR		: unsigned(7 downto 0);
    signal T_DATIN_ADDR		: unsigned(7 downto 0);
    signal memory_source_ENCR : ROM_array := (
    0 => (to_unsigned(character'pos('A'), 8)),1 => (to_unsigned(character'pos('B'), 8)),
    2 => (to_unsigned(character'pos('C'), 8)), 3 => (to_unsigned(character'pos('D'), 8)),
    4 => (to_unsigned(character'pos('E'), 8)), 5 => (to_unsigned(character'pos('F'), 8)),
    6 => (to_unsigned(character'pos('G'), 8)),7 => (to_unsigned(character'pos('H'), 8)),
    8 => (to_unsigned(character'pos('I'), 8)), 9 => (to_unsigned(character'pos('J'), 8)),
    10 => (to_unsigned(character'pos('K'), 8)), 11 => (to_unsigned(character'pos('L'), 8)),
    12 => (to_unsigned(character'pos('M'), 8)), others => (to_unsigned(character'pos(' '), 8)));
    signal memory_DECR : RAM_array  := (others => "00000000");   
    --signal intern_ADDR : integer;  

component decoder
        port(
            Clk     	: in std_logic;
            Rst     	: in std_logic; --aktive low
            enable  	: in std_logic; --switch r2 
            fullcounter : in std_logic; --signalisiert Speicher ist voll
            ADDR_Key    : in  std_logic_vector(7 downto 0);
            DATOUT_DECR : out unsigned(7 downto 0); 	-- Datenausgang entschlüsselte Daten
            DATOUT_ADDR : out unsigned(7 downto 0); 	-- Adresse für entschlüsselte Daten
            DATIN_ENCR  : in  unsigned(7 downto 0);		-- Dateneingang verschlüsselte Daten
            DATIN_ADDR  : out unsigned (7 downto 0)
        	);
    end component decoder;

begin
    
  DUT: decoder port map (
        Clk 		=> T_Clk,
        Rst 		=> T_Rst,
        enable 		=> T_enable,
        fullcounter	=> T_fullcounter,
        ADDR_Key	=> T_ADDR,
        DATOUT_DECR => T_DATOUT_DECR,
        DATOUT_ADDR => T_DATOUT_ADDR,
        DATIN_ENCR  => T_DATIN_ENCR,
        DATIN_ADDR	=> T_DATIN_ADDR
);

T_fullcounter 	<= '1';
T_ADDR 			<= "00000011";

    process (T_Clk) begin
    T_DATIN_ENCR <= memory_source_ENCR(to_integer(T_DATIN_ADDR));
    end process;

process (T_Clk) begin
        if(rising_edge(T_Clk))then
          --intern_ADDR <= to_integer(T_DATOUT_ADDR);
          if(T_DATOUT_ADDR > 0)then
          memory_DECR (to_integer(T_DATOUT_ADDR-1)) <= T_DATOUT_DECR;
          --elsif (T_DATOUT_ADDR = 0)then
          --memory_DECR (to_integer(T_DATOUT_ADDR)) <= T_DATOUT_DECR;
        end if; 
        end if;
end process;

enable : process 
  begin
     T_enable <= '0';
     wait for 50 ns; T_enable <= '1';
     wait;
  end process enable;

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