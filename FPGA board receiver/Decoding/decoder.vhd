library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity decoder is
      port (
            Clk     	: in std_logic;
            Rst     	: in std_logic; --aktive low
            enable  	: in std_logic; --switch r2 
            fullcounter : in std_logic; --signalisiert Speicher ist voll
            ADDR		: in std_logic;
            DATOUT_DECR : out std_logic_vector(7 downto 0);
            DATOUT_ADDR : out std_logic_vector(7 downto 0)); -- entschlüsselte Daten
    end decoder;
    
    architecture RTL of decoder is
      
      component Random_Number_8
          port(  
         	 	Clk 				: in std_logic;
        		Rst 				: in std_logic;
        		KeyIn 				: in unsigned (7 downto 0);
        		reset_Number 		: in std_logic;
        		RanNum 				: out unsigned (8 downto 1);
        		RanNum_targetadress : out unsigned (7 downto 0));
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
     	
     component Random_Number_8_mem                                 
        port ( Clk    				: in  std_logic;
               RanNum_targetadress 	: in unsigned 	(7 downto 0);
               RanNum_In 			: in  unsigned 	(7 downto 0);
               RanNum_sourceadress 	: in unsigned 	(7 downto 0);
               RanNum_Out 			: out  unsigned (7 downto 0)); 
    	end component Random_Number_8_mem;
    	 
      
      signal Source_DE_ADDR : unsigned(7 downto 0) := "00000000";
      signal Target_DE_ADDR : unsigned(7 downto 0) := "00000000";
      signal RanNum         : unsigned(7 downto 0);
      signal KeyInInt       : unsigned(7 downto 0);
      signal RanNum_ADDR    : unsigned(7 downto 0):= "00000000";
      signal reset_Number	: std_logic;  
      signal counter        : integer;
      signal ADDRKey        : std_logic_vector(7 downto 0);

  begin 
   
      RanNumber_mem: Random_Number_8_mem 
      port map (
          Clk => Clk,
          RanNum_targetadress =>
          RanNum_In			  =>
          RanNum_sourceadress =>
          RanNum_Out 		  => 
          Source_ADDR => Source_EN_ADDR, 
          CDOUT => DReg);

      RanNumber : Random_Number_8 
      port map(
          Clk => Clk,
          Rst => Rst,
          KeyIn => KeyInInt,
          reset_Number => reset_Number,
          RanNum => RanNum,
          RanNum_targetadress => RanNum_ADDR );
          
      ROMKey_mem : Key  
      generic map(
          L_BITS => 8, 
          M_BITS => 8) 
      port map (
           ADDR => ADDRKey,
           DATA => KeyInInt); 

AddressKey : process (Clk, enable) begin
  if(enable = '1') then
    if rising_edge(Clk) then
             ADDRKey <= ADDR ;
    end if;
  end if;
end process AddressKey;


decryption : process(Clk,Rst, enable) begin
    if(Rst = '0') then
        Source_DE_ADDR <= "00000000";
        Target_DE_ADDR <= "00000000";
        reset_Number <='0';
        counter <= 0;
    end if;                
    
 	elsif(enable = '1') then
 		if (fullcounter = '1')then
   			if(counter < 63) then
           		if rising_edge(Clk) then
             		DATOUT_DECR <= RanNum xor DATOUT;
             		Target_DE_ADDR <= Target_DE_ADDR + 1;
             		Source_DE_ADDR <= Source_DE_ADDR + 1;
             		counter <= counter +1;
            	 end if;
       		end if;
     	end if;   
     end if;
end process decryption;

    end RTL;