
    --- Speicher für verschlüsselte Daten
    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity target_mem_ENCR is                                  
        port ( Clk    : in  std_logic;
               Target_EN_ADDR : in  unsigned (7 downto 0); 
               DATIN_ENCR : in  unsigned (7 downto 0); 
               DATOUT_ENCR : out unsigned (7 downto 0); 
               Source_DE_ADDR : in  unsigned(7 downto 0));    
    end target_mem_ENCR;  
            
    architecture RTL of target_mem_ENCR is
        

     type RAM_array is array(0 to 63) of unsigned(7 downto 0);

    signal memory_target_ENCR : RAM_array  := (others => "00000000");   
        
     begin       
      process (Clk) begin    
        if(rising_edge(Clk))then
          memory_target_ENCR(to_integer(Target_EN_ADDR)) <= DATIN_ENCR;
          DATOUT_ENCR <=  memory_target_ENCR(to_integer(Source_DE_ADDR));
        end if;
      end process;
    end RTL;
    