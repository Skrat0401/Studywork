    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity source_mem_ENCR is                 
        port (Clk    : in  std_logic;
              Source_ADDR : in  unsigned(7 downto 0); 
              Source_DOUT : out unsigned(7 downto 0));        
    end source_mem_ENCR;  
            
    architecture RTL of source_mem_ENCR is
        

     type ROM_array is array(0 to 63) of unsigned (7 downto 0);
             
     -- Beispieltext
     signal memory_source_ENCR : ROM_array   := (
   
     1 => (to_unsigned(character'pos('A'), 8)), 2 => (to_unsigned(character'pos('A'), 8)), 3 => (to_unsigned(character'pos('A'), 8)),
     4 => (to_unsigned(character'pos('A'), 8)), 5 => (to_unsigned(character'pos('A'), 8)), 6 => (to_unsigned(character'pos(' '), 8)),
     7 => (to_unsigned(character'pos('A'), 8)), 8 => (to_unsigned(character'pos('A'), 8)), 9 => (to_unsigned(character'pos('A'), 8)),
     10 => (to_unsigned(character'pos('A'), 8)), 11 => (to_unsigned(character'pos('A'), 8)), 12 => (to_unsigned(character'pos('A'), 8)), 

     others => (to_unsigned(character'pos('A'), 8)));  
    
     begin       
      process (CLK) begin 
           
           Source_DOUT <= memory_source_ENCR(to_integer(Source_ADDR));

      end process;
    end RTL;
