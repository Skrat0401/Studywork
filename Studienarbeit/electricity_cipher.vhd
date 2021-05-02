    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity electricity_cipher is
      port (
            Clk     : in std_logic;
            Rst     : in std_logic; --aktive low
            ADDRKey : in std_logic_vector(7 downto 0));
           
    end electricity_cipher;
    
    architecture RTL of electricity_cipher is
      
      component source_mem_ENCR is
         port ( 
             Clk          : in  std_logic;
             Source_ADDR  : in  unsigned(7 downto 0); 
             Source_DOUT        : out unsigned(7 downto 0));   
      end component;
      
      component target_mem_ENCR
          port(
              Clk            : in  std_logic;
              Target_EN_ADDR : in  unsigned(7 downto 0);
              DATIN_ENCR          : in  unsigned(7 downto 0);
              DATOUT_ENCR         : out unsigned(7 downto 0);
              Source_DE_ADDR : in  unsigned(7 downto 0)
          );
      end component target_mem_ENCR; 
      
      component target_mem_DECR
          port(
              Clk               : in  std_logic;
              Target_DE_ADDR    : in  unsigned(7 downto 0);
              DATIN_DECR        : in  unsigned(7 downto 0)
          );
      end component target_mem_DECR; 
      
      component Random_Number_8
          port(
              Clk    : in  std_logic;
              Rst    : in  std_logic;
              KeyIn  : in  unsigned(7 downto 0);
              reset_Number : in std_logic;
              RanNum : out unsigned(8 downto 1)
          );
      end component Random_Number_8;
      
      component ROMKey
          generic(
              L_BITS : natural;
              M_BITS : natural
          );
          port(
              ADDR : in  std_logic_vector(L_BITS - 1 downto 0);
              DATA : out unsigned(M_BITS - 1 downto 0)
          );
      end component ROMKey;
      
      signal Source_EN_ADDR : unsigned(7 downto 0) := "00000000";
      signal Source_DE_ADDR : unsigned(7 downto 0) := "00000000";
      signal Target_EN_ADDR : unsigned(7 downto 0) := "00000000";
      signal Target_DE_ADDR : unsigned(7 downto 0) := "00000000";
      signal DReg, DOut     : unsigned(7 downto 0);
      signal RanNum         : unsigned(7 downto 0);
      signal KeyInInt       : unsigned(7 downto 0);
      signal DATOUT         : unsigned(7 downto 0);
      signal DATOUT_DECR    : unsigned(7 downto 0);
      signal reset_Number	: std_logic;
      
  begin 
     
      source_mem_E: source_mem_ENCR 
      port map (
          Clk => Clk,
          Source_ADDR => Source_EN_ADDR, 
          Source_DOUT => DReg);
          
      target_mem_E : target_mem_ENCR 
      port map (
          Clk => Clk,
          Target_EN_ADDR => Target_EN_ADDR,
          DATIN_ENCR => DOut,
          DATOUT_ENCR => DATOUT,
          Source_DE_ADDR => Source_DE_ADDR);
          
      target_mem_D : target_mem_DECR
      port map (
          Clk => Clk,
          Target_DE_ADDR => Target_DE_ADDR, 
          DATIN_DECR => DATOUT_DECR);
      
      RanNumber : Random_Number_8 
      port map(
          Clk => Clk,
          Rst => Rst,
          KeyIn => KeyInInt,
          reset_Number => reset_Number,
          RanNum => RanNum);
          
      ROMKey_mem : ROMKey  
      generic map(
          L_BITS => 8, 
          M_BITS => 8) 
      port map (
           ADDR => ADDRKey,
           DATA => KeyInInt);


encryption : process(Clk,Rst) begin
    if(Rst = '0') then
        Source_EN_ADDR <= "00000000";
        Source_DE_ADDR <= "00000000";
        Target_EN_ADDR <= "00000000";
        Target_DE_ADDR <= "00000000";
        reset_Number <= '0';
    end if;
    if(Source_EN_ADDR < "00111111") then  
    for i in 0 to 63 loop
           if rising_edge(Clk) then
             DOut <= RanNum xor DReg;
             Source_EN_ADDR <= Source_EN_ADDR + 1;
             Target_EN_ADDR <= Target_EN_ADDR + 1;
           end if;
       end loop;
    end if; 
   
    if(Source_EN_ADDR > "00111100") then
    reset_Number <= '0'; 
    
    for i in 0 to 63 loop
           if rising_edge(Clk) then
             DATOUT_DECR <= RanNum xor DATOUT;
             Target_DE_ADDR <= Target_DE_ADDR + 1;
             Source_DE_ADDR <= Source_DE_ADDR + 1;
             end if;
       end loop;
	end if;
	 if(Source_EN_ADDR = "00111110") then 
        reset_Number <= '1';
    end if;
end process encryption;

--decryption : process(Clk,Rst) begin
--    if(Rst = '0') then
--        Source_EN_ADDR <= "00000000";
--        Source_DE_ADDR <= "00000000";
--        Target_EN_ADDR <= "00000000";
--        Target_DE_ADDR <= "00000000";
--    end if;
-- if(Source_EN_ADDR = "00011111") then
--   for i in 0 to 63 loop
--           if rising_edge(Clk) then
--             DATOUT_DECR <= RanNum xor DATOUT;
--             Target_DE_ADDR <= Target_DE_ADDR + 1;
--             Source_DE_ADDR <= Source_DE_ADDR + 1;
--             end if;
--       end loop;
--     end if;
--end process decryption;

    end RTL;