
    --- Speicher für entschlüsselte Daten
    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity Random_Number_8_mem is                                  
        port ( Clk    				: in  std_logic;
               RanNum_targetadress 	: in unsigned (7 downto 0);
               RanNum_In 			: in unsigned (7 downto 0);
               RanNum_sourceadress 	: in unsigned 	(7 downto 0);
               RanNum_Out 			: out unsigned (7 downto 0)); 
    end Random_Number_8_mem;  
            
    architecture RTL of Random_Number_8_mem is
        
     -- Array 32 Durchgänge, 8 Bit Breite
     type RAM_array is array(0 to 63) of unsigned(7 downto 0);
             
    signal Random_mem : RAM_array  := (others => "00000000");     
     begin       
       process (Clk) begin    
        if(rising_edge(Clk))then
          Random_mem(to_integer(RanNum_targetadress)) <= RanNum_In;
          RanNum_Out <=  Random_mem(to_integer(RanNum_sourceadress));
      	end if; 
      	end process;
    end RTL;
    