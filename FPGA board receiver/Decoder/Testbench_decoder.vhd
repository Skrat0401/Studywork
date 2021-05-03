library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_decoder is

end entity testbench_decoder;

architecture RTL of testbench_decoder is
    signal T_Clk    		: std_logic;
    signal T_Rst    		: std_logic;
    signal T_enable   		: std_logic; 
    signal T_fullcounter	: std_logic;
    signal T_ADDR      		: std_logic_vector(7 downto 0);
    signal T_DATOUT_DECR	: std_logic_vector(7 downto 0);
    signal T_DATOUT_ADDR	: std_logic_vector(7 downto 0);
    signal T_DATIN_ENCR		: std_logic_vector(7 downto 0);
    signal T_DATIN_ADDR		: std_logic_vector(7 downto 0);
   
    
component decoder
        port(
            Clk     	: in std_logic;
            Rst     	: in std_logic; --aktive low
            enable  	: in std_logic; --switch r2 
            fullcounter : in std_logic; --signalisiert Speicher ist voll
            ADDR		: in std_logic;
            DATOUT_DECR : out std_logic_vector(7 downto 0); 	-- Datenausgang entschlüsselte Daten
            DATOUT_ADDR : out std_logic_vector(7 downto 0); 	-- Adresse für entschlüsselte Daten
            DATIN_ENCR  : in std_logic_vector(7 downto 0);		-- Dateneingang verschlüsselte Daten
            DATIN_ADDR  : out std_logic_vector (7 downto 0)
        	);
    end component decoder;

begin
    
  DUT: decoder port map (
        Clk 		=> T_Clk,
        Rst 		=> T_Rst,
        enable 		=> T_enable,
        fullcounter	=> T_fullcounter,
        ADDR 		=> T_ADDR,
        DATOUT_DECR => T_DATOUT_DECR,
        DATOUT_ADDR => T_DATOUT_ADDR,
        DATIN_ENCR  => T_DATIN_ENCR,
        DATIN_ADDR	=> T_DATIN_ADDR
);

T_enable 		<= '1';  
T_fullcounter 	<= '1';
T_ADDR 			<= "00000011";
T_DATIN_ADDR	<= "00000000";
T_DATIN_ENCR	<= "00000001";

 
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