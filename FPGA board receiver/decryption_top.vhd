library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
    
entity decryption_top is
  port (
        Clk         : in std_logic; --100MHz
        Rst         : in std_logic; --aktive low
        enable      : in std_logic; --switch r2
        data_in_pin : in std_logic;
        sw          : in std_logic_vector (8 downto 1)
        -- output   : out std_logic
           );
           
end decryption_top;
    
architecture RTL of decryption_top is
    
    signal LED : std_logic;
    signal syn_success : std_logic;
    signal data : unsigned(7 downto 0);
    
    component mem_target_decr
        port(
            Clk              : in  std_logic;
            Rst              : in  std_logic;
            DATOUT_DECR      : in  unsigned(7 downto 0);
            DATOUT_ADDR      : in  unsigned(7 downto 0);
            Target_Data_Decr : out unsigned(7 downto 0);
            Target_Addr_Decr : in  unsigned(7 downto 0)
        );
    end component mem_target_decr;
    
    component decoder
        port(
            Clk         : in  std_logic;
            Rst         : in  std_logic;
            enable      : in  std_logic;
            fullcounter : in  std_logic;
            ADDR_Key    : in  std_logic_vector(7 downto 0);
            DATOUT_DECR : out unsigned(7 downto 0);
            DATOUT_ADDR : out unsigned(7 downto 0);
            DATIN_ENCR  : in  unsigned(7 downto 0);
            DATIN_ADDR  : out unsigned(7 downto 0)
        );
    end component decoder;
    
    component memory_syn
        port(
            Clk         : in  std_logic;
            target_addr : in  unsigned(7 downto 0);
            data_in     : in  unsigned(7 downto 0);
            output_addr : in  unsigned(7 downto 0);
            fullcounter : out std_logic;
            data_out    : out unsigned(7 downto 0)
        );
    end component memory_syn;
    
    component synchronization
        port(
            clk         : in  std_logic;
            Rst         : in  std_logic;
            LED_B       : out std_logic;
            syn_success : out std_logic;
            data_in_pin : in  std_logic;
            data_out    : out unsigned(7 downto 0);
            output_addr : out unsigned(7 downto 0);
            syn_en      : in  std_logic
        );
    end component synchronization;
    signal memory_syn_target_addr : unsigned(7 downto 0);
    signal fullcounter : std_logic;
    signal data_for_decode : unsigned(7 downto 0);
    signal addr_for_decode : unsigned(7 downto 0);
    signal DATOUT_DECR : unsigned(7 downto 0);
    signal DATOUT_ADDR : unsigned(7 downto 0);


begin 
    
    memory_for_decryption : mem_target_decr
        port map(
            Clk              => Clk,
            Rst              => Rst,
            DATOUT_DECR      => DATOUT_DECR,
            DATOUT_ADDR      => DATOUT_ADDR,
            Target_Data_Decr => open,
            Target_Addr_Decr => open
        );
    
    decode_unit : component decoder
        port map(
            Clk         => Clk,
            Rst         => Rst,
            enable      => enable,
            fullcounter => fullcounter,
            ADDR_Key    => sw,
            DATOUT_DECR => DATOUT_DECR,
            DATOUT_ADDR => DATOUT_ADDR,
            DATIN_ENCR  => data_for_decode,
            DATIN_ADDR  => addr_for_decode
        );
    
    memory_synchronization : memory_syn
        port map(
            Clk => Clk,
            target_addr => memory_syn_target_addr,
            data_in => data,
            output_addr => addr_for_decode,
            fullcounter => fullcounter,
            data_out => data_for_decode          
        );
     
     synchronization_input : synchronization
        port map (
            Clk => Clk,
            Rst => Rst,
            LED_B => LED,
            syn_success => syn_success,
            data_in_pin => data_in_pin,
            data_out => data,
            output_addr => memory_syn_target_addr,
            syn_en => enable                      
        );

end RTL;