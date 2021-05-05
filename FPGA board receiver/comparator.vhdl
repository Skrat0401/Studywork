
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity comparator is
    Port ( ADDR_DECR          : out unsigned(7 downto 0);
           DATA_DECR          : in unsigned(7 downto 0);
           Clk                : in STD_LOGIC;
           Rst                : in STD_LOGIC;
           fullcounter_DECR   : in std_logic;
           ADDR_current_mem   : out unsigned(7 downto 0);
           DATA_current_mem   : in unsigned(7 downto 0);
           success_flag       : out STD_LOGIC);
end comparator;
 
architecture Behavioral of comparator is
    signal counter          : integer;
    signal int_DECR_ADDR    : unsigned(7 downto 0):= "00000000";
    signal int_Current_ADDR : unsigned(7 downto 0):= "00000000";
 
begin
Vergleicher: process(Clk,Rst) begin

    if(Rst = '0') then
        ADDR_DECR         <= "00000000";
        ADDR_current_mem  <= "00000000";
        int_DECR_ADDR         <= "00000000";
        int_Current_ADDR      <= "00000000";
        counter <= 0;
        success_flag <= '0';
    end if;  
    if(fullcounter_DECR = '1') then
    if(counter < 64) then
           		if rising_edge(Clk) then
           		ADDR_DECR        <= int_DECR_ADDR;
           		ADDR_current_mem <= int_Current_ADDR;
           		   if(int_DECR_ADDR = int_Current_ADDR) then --gleiche adresse abrufen
           		       if(DATA_current_mem = DATA_DECR) then --gleiche daten?
           		           success_flag <= '1';
           		       else 
           		           success_flag <= '0';
           		       end if;
           		   end if;
           		int_DECR_ADDR <= int_DECR_ADDR + 1;
           		int_Current_ADDR <= int_Current_ADDR +1;
           		counter <= counter + 1 ;
           		end if;
    end if;
    end if;
end process Vergleicher;
         
end Behavioral;
