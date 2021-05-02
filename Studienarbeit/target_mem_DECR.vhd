
    --- Speicher für entschlüsselte Daten
    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity target_mem_DECR is                                  
        port ( Clk    : in  std_logic;
               Target_DE_ADDR : in  unsigned (7 downto 0); 
               DATIN_DECR : in  unsigned (7 downto 0)); 
    end target_mem_DECR;  
            
    architecture RTL of target_mem_DECR is
        
     -- Array 32 Durchgänge, 8 Bit Breite
     type RAM_array is array(0 to 63) of unsigned(7 downto 0);
             
    signal memory_DECR : RAM_array  := (others => "00000000");   
    signal intern_ADDR : integer;    
     begin       
      process (Clk) begin
        if(rising_edge(Clk))then
          intern_ADDR <= to_integer(Target_DE_ADDR);
          if(intern_ADDR > 1)then
          memory_DECR(intern_ADDR-2) <= DATIN_DECR;
          end if;
         end if; 
      end process;
    end RTL;
    