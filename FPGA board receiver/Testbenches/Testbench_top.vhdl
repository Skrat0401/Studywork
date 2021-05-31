
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Testbench_Top is
end Testbench_Top;

architecture Behavioral of Testbench_Top is

    component decryption_top
        port(
            Clk             : in  std_logic;
            Rst             : in  std_logic;
            enable          : in  std_logic;
            data_in_pin     : in  std_logic;
            sw              : in  std_logic_vector(8 downto 1);
            LED_syn_success : out std_logic
        );
    end component decryption_top;

    signal T_Clk             : std_logic;
    signal T_Rst             : std_logic;
    signal T_enable          : std_logic;
    signal T_data_in_pin     : std_logic;
    signal T_sw              : std_logic_vector(8 downto 1);
    signal T_LED_syn_success : std_logic;
    signal T_data            : std_logic_vector(533 downto 0);
    signal T_outputcounter   : integer;
    signal T_clockcounter    : unsigned(19 downto 0) := (others => '0');
    signal T_data_counter    : integer;
    signal T_synclock        : std_logic             := '0';

begin

    DUT : component decryption_top
        port map(
            Clk             => T_Clk,
            Rst             => T_Rst,
            enable          => T_enable,
            data_in_pin     => T_data_in_pin,
            sw              => T_sw,
            LED_syn_success => T_LED_syn_success
        );

    T_sw   <= "00000000";
   -- T_data <= "001111111101010101010100101010001010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010";
--T_data <= "00000000000000111111111110110101010010101000101111111110100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001010101010100100101010101010010010101010101001001000001";
    T_data <= "000000000000001111111101101100000110001111011100101101100101111110001000001111110110010110101100001111110000010101100001100100011100101000010101101010101101010000101001110100100010010111001110000111011011101011110100011011010101111100111011111101100110110101011011001100111110011001001101000111111011111011111000011101010110111101011111001111111111111001111101011110110111011101101011010100110010011111001110000110011011001011100100010011010001101110110110111010000101010100101011110100100010000111000110000011011001101010110000111000";
    slowclock : process(T_Clk)
    begin
        if (T_Rst = '0') then
            T_clockcounter <= "00000000000000000000";
            T_data_counter <= 32;
        elsif (rising_edge(T_Clk)) then
            if (T_clockcounter < 100000) then
                T_clockcounter <= T_clockcounter + 1; -- 1kHz
            else
                T_clockcounter <= "00000000000000000000";
                T_synclock     <= not T_synclock;       
            end if;
        end if;
    end process slowclock;

    Output_serial : process(T_Rst, T_synclock)
    begin
        if (T_Rst = '0') then
            T_outputcounter <= 533;
            T_data_in_pin   <= '0';
        elsif (rising_edge(T_synclock)) then
            T_data_in_pin   <= T_data(T_outputcounter);
            T_outputcounter <= T_outputcounter - 1;
            if (T_outputcounter < 1) then
                T_outputcounter <= 0;
            end if;
        end if;
    end process Output_serial;

    reset : process
    begin
        wait for 5 ns;
        T_Rst <= '0';
        wait for 4 ns;
        T_Rst <= '1';
        wait;
    end process reset;

  --  enable : process
  --  begin
      --  wait for 5 ns;
      --  T_enable <= '0';
       -- wait for 100 ms;
        T_enable <= '1';
   --     wait;
   -- end process enable;

    count : process
    begin
        T_Clk <= '0';
        wait for 5 ns;
        T_Clk <= '1';
        wait for 5 ns;
    end process count;

end Behavioral;
