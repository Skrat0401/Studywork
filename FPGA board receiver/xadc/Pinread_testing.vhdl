
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity Pinread_top is
  port (
        Clk     : in std_logic;
        Rst     : in std_logic;
        output  : out std_logic;
        input_pin : in std_logic;
        LED_B   : out std_logic;
        LED_A   : out std_logic;
        LED_C   : out std_logic
     );
end Pinread_top;

architecture Behavioral of Pinread_top is
    signal clockcounter   : unsigned (19 downto 0):= (others=>'0');
    signal outputclock    : std_logic := '0';
    signal output_i       : std_logic := '0';
begin
--LED_B <= '1'; --Test für programming device
slowclock : process (Clk) begin -- Prozess für die Outputclock
    if (rising_edge(Clk)) then
        if (clockcounter < 100000) then clockcounter <= clockcounter + 1; -- 1kHz
        else
            LED_A <= '1'; --Test
            clockcounter <= "00000000000000000000";
            outputclock <= not outputclock;           
        end if;
    end if;
end process slowclock;

set_out : process (Outputclock) begin
if(rising_edge(outputclock)) then
    output_i <= not output_i;
    output<= output_i;
end if;
end process set_out;

LED : process (Outputclock) begin
if(rising_edge(Clk)) then
  if(Rst = '1') then
    LED_C <= '0';
    LED_B <= '1';
  elsif(RSt = '0') then
        LED_B <= '0';
    if(input_pin = '1') then
      LED_C <= '1';
    end if;
end if;
end if;
end process LED;

end Behavioral;
