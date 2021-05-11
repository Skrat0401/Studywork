
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity synchronization is
    Port(Clk         : in  std_logic;
         Rst         : in  std_logic;
         LED_B       : out std_logic;
         syn_success : out std_logic;
         data_in_pin : in  std_logic;
         data_out    : out unsigned(7 downto 0);
         output_addr : out unsigned(7 downto 0);
         syn_en      : in  std_logic);
end synchronization;

architecture Behavioral of synchronization is
    signal reg             : std_logic_vector(7 downto 0);
    signal dec             : std_logic;
    signal clockcounter    : unsigned(19 downto 0) := (others => '0');
    signal synclock        : std_logic             := '0';
    signal outputcounter   : integer;
    signal enable_data_out : std_logic;
    signal out_addr_buffer : unsigned(7 downto 0);
begin

    decision : process(synclock, Rst)
    begin
        if (Rst = '0') then
            dec <= '0';
        elsif (rising_edge(synclock)) then
            if (data_in_pin = '0') then
                dec <= '0';
            else
                dec <= '1';
            end if;
        end if;
    end process decision;

    shiftreg : process(synclock, Rst)
    begin
        if (Rst = '0') then
            reg <= "00000000";
        elsif (rising_edge(synclock)) then
            if (syn_en = '1') then
                reg(0) <= data_in_pin;
                reg(1) <= reg(0);
                reg(2) <= reg(1);
                reg(3) <= reg(2);
                reg(4) <= reg(3);
                reg(5) <= reg(4);
                reg(6) <= reg(5);
                reg(7) <= reg(6);
            end if;
        end if;
    end process shiftreg;

    slowclock : process(Clk, Rst)
    begin
        if (Rst = '0') then
            clockcounter <= "00000000000000000000";
        elsif (rising_edge(Clk)) then
            if (clockcounter < 100000) then
                clockcounter <= clockcounter + 1; -- 1kHz
            else
                clockcounter <= "00000000000000000000";
                synclock     <= not synclock;
                LED_B        <= '1';    --Test für programming device
            end if;
        end if;
    end process slowclock;

    decisionstart : process(Clk, Rst, synclock)
    begin
        if (Rst = '0') then
            syn_success     <= '0';
            enable_data_out <= '0';
        elsif (rising_edge(synclock)) then
            if (reg = "11111111") then  -- code for start
                syn_success     <= '1';
                enable_data_out <= '1';
            end if;
        end if;
    end process;

    Output_to_main : process(Rst, synclock)
    begin
        if (Rst = '0') then
            output_addr     <= "00000000";
            outputcounter   <= 0;
            data_out        <= "00000000";
            out_addr_buffer <= "00000000";
        elsif (rising_edge(synclock) and enable_data_out = '1') then
            if (outputcounter < 7) then
                outputcounter <= outputcounter + 1;
            else
                if (out_addr_buffer < "01000000") then
                    out_addr_buffer <= out_addr_buffer + 1;
                    output_addr     <= out_addr_buffer;
                    data_out        <= unsigned(reg);
                    outputcounter <= 0;
                end if;
            end if;
        end if;

    end process Output_to_main;
end Behavioral;
