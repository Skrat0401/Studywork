    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity electricity_cipher is
      port (
            Clk     : in std_logic; --100MHz
            Rst     : in std_logic; --aktive low
            enable  : in std_logic; --switch r2
            sw      : in std_logic_vector (8 downto 1);
            output  : out std_logic
           );
           
    end electricity_cipher;
    
    architecture RTL of electricity_cipher is
      
      component memory_source is
         port ( 
             Clk          : in  std_logic;
             Source_ADDR  : in  unsigned(7 downto 0); 
             CDOUT        : out unsigned(7 downto 0));   
      end component;
      
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
      signal DReg, DOut     : unsigned(7 downto 0);
      signal RanNum         : unsigned(7 downto 0);
      signal KeyInInt       : unsigned(7 downto 0);
      signal reset_Number   : std_logic;
      signal counter        : integer;
      signal  ADDRKey       :  std_logic_vector(7 downto 0);
  begin 
     
      source_mem_E: memory_source 
      port map (
          Clk => Clk,
          Source_ADDR => Source_EN_ADDR, 
          CDOUT => DReg);

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


AddressKey : process (Clk) begin
  if(enable = '1') then
    if rising_edge(Clk) then
             ADDRKey <= sw;
    end if;
  end if;

end process AddressKey;

Output_serial : process (clk) begin
   if(enable = '1') then
    if rising_edge(Clk) then
     --       output <=  output auf langsamere clock ->process hinzufügen
    end if;
  end if;      
end process Output_serial;

encryption : process(Clk,Rst) begin
    if(Rst = '0') then
        Source_EN_ADDR <= "00000000";
        reset_Number <= '0';
        counter <= 0;
    end if;
   if(enable = '1') then
    if(counter < 65) then  
           if rising_edge(Clk) then
             DOut <= RanNum xor DReg;
             Source_EN_ADDR <= Source_EN_ADDR + 1;
             counter <= counter + 1;
           end if;
    end if; 
  end if; 
end process encryption;



    end RTL;