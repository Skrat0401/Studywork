
    --- Speicher für verschlüsselte Daten
    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity memory_target is                                  
        port ( Clk              : in  std_logic;
               Target_EN_ADDR   : in  unsigned (7 downto 0); 
               data_in          : in  unsigned (7 downto 0); 
               output_addr      : in  unsigned (7 downto 0); 
               data_out         : out unsigned (7 downto 0));    
    end memory_target;  
            
    architecture RTL of memory_target is
        

     type RAM_array is array(0 to 63) of unsigned(7 downto 0);

    signal memory_target_ENCR : RAM_array  := (others => "00000000");   
        
     begin       
      process (Clk) begin    
        if(rising_edge(Clk))then
        if(Target_EN_ADDR > 0) then
          memory_target_ENCR(to_integer(Target_EN_ADDR - 1)) <= data_in;
          end if;
          data_out <=  memory_target_ENCR(to_integer(output_addr));
        end if;
      end process;
    end RTL;