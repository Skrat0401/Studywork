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
      
      component memory_target is
         port ( 
             Clk              : in  std_logic;
             Target_EN_ADDR   : in  unsigned (7 downto 0); 
             data_in          : in  unsigned (7 downto 0); 
             output_addr      : in  unsigned (7 downto 0); 
             data_out         : out unsigned (7 downto 0));    
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
      
      component Key
          generic(
              L_BITS : natural;
              M_BITS : natural
          );
          port(
              ADDR : in  std_logic_vector(L_BITS - 1 downto 0);
              DATA : out unsigned(M_BITS - 1 downto 0)
          );
      end component Key;
      
      signal Source_EN_ADDR : unsigned(7 downto 0) := "00000000";
      signal DReg     : unsigned(7 downto 0);
      signal RanNum         : unsigned(7 downto 0);
      signal KeyInInt       : unsigned(7 downto 0);
      signal reset_Number   : std_logic;
      signal counter        : integer;
      signal ADDRKey        : std_logic_vector(7 downto 0);
      signal clockcounter   : unsigned (15 downto 0):= (others=>'0');
      signal outputclock    : std_logic;
      signal Target_EN_ADDR : unsigned (7 downto 0);
      signal data_in : unsigned (7 downto 0);
      signal output_addr : unsigned (7 downto 0);
      signal data_out : unsigned (7 downto 0);
      signal outputcounter : integer;
  begin 
      target_mem_E: memory_target
      port map (
          Clk  => Clk,            
          Target_EN_ADDR => Target_EN_ADDR,   
          data_in => data_in, 
          output_addr =>  output_addr,    
          data_out =>  data_out       
      );
     
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
          
      ROMKey_mem : Key  
      generic map(
          L_BITS => 8, 
          M_BITS => 8) 
      port map (
           ADDR => ADDRKey,
           DATA => KeyInInt);
           
slowclock : process (Clk) begin -- Prozess für die Outputclock
    if (rising_edge(Clk)) then
        if (clockcounter < 100000) then clockcounter <= clockcounter + 1; -- 1kHz
        else
            clockcounter <= "0000000000000000";
            outputclock <= not outputclock;
        end if;
    end if;
end process slowclock;

AddressKey : process (Clk, enable) begin
  if(enable = '1') then
    if rising_edge(Clk) then
             ADDRKey <= sw;
    end if;
  end if;

end process AddressKey;

Output_serial : process (outputclock, enable) begin
   if(enable = '1') then
    if (rising_edge(outputclock)) then
        if (outputcounter < 8) then
            output <= data_out[outputcounter]; 
            outputcounter <= outputcounter +1;
        else
            output_addr <= output_addr + 1;
            outputcounter <= 0;
        end if;
        
    end if;
  end if;      
end process Output_serial;

encryption : process (Clk,Rst, enable) begin
    if(Rst = '0') then
        Source_EN_ADDR <= "00000000";
        Target_EN_ADDR <= "00000000";
        output_addr <= "00000000";
        reset_Number <= '0';
        outputcounter <= 0;
        counter <= 0;
    end if;
   if(enable = '1') then
    if(counter < 65) then  
           if rising_edge(Clk) then
             data_in <= RanNum xor DReg;
             Source_EN_ADDR <= Source_EN_ADDR + 1;
             Target_EN_ADDR <= Target_EN_ADDR + 1;
             counter <= counter + 1;
           end if;
    end if; 
  end if; 
end process encryption;
end RTL;