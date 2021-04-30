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
    
    component memory_syn
        port(
            Clk         : in  std_logic;
            target_addr : in  unsigned(7 downto 0);
            data_in     : in  unsigned(7 downto 0);
            output_addr : in  unsigned(7 downto 0);
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


begin 
    
    memory_synchronization : memory_syn
        port map(
            Clk => Clk,
            target_addr => memory_syn_target_addr,
            data_in => data,
            output_addr => open,
            data_out => open          
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