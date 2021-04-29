
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Testbench_synchronisation is
--  Port ( );
end Testbench_synchronisation;

architecture Behavioral of Testbench_synchronisation is
    signal T_Clk                : std_logic;
    signal T_Rst                : std_logic;
    signal T_data_in_pin        : std_logic;
    signal T_syn_en             : std_logic;
    signal T_data_out           : std_logic_vector (7 downto 0);
    signal T_syn_success        : std_logic;
    signal T_LED_B              : std_logic;
    signal T_data               : std_logic_vector (30 downto 0);
    signal T_clockcounter       : unsigned (19 downto 0):= (others=>'0');
    signal T_synclock           : std_logic := '0';
    signal T_data_counter       : integer;
    
    component synchronisation
        Port ( 
           clk              : in std_logic;
           Rst              : in std_logic;
           LED_B            : out std_logic;
           syn_success      : out std_logic;
           data_in_pin      : in std_logic;
           data_out         : out std_logic_vector (7 downto 0);
           syn_en           : in STD_LOGIC);
    end component synchronisation;
begin
    
    DUT: synchronisation port map (
        Clk => T_Clk,
        Rst => T_Rst,
        syn_en => T_syn_en,
        LED_B => open,
        syn_success => T_syn_success,
        data_in_pin => T_data_in_pin,
        data_out => T_data_out          
    );
reset : process 
  begin
     wait for 5 ns; T_Rst <= '0';
     wait for 4 ns; T_Rst <= '1';
     wait;
  end process reset;

count: process 
    begin
     T_Clk <= '0';
     wait for 5 ns;
     T_Clk <= '1';
     wait for 5 ns;
 end process count;
 
 T_syn_en <= '1';
 T_data<= "0011111110010101010101001010100";
 
     
slowclock : process (T_Clk) begin
    if(T_Rst = '0') then
        T_clockcounter <= "00000000000000000000"; 
        T_data_counter <= 0;
    elsif (rising_edge(T_Clk)) then
        if (T_clockcounter < 100000) then T_clockcounter <= T_clockcounter + 1; -- 1kHz
        else
            T_clockcounter <= "00000000000000000000";
            T_synclock <= not T_synclock;
            T_data_in_pin <= T_data(T_data_counter);
            T_data_counter <= T_data_counter + 1;
        end if;
    end if;
end process slowclock; 

end Behavioral;
