library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Random_Number_8 is
    port(
        Clk 				: in std_logic;
        Rst 				: in std_logic;
        KeyIn 				: in unsigned (7 downto 0);
        reset_Number 		: in std_logic;
        RanNum 				: out unsigned (8 downto 1);
        RanNum_targetadress : out unsigned (7 downto 0));  
        
end entity Random_Number_8;

architecture RTL of Random_Number_8 is
    signal RanNumReg : unsigned (8 downto 1); 
    signal counter : integer;
    signal Target_ADDR : unsigned(7 downto 0) := "00000000";
      
begin
    process (Clk, Rst) begin
    	counter <= 8; 
        if(Rst = '0') then
            RanNumReg <= KeyIn;
        elsif(reset_Number = '1')then
        	RanNumReg <= KeyIn;
        elsif rising_edge(Clk) then 
            if( counter > 1) then
            RanNumReg(counter) <= RanNumReg(counter-1);
            counter <= counter - 1;
            end if;
            RanNumReg(1) <= RanNumReg(8) XOR RanNumReg(6) XOR RanNumReg(5) XOR RanNumReg(4);
            Target_ADDR <= Target_ADDR + 1;
        end if;
    end process;
    RanNum <= RanNumReg;    
    RanNum_targetadress <= Target_ADDR;
end architecture RTL;
